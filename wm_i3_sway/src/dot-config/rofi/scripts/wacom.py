#!/usr/bin/python3
"""Rofi script to map wacom tablet to output to be selected.

Save this script under ~/.config/rofi/scripts/wacom.py with executable rights, and call as::

    rofi -matching fuzzy -show wacom -modi "wacom:~/.config/rofi/scripts/wacom.py"

"""

import subprocess
import re
import sys
import time


def find_screens():
    """Return dict of possible scrrens ``{screen_name: (res_x, res_y)}``."""
    res = subprocess.run(['xrandr', '--listactivemonitors'], capture_output=True)
    out = res.stdout.decode().splitlines()
    expected_len = int(out[0].split()[-1]) # first line is just "monitors: ##"
    out = out[1:]
    assert len(out) == expected_len
    r = re.compile(r'(\d+)/\d+x(\d+)/\d+\+\d+\+\d+\s+(\S+)')
    screens = {}
    for line in out:
        m = r.search(line)
        if not m:
            continue
        groups = m.groups()
        screens[groups[-1]] = tuple(int(d) for d in groups[:-1])
    return screens

def find_wacom_tablet():
    res = subprocess.run(['xsetwacom', '--list', 'devices'], capture_output=True)
    out = res.stdout.decode().splitlines()
    stylus = {}
    for line in out:
        s = line.split()
        if s[-1] == 'STYLUS':
            i = s.index('id:')
            stylus[int(s[i + 1])] = ' '.join(s[:i])
    return stylus



def get_wacom_prop(device, prop):
    res = subprocess.run(['xsetwacom', 'get', device, prop], capture_output=True)
    return res.stdout.decode()

def set_wacom_prop(device, prop, value=None):
    cmd = ['xsetwacom', 'set', device, prop]
    if value is not None:
        cmd.append(value)
    res = subprocess.run(cmd, capture_output=True)
    if not res.returncode == 0:
        raise ValueError("subprocess failed" + str(res))


def map_wacom_output(wacom_device, output, res_x, res_y):
    dev = str(wacom_device)
    set_wacom_prop(dev, 'resetArea', None)
    time.sleep(0.1)
    out = get_wacom_prop(dev, 'Area').split()
    assert out[0] == out[1] == '0'
    area_x, area_y = int(out[2]), int(out[3])
    #  print('orig area = ', area_x, area_y)
    # fix aspect ratios by cropping tablet area
    if area_x / area_y < res_x / res_y:
        area_y = int(area_x * res_y / res_x)  # reduces area_y
        #  print('crop area_y to ', area_y)
    elif area_x / area_y > res_x / res_y:
        area_x = int(area_y * res_x / res_y)  # reduce area_x
        #  print('crop area_x to ', area_x)
    set_wacom_prop(dev, 'Mode', 'Absolute')
    set_wacom_prop(dev, 'Area', f'0 0 {area_x:d} {area_y:d}')
    set_wacom_prop(dev, 'MapToOutput', output)


def main():
    """Setup as rofi script."""
    tablets = find_wacom_tablet()
    if len(tablets) == 0:
        raise ValueError("No tablet found")
    screens = find_screens()
    if len(screens) == 0:
        raise ValueError("No screen found")
    if len(sys.argv) <= 1:
        # first call without arguments: allow to select a screen on which
        for stylus_id, stylus_name in tablets.items():
            for screen_name, res in screens.items():
                print(f"{stylus_id} on {screen_name:10s} {res[0]:4d}x{res[1]:4d} | {stylus_name}")
            return
    # second rofi call with argument selecting amongst previously printed onces
    stylus_id, _, screen = sys.argv[1].split()[:3]
    stylus_id = int(stylus_id)
    if stylus_id not in tablets:
        raise ValueError(f"Unexpected stylus id, got: {stylus_id!s}")
    if screen not in screens:
        raise ValueError(f"Unexpected screen name, got: {screen!s}")
    res_x, res_y = screens[screen]
    map_wacom_output(str(stylus_id), screen, res_x, res_y)

if __name__ == "__main__":
    main()
