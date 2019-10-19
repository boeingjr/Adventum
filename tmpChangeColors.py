import re
import os

filePointer = open("Colors.lua", "r")
fileContent = filePointer.read()
filePointer.close()

allColors = re.findall(r"\w+ = \{r=\d+, g=\d+, b=\d+, a=\d\}", fileContent)
for c in allColors:
    m = re.search(r"(\w+) = \{r=(\d+), g=(\d+), b=(\d+), a=\d\}", c)
    name = m.group(1)
    r = "{0:.2f}".format(float(m.group(2)) / 255.0)
    g = "{0:.2f}".format(float(m.group(3)) / 255.0)
    b = "{0:.2f}".format(float(m.group(4)) / 255.0)
    print "    {} = {{r={}, g={}, b={}, a=1}},".format(name, r, g, b)

