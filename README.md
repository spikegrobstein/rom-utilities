# ROM Utilities

It contains a collection of scripts which are used to quickly curate a list of gaming ROMs; specifically for cases
when you have multiple versions of a game. This isn't really designed for public consumption; the code isn't
pretty, there are probably bugs and it's really designed for my own personal preferences with regard to
sorting and naming and all that.

## What do?

### Unpack

The `unpack.sh` script automates uncompressing a directory of ROMs. It iterates through all of the files in
the given directory, determines how to uncompress the file(s) (supporting `zip`, `rar`, and `7z`), and unpacks
them. It keeps your archive in a directory called `_COMPLETED` inside the console directory. If the archive
unpacks into a single file, only that file is kept. if It's multiple files, it keeps a directory based on the
basename of the original archive.

Usage:

    ./unpack.sh <rom-dir>

So, if you have `/storage/ROMs/PSP`, containing a slew of PSP ROMs in compressed format, you would run:

    ./unpack /storage/ROMs/PSP

It will then create `/storage/ROMs/PSP/_COMPLETED` which it stashes each archive after it completes. This way,
you can pick up where you left off in the event of an error.

It uses a temporary directory called `_UNPACK` in the directory as well, so if that's left behind, you'll have
to manually clean that up, possibly moving the archive back into the main directory first.

### Makelists

First, you probably want to run `makelists.sh`. This will create a series of list files of your ROMs. You call
it like:

    ./makelists.sh <rom-dir> [ <list-dir> ]

So, given that your roms live at `/storage/ROMs`, you'd probably call:

    ./makelists.sh /storage/ROMs lists

This will create a directory called `lists` filled with files called things like `SNES.list` and
`Atary2600.list`. This is all based on the directory names in your ROMs directory.

If your individual console directories contain a `USA` directory, it'll only list files from there and also
try to list files from `Multi` if you have that. If you don't have `USA`, it'll just list everything in the
directory.

### Curate

Run the `rom-curator.rb` script, passing it a path to a file containing a list of file paths to a single
console's ROMs and the path to an output file:

    ruby rom-curator.rb lists/Lynx.txt lynx.list

The script will iterate through the `lynxroms.txt` file, digesting each filename and grouping what it thinks
are the same game into a nice data structure. Then, it will go through that list, and any singular rom path
will be written out to the output file, but when it encounters a game with multiple files, it'll prompt,
asking for which to keep (all, none, or which?). the choice will be added to the output file (`lynx.list`).

Output looks like:

    Choice: Para Lemi! (5 files)
    1. all
    2. none
    3. Para Lemi! v001 (1997) (PD).lnx
    4. Para Lemi! v002 (1997) (PD).lnx
    5. Para Lemi! v003 (1997) (PD).lnx
    6. Para Lemi! v004 (1997) (PD).lnx
    7. Para Lemi! v005 (1997) (PD).lnx
    Which rom for "Para Lemi!"?

That's about it.

## Credit

Written by Spike Grobstein <me@spike.cx>  
&copy;2016 Spike Grobstein
