import urllib2
import re
import os
import sys
import time
from bs4 import BeautifulSoup

nameAndTitlePattern = "[A-Z0-9][-a-zA-Z0-9'?!:.,+=/ ]*" # this pattern doesn't seem to work properly

QuestIds = []

if len(sys.argv) == 1:
    print "No arguments, exiting"
    exit(0)

MissingAcceptedQuests = []
MissingQuests = []
QuestDB = {}
MissingStartEndLocations = []
MissingStartEndLocationsHash = {}
StartEndLocations = {}

classicRaces = [
    "nil",
    "human",
    "orc",
    "dwarf",
    "night-elf",
    "undead",
    "tauren",
    "gnome",
    "troll",
    "goblin",
]

classicClasses = [
    "nil",
    "warrior",
    "paladin",
    "hunter",
    "rogue",
    "priest",
    "nil",
    "shaman",
    "mage",
    "warlock",
    "nil",
    "druid",
]

classicDifficultyColors = {}
classicDifficultyColors["r4"] = "grey"
classicDifficultyColors["r3"] = "green"
classicDifficultyColors["r2"] = "yellow"
classicDifficultyColors["r1"] = "orange"
classicDifficultyColors["q10"] = "red"

def LevelParse(c):
    m = re.search(r"Level: (\d+)", c)
    if m:
        m = m.group(1)
    else:
        m = "nil"
    return m

def RequiredLevelParse(c):
    m = re.search(r"Requires level (\d+)", c)
    if m:
        m = m.group(1)
    else:
        m = "nil"
    return m
    
def ForSideParse(c):
    m = re.search(r"Side: \[span class=icon-(\w+)\]", c)
    if m:
        m = "\"{}\"".format(m.group(1))
    else:
        m = re.search("Side: Both", c)
        if m:
            m = "\"both\""
        else:
            m = "nil"
    return m

def ForRaceParse(c):
    m = re.search(r"Race: \[race=(\d+)\]", c)
    if m:
        m = "\"{}\"".format(classicRaces[int(m.group(1))])
    else:
        m = "nil"
    return m
    
def ForClassParse(c):
    m = re.search(r"Class: \[class=(\d+)\]", c)
    if m:
        m = "\"{}\"".format(classicClasses[int(m.group(1))])
    else:
        m = "nil"
    return m

def StartEndQuestParse(c, isStart):
    if isStart:
        lowerkey = "start"
        upperkey = "Start"
    else:
        lowerkey = "end"
        upperkey = "End"

    strip = re.search(r"WH.markup.printHtml\(\"(.*\[\\\/ul\])", c).group(1)
    strip = strip.replace("[ul]", "<ul>")
    strip = strip.replace(r"[\/ul]", "</ul>")
    strip = strip.replace("[li]", "<li>")
    strip = strip.replace(r"[\/li]", "</li>")
    lis = BeautifulSoup(strip, features="html.parser").find_all('li')
    li = None
    for l in lis:
        l = str(l)
        if re.search("icon name=quest_{}".format(lowerkey), l):
            li = l
            break
    if not li:
        return "nil"

    li = li.replace("[span=invisible]", "")
    li = li.replace(r"[\/span]", "")
    li = li.replace("[icon name=quest_{}]".format(lowerkey), "")
    li = li.replace(r"[\/icon]", "")
    li = li.replace("<li>", "")
    li = li.replace("</li>", "")
    lis = li.split("[br]")
    r = None
    for l in lis:
        m = re.search(r"{}: \[url=\\\/(\w+)=(\d+)\](.*)\[\\\/url+]".format(upperkey), l)
        _type = "nil"
        _id = "nil"
        _name = "nil"
        _loc = "z=nil,xy=nil"
        if m:
            _type = m.group(1)
            _id = m.group(2)
            _name = m.group(3)
            _key = "{}{}".format(_type,_id)
            if _key in StartEndLocations:
                _loc = StartEndLocations[_key]
            else:
                if not _key in MissingStartEndLocationsHash.keys():
                    MissingStartEndLocations.append(_key)
                    MissingStartEndLocationsHash[_key] = True
        if r:
            r = "{},{{i=\"{}{}\",n=\"{}\",{}}}".format(r, _type, _id, _name, _loc)
        else:
            r = "{{{{i=\"{}{}\",n=\"{}\",{}}}".format(_type, _id, _name, _loc)
    r = "{}}}".format(r)
    return r

def SharableParse(c):
    m = re.search(r"\]Sharable\[", c)
    if m:
        m = "true"
    else:
        m = re.search(r"\]Not sharable\[", c)
        if m:
            m = "false"
        else:
            m = "nil"
    return m
    
def DifficultiesParse(c):
    m = re.search(r"Difficulty: (.*)\[li\]Added in patch", c).group(1)
    if m:
        ls = re.findall(r"\[color=\w+\d+\]\d+\[\\\/color\]", m)
        m = None
        for l in ls:
            dl = re.search(r"\[color=(\w+\d+)\](\d+)\[\\\/color\]", l)
            if m:
                m = "{},{}={}".format(m, classicDifficultyColors[dl.group(1)], dl.group(2))
            else:
                m = "{{{}={}".format(classicDifficultyColors[dl.group(1)], dl.group(2))
        m = "{}}}".format(m)
    else:
        m = "nil"
    return m

def QuickFactsParse(table):
    scriptContents = str(table.find('script'))
    level = LevelParse(scriptContents)
    requiredLevel = RequiredLevelParse(scriptContents)
    forSide = ForSideParse(scriptContents)
    forRace = ForRaceParse(scriptContents)
    forClass = ForClassParse(scriptContents)
    startQuest = StartEndQuestParse(scriptContents, True)
    endQuest = StartEndQuestParse(scriptContents, False)
    isSharable = SharableParse(scriptContents)
    hasDifficulties = DifficultiesParse(scriptContents)
    return "l={},r={},f={},e={},s={},b={},p={},h={},u={}".format(level, requiredLevel, forSide, forRace, forClass, startQuest, endQuest, isSharable, hasDifficulties)

def RequiresParse(table):
    scriptContents = str(table.find('script'))
    questIdMatches = re.findall(r"quest=(\d+)", scriptContents)
    qIds = []
    for qId in questIdMatches:
        if not os.path.isfile("QuestDB/{}.html".format(qId)):
            MissingQuests.append(qId)
        qIds.append(qId)
    return qIds

def UnlocksParse(table):
    scriptContents = str(table.find('script'))
    questIdMatches = re.findall(r"quest=(\d+)", scriptContents)
    qIds = []
    for qId in questIdMatches:
        if not os.path.isfile("QuestDB/{}.html".format(qId)):
            MissingQuests.append(qId)
        qIds.append(qId)
    return qIds

for fileName in os.listdir("StartEndDB"):
    fileNameSearch = re.search(r"^([a-z]+\d+)\.html$", fileName)
    if fileNameSearch:
        startEndId = fileNameSearch.group(1)
        print "---------------------------------------------------------------"
        print "Processing {} for {}".format(fileName, startEndId)
        fileContent = open("StartEndDB/{}".format(fileName), "r").read()
        htmlTree=BeautifulSoup(fileContent, features="html.parser")

        divs = htmlTree.find_all('div')
        zone = "nil"
        for d in divs:
            if re.search(r"^<div>This \w+ can be found in <span", str(d)):
                zone = str(d.find('a').contents)
                zone = zone.replace("[u'", "")
                zone = zone.replace("']", "")
        scripts = htmlTree.find_all('script')
        coords = None
        for s in scripts:
            s = str(s)
            if re.search(r"^<script>var g_mapperData = ", s):
                cs = re.findall(r"\[[0-9.]+,[0-9.]+\]", s)
                for c in cs:
                    m = re.search(r"\[([0-9.]+),([0-9.]+)\]", c)
                    xy = "{{x={},y={}}}".format(m.group(1), m.group(2))
                    if coords:
                        coords = "{},{}".format(coords, xy)
                    else:
                        coords = "{{{}".format(xy)
                if coords:
                    coords = "{}}}".format(coords)
        entry = "z=\"{}\",xy={}".format(zone, coords)
        print "Start and End Table Entry: {}".format(entry)
        StartEndLocations[startEndId] = entry

def AllFiles():
    # for each XXX.html file in QuestDB do
    for fileName in os.listdir("QuestDB"):
        fileNameSearch = re.search(r"^(\d+)\.html$", fileName)
        if fileNameSearch:
            questId = fileNameSearch.group(1)
            print "---------------------------------------------------------------"
            print "fileName: {} Processing for QuestId {}".format(fileName, questId)
            fileContent = open("QuestDB/{}".format(fileName), "r").read()
            htmlTree=BeautifulSoup(fileContent, features="html.parser")
            pageTitle = str(htmlTree.find('title'))
            questTitle = re.search("<title>(.*) - Quest - World of Warcraft</title>", pageTitle).group(1)
            lqes = "  [{}]={{q={},t=\"{}\"".format(questId, questId, questTitle)
            infoboxTable = htmlTree.find('table', class_='infobox')
            infoboxInnerTables = infoboxTable.find_all('table', class_='infobox-inner-table')
            for infoboxInnerTable in infoboxInnerTables:
                quickFacts = None
                requires = None
                unlocks = None
                if infoboxInnerTable.find('th', id='infobox-quick-facts'):
                    quickFacts = QuickFactsParse(infoboxInnerTable)
                    lqes = "{},{}".format(lqes, quickFacts)
                elif infoboxInnerTable.find('th', id='infobox-requires'):
                    requires = RequiresParse(infoboxInnerTable)
                    lqes = "{},c={{{}}}".format(lqes, ",".join(requires))
                elif infoboxInnerTable.find('th', id='infobox-unlocks'):
                    unlocks = UnlocksParse(infoboxInnerTable)
                    lqes = "{},o={{{}}}".format(lqes, ",".join(unlocks))
            lqes = "{},}},".format(lqes)
            print "Quest Table Entry: {}".format(lqes)
            QuestDBFile.write("{}\n".format(lqes))
        else:
            print "fileName: {} Ignoring".format(fileName)
    # end for each XXX.html file in QuestDB do
# end AllFiles

def CharacterFiles(character):
    # for each id in QuestIds do
    for questId in QuestIds:
        fileName = "QuestDB/{}.html".format(questId)
        if os.path.isfile(fileName):
            print "---------------------------------------------------------------"
            print "fileName: {} Processing for QuestId {}".format(fileName, questId)
            fileContent = open(fileName, "r").read()
            htmlTree=BeautifulSoup(fileContent, features="html.parser")
            pageTitle = str(htmlTree.find('title'))
            questTitle = re.search(r"<title>(.*) - Quest - World of Warcraft</title>", pageTitle).group(1)

            splitted = re.split(r"\"", questTitle)
            if len(splitted) > 1:
                questTitle = "\\\"".join(splitted)
            lqes = "  [{}]={{q={},t=\"{}\"".format(questId, questId, questTitle)
            infoboxTable = htmlTree.find('table', class_='infobox')
            infoboxInnerTables = infoboxTable.find_all('table', class_='infobox-inner-table')
            for infoboxInnerTable in infoboxInnerTables:
                quickFacts = None
                requires = None
                unlocks = None
                if infoboxInnerTable.find('th', id='infobox-quick-facts'):
                    quickFacts = QuickFactsParse(infoboxInnerTable)
                    lqes = "{},{}".format(lqes, quickFacts)
                elif infoboxInnerTable.find('th', id='infobox-requires'):
                    requires = RequiresParse(infoboxInnerTable)
                    lqes = "{},c={{{}}}".format(lqes, ",".join(requires))
                elif infoboxInnerTable.find('th', id='infobox-unlocks'):
                    unlocks = UnlocksParse(infoboxInnerTable)
                    lqes = "{},o={{{}}}".format(lqes, ",".join(unlocks))
            lqes = "{},}},".format(lqes)
            print "Quest Table Entry: {}".format(lqes)
            QuestDBFile.write("{}\n".format(lqes))
        else:
            MissingAcceptedQuests.append(questId)
    # end for each id in QuestIds do
# end CharacterFiles

character = re.search(r"trails/(\w+)\.(lua|dat)", sys.argv[1])
if character:
    character = character.group(1)
    lua = "trails/{}.lua".format(character)
    dat = "trails/{}.dat".format(character)
    if os.path.isfile(dat):
        if os.path.isfile(lua):
            if os.path.getmtime(dat) < os.path.getmtime(lua):
                    print "ERROR: dat is older than lua for {}.\nRun fetcher on {} then rerun parser.".format(character, lua)
                    exit(0)
        else:
            print "WARNING: No played quest route for character {} exists".format(character)
    else:
        if os.path.isfile(lua):
            print "ERROR: No dat file created for character {}.\nRun fetcher on {} then rerun parser".format(character, lua)
        else:
            print "ERROR: No played quest route and no dat file for character {} exists".format(character)
        exit(0)
    datTmp = open(dat, "r")
    datDat = datTmp.read()
    datTmp.close()
    qs = re.findall(r"(\d+)", datDat)
    for q in qs:
        QuestIds.append(q)
    print "Creating Quest database for character {}".format(character)
    print "Quest Ids in use: {}".format(", ".join(QuestIds))
else:
    print "Cannot find a character name, possibly wrong file type or missing file"
    exit(0)

QuestDBFile = open("{}QuestDB.lua".format(character), "w+")
QuestDBFile.write("-- q=QuestID, t=Title, l=level, r=required level, f=side, e=race, s=class, b=start, p=stop, h=sharable, u=difficulties, c=requires, o=unlocks, z=zone, xy=coordinates\n")
QuestDBFile.write("AdventumQuestDB = {\n")

CharacterFiles(character)

QuestDBFile.write("}\n")
QuestDBFile.close()

if len(MissingQuests) > 0:
    print "No data for referenced quests: {}".format(", ".join(MissingQuests))
if len(MissingAcceptedQuests) > 0:
    print "No data for accepted quests: {}".format(", ".join(MissingAcceptedQuests))
if len(MissingStartEndLocations) > 0:
    output = ", ".join(MissingStartEndLocations)
    print "No data for start and end locations: {}".format(output)
    print "Run fetcher then rerun parser"
    seis = open("StartEndIds.tmp", "w")
    seis.write(output)
    seis.close()
