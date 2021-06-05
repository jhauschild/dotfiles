#!/usr/bin/env python3
"""a simple wrapper around ghostscript to reduce the (image) size of pdfs"""

import shutil
import os
import subprocess
import warnings

gs_cmd = [
    'gs', '-q', '-dNOPAUSE', '-dBATCH', '-dSAFER', '-sDEVICE=pdfwrite', '-dCompatibilityLevel=1.3',
    '-dPDFSETTINGS=/screen', '-dEmbedAllFonts=true', '-dSubsetFonts=true',
    '-dAutoRotatePages=/None', '-dColorImageDownsampleType=/Bicubic',
    '-dColorImageResolution={res:d}', '-dGrayImageDownsampleType=/Bicubic',
    '-dGrayImageResolution={res:d}', '-dMonoImageDownsampleType=/Bicubic',
    '-dMonoImageResolution={res:d}', '-sOutputFile={fnout!s}', '{fnin!s}'
]


def shrinkpdf(fnin, fnout=None, res=150, backup='.bak.pdf'):
    """shrink `fnin` with ghostscript by reducing the image resolution to `res`.

    If fnout is None, make a backup and work in-place.
    If backup=False, remove the backup afterwards"""
    if fnout is None:
        tmpfn = os.path.splitext(fnin)[0] + backup
        if os.path.exists(tmpfn):
            raise ValueError("backupfile {tmpfn} exists".format(tmpfn=tmpfn))
        shutil.move(fnin, tmpfn)
        fnin, fnout = tmpfn, fnin
    cmd = [c.format(fnin=fnin, fnout=fnout, res=res) for c in gs_cmd]
    print(' '.join(cmd))
    retcode = subprocess.call(cmd)
    if retcode != 0:
        raise RuntimeError("call to gs failed")
    insize = os.stat(fnin).st_size
    outsize = os.stat(fnout).st_size
    if outsize > insize:
        print("WARNING: size increased from {insize:d} to {outsize:d} for {fnin}".format(
            insize=insize, outsize=outsize, fnin=fnin))
        print("-> keep original file")
        shutil.copy(fnin, fnout)
    return retcode


if __name__ == "__main__":
    import sys
    import argparse
    parser = argparse.ArgumentParser(
        description="""shrink a pdf file by reducing the image resolution""")
    parser.add_argument('-b',
                        '--backup',
                        default='.bak.pdf',
                        help="Suffix to append for the backup")
    parser.add_argument('-r',
                        '--resolution',
                        default=150,
                        type=int,
                        help="Resolution for the output file in dpi")
    parser.add_argument('-o',
                        '--out',
                        default=None,
                        help="output filename. '-' means stdout. Leave out for in-place operation")
    parser.add_argument('files', nargs='+', help="files to shrink")
    args = parser.parse_args()
    if len(args.files) > 1:
        if args.out is not None:
            raise ValueError("can't give an output filename for multiple input files")
        for fn in args.files:
            retcode = shrinkpdf(fn, res=args.resolution, backup=args.backup)
    else:
        retcode = shrinkpdf(args.files[0], args.out, res=args.resolution, backup=args.backup)
    sys.exit(retcode)
