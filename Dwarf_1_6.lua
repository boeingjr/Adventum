local node = AdventumClassesNewNode

function Adventum_Dwarf_1_6()
   local nt = {}
   nt.first = node("first", nil):accept(179)
   nt.CompleteManaWyrms = node("CompleteManaWyrms", nt.first):complete(8325)
nt.DeliverManaWyrms = node("DeliverManaWyrms", nt.CompleteManaWyrms):deliver(8325)
nt.AcceptLynxesAndClassTraining = node("AcceptLynxesAndClassTraining", nt.DeliverManaWyrms):accept(8326, 9676, 8328, 8564, 9392, 9393, 8563)
nt.DeliverClassTrainingAcceptCrumb = node("DeliverClassTrainingAcceptCrumb", nt.AcceptLynxesAndClassTraining):deliver(9676, 8328, 8564, 9392, 9393, 8563):accept(10068, 10069, 10070, 10071, 10072, 10073):other("Train and sell")
nt.DeliverCrumbAcceptBigRoundMore = node("DeliverCrumbAcceptBigRoundMore", nt.DeliverClassTrainingAcceptCrumb):deliver(10068, 10069, 10070, 10071, 10072, 10073):accept(8346, 8326, 8336, 8330)
nt.SolaniansJournal = node("SolaniansJournal", nt.DeliverCrumbAcceptBigRoundMore):loot({[8330]={"Solanian's Journal"}})
nt.CompleteLynxes = node("CompleteLynxes", nt.SolaniansJournal):complete(8326)
nt.DeliverLynxes = node("DeliverLynxes", nt.CompleteLynxes):complete(8326)
nt.AcceptToLanthan = node("AcceptToLanthan", nt.DeliverLynxes):accept(8327)
nt.GoToLanthan = node("GoToLanthan", nt.AcceptToLanthan):deliver(8327):other("Kill on the way")
nt.AcceptAggression = node("AcceptAggression", nt.GoToLanthan):accept(8334)
nt.KillAllAndSolaniansOtherTwo = node("KillAllAndSolaniansOtherTwo", nt.AcceptAggression):complete(8334, 8346, 8336, 8330)
   return nt
end
-- q = quest ID, t = title, l = level, r = requires level, n = next in series, o = opens quests, c = required completed quest, a = class
Adventum_Belf_1_12_QDB={
   [9676]={ q=9676, t="Paladin Training", class="PALADIN", o={10068}, l=1, r=1,},
   [8328]={ q=8328, t="Mage Training", class="MAGE",o={10069}, l=1, r=1,},
   [3110]={ q=3110, t="Hallowed Rune", class="PRIEST",o={10070}, l=1, r=1,},
   [9392]={ q=9392, t="Rogue Training", class="ROGUE",o={10071}, l=1, r=1,},
   [9393]={ q=9393, t="Hunter Training", class="HUNTER",o={10072}, l=1, r=1,},
   [8563]={ q=8563, t="Warlock Training", class="WARLOCK",o={10073}, l=1, r=1,},
   [8336]={ q=8336, t="A Fistful of Slivers", l=4, r=2,},
   [8334]={ q=8334, t="Aggression", n=8335, l=4, r=1,},
   [8347]={ q=8347, t="Aiding the Outrunners", c={8335}, l=5, r=3, n=9704,},
   [8350]={ q=8350, t="Completing the Delivery", l=5, r=4,},
   [8335]={ q=8335, t="Felendren the Banished", l=5, r=3, o={8347},},
   [9705]={ q=9705, t="Package Recovery", n=8350, l=5, r=4,},
   [8325]={ q=8325, t="Reclaiming Sunstrider Isle", o={8326}},
   [8327]={ q=8327, t="Report to Lanthan Perilon", n=8334, l=3, r=1,},
   [9704]={ q=9704, t="Slain by the Wretched", n=9705, l=5, r=3,},
   [8330]={ q=8330, t="Solanian's Belongings", o={8345}, l=4, r=2,},
   [8338]={ q=8338, t="Tainted Arcane Sliver", l=4, r=1,},
   [8345]={ q=8345, t="The Shrine of Dath'Remar", c={8330}, l=4, r=2,},
   [8346]={ q=8346, t="Thirst Unending", l=3, r=2,},
   [8326]={ q=8326, t="Unfortunate Measures", c={8325}, n=8327, l=3, r=1,},
}
