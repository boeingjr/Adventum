local nt = {}
local node = AdventumClassesNewNode

Adventum_Undead_1_12_NodeTrail = nt

nt.first = node("first", nil):accept(363)
nt.acceptMindlessOnes = node("acceptMindlessOnes", nt.deliverRudeAwakening):accept(364)
nt.completeMindlessOnes = node("completeMindlessOnes", nt.acceptMindlessOnes):complete(364)
nt.deliverMindlessOnes = node("deliverMindlessOnes", nt.completeMindlessOnes):deliver(364)
nt.acceptBatsWolvesSkellies = node("acceptBatsWolvesSkellies", nt.deliverMindlessOnes):accept(3901, 376):other("Pick up and do your class Scroll quest", "Train DPS skills", "Warlocks, pick up Piercing the Veil for Imp quest")
nt.completeBatsWolvesSkellies = node("completeBatsWolvesSkellies", nt.acceptBatsWolvesSkellies):complete(3901, 376)
nt.deliverBatsWolvesSkellies = node("deliverBatsWolvesSkellies", nt.completeBatsWolvesSkellies):deliver(3901, 376):accept(6395, 380, 3902)
nt.completeBoxes = node("completeBoxes", nt.deliverBatsWolvesSkellies):complete(3902)
nt.lootForMarla = node("lootForMarla", nt.completeBoxes):loot({[6395]={"Samuel's Remains"}})
nt.completeHollow = node("completeHollow", nt.lootForMarla):complete(380)
nt.completeMarla = node("completeMarla", nt.completeHollow):complete(6395)
nt.deliverBoxesMarlaHollow = node("deliverBoxesMarlaHollow", nt.completeMarla):deliver(6395, 380, 3902)
nt.accpetScarlets = node("accpetScarlets", nt.deliverBoxesMarlaHollow):accept(381):other("Priests, accept In Favor of Darkness")
nt.doScarlets = node("doScarlets", nt.accpetScarlets):complete(381)
nt.deliverScarlets = node("deliverScarlets", nt.doScarlets):deliver(381)
nt.acceptRedMsg = node("acceptRedMsg", nt.deliverScarlets):accept(382)
nt.doRedMsg = node("doRedMsg", nt.acceptRedMsg):complete(382)
nt.deliverRedMsg = node("deliverRedMsg", nt.doRedMsg):deliver(382)
nt.acceptVitalInt = node("acceptVitalInt", nt.deliverRedMsg):accept(383):ding(6)
nt.acceptRogueDeal = node("acceptRogueDeal", nt.acceptVitalInt):accept(8)

-- q = quest ID, t = title, l = level, r = requires level, n = next in series, o = opens quests, c = required completed quest, a = class
Adventum_Undead_1_12_QDB={
  [8]={ q=8, t="A Rogue's Deal", l=5, r=1, o={590},},
  [361]={ q=361, t="A Letter Undelivered", l=7, r=4,},
  [367]={ q=367, t="A New Plague", l=6, r=6, n=368,},
  [368]={ q=368, t="A New Plague", l=9, r=6, n=369,},
  [369]={ q=369, t="A New Plague", l=11, r=6, n=492,},
  [492]={ q=492, t="A New Plague", l=11, r=6,},
  [404]={ q=404, t="A Putrid Task", l=6, r=4, o={426},},
  [370]={ q=370, t="At War With The Scarlet Crusade", l=9, r=5, n=371,},
  [371]={ q=371, t="At War With The Scarlet Crusade", l=10, r=5, n=372,},
  [372]={ q=372, t="At War With The Scarlet Crusade", l=12, r=5,},
  [427]={ q=427, t="At War With The Scarlet Crusade", l=8, r=5, n=370, c={383,374},},
  [431]={ q=431, t="Candles of Beckoning", l=10, r=5,},
  [354]={ q=354, t="Deaths in the Family", l=11, r=7, o={355},},
  [445]={ q=445, t="Delivery to Silverpine Forest", l=10, r=9,},
  [5482]={ q=5482, t="Doom Weed", l=6, r=5,},
  [3096]={ q=3096, t="Encrypted Scroll", l=1, r=1, c={364},},
  [407]={ q=407, t="Fields of Grief", l=7, r=4,},
  [365]={ q=365, t="Fields of Grief", l=7, r=4, n=407,},
  [359]={ q=359, t="Forsaken Duties", l=9, r=6, n=360, c={358},},
  [3098]={ q=3098, t="Glyphic Scroll", l=1, r=1, c={364},},
  [5481]={ q=5481, t="Gordo's Task", l=5, r=5, n=5482,},
  [358]={ q=358, t="Graverobbers", l=8, r=4, o={359,405},},
  [3097]={ q=3097, t="Hallowed Scroll", l=1, r=1, c={364},},
  [6395]={ q=6395, t="Marla's Last Wish", l=5, r=3, c={376},},
  [380]={ q=380, t="Night Web's Hollow", l=4, r=2, n=381, c={376},},
  [374]={ q=374, t="Proof of Demise", l=7, r=5, c={427},},
  [409]={ q=409, t="Proving Allegiance", l=12, r=5, n=411,},
  [3901]={ q=3901, t="Rattling the Rattlecages", l=3, r=1, c={364},},
  [356]={ q=356, t="Rear Guard Patrol", l=11, r=6,},
  [366]={ q=366, t="Return the Book", l=8, r=5, n=409,},
  [360]={ q=360, t="Return to the Magistrate", l=9, r=6,},
  [363]={ q=363, t="Rude Awakening", l=1, r=1,},
  [3902]={ q=3902, t="Scavenging Deathknell", l=3, r=2, c={376},},
  [3095]={ q=3095, t="Simple Scroll", l=1, r=1, c={364},},
  [355]={ q=355, t="Speak with Sevren", l=10, r=7, n=408, c={354},},
  [3099]={ q=3099, t="Tainted Scroll", l=1, r=1, c={364},},
  [375]={ q=375, t="The Chill of Death", l=8, r=7,},
  [376]={ q=376, t="The Damned", l=2, r=2, o={380,3902,6395},},
  [410]={ q=410, t="The Dormant Shade", l=10, r=5,},
  [408]={ q=408, t="The Family Crypt", l=13, r=7,},
  [362]={ q=362, t="The Haunted Mills", l=10, r=7,},
  [426]={ q=426, t="The Mills Overrun", l=8, r=6, c={404},},
  [364]={ q=364, t="The Mindless Ones", l=2, r=1, o={3095,3096,3097,3098,3099,3901},},
  [405]={ q=405, t="The Prodigal Lich", l=8, r=5, n=357, c={358},},
  [411]={ q=411, t="The Prodigal Lich Returns", l=12, r=5,},
  [382]={ q=382, t="The Red Messenger", l=5, r=2, n=383,},
  [381]={ q=381, t="The Scarlet Crusade", l=4, r=2, n=382,},
  [383]={ q=383, t="Vital Intelligence", l=5, r=2, o={427},},
  [398]={ q=398, t="Wanted: Maggot Eye", l=10, r=6,},
}
