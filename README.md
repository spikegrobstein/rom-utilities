# ROM Curator

This is a collection of scripts which are used to quickly curate a list of gaming ROMs; specifically for cases
when you have multiple versions of a game. This isn't really designed for public consumption; the code isn't
pretty, there are probably bugs and it's really designed for my own personal preferences with regard to
sorting and naming and all that.

## What's it doing?

Run the script, passing it a path to a file containing a list of file paths to a single console's ROMs and the
path to an output file:

    ruby rom-curator.rb lynxroms.txt lynx.list

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
