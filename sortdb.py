import re
import os
import sys

if len(sys.argv) != 2:
    print "requires file name of DB to check"
    exit(0)

fname = sys.argv[1]

if not os.path.isfile(fname):
    print "requires file name of DB to check"
    exit(0)

titlePattern = "[A-Z0-9][-a-zA-Z0-9'?!:.,+= ]*"
QuestDB = {}

f=open(fname, "r")
lines = f.read().splitlines()
f.close()

toplines = []
endlines = []
dblines = {}
dbkeys = []

notAtDBYet = True
for l in lines:
    if re.search("_QDB={\s*$", l):
        toplines.append(l)
        notAtDBYet = False
    elif re.search("^}\s*$", l):
        endlines.append(l)
    elif notAtDBYet:
        toplines.append(l)
    else:
        m = re.search('^\s*.(\d+).=', l)
        if m:
            qID = int(m.group(1))
            dbkeys.append(qID)
            if qID in dblines:
                print "found duplicate of {}".format(qID)
            dblines[qID] = l

dbkeys.sort()

for l in toplines:
    print l

for q in dbkeys:
    print dblines[q]

for l in endlines:
    print l

