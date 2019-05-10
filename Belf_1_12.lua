local node = AdventumClassesNewNode

function Adventum_Belf_1_12()
   local nt = {}
   nt.first = node("first", nil):accept(8325)
   nt.CompleteManaWyrms = node("CompleteManaWyrms", nt.first):complete(8325)
nt.DeliverManaWyrms = node("DeliverManaWyrms", nt.CompleteManaWyrms):deliver(8325)
nt.AcceptLynxesAndClassTraining = node("AcceptLynxesAndClassTraining", nt.DeliverManaWyrms):accept(8326, 9676, 8328, 8564, 9392, 9393, 8563)
nt.DeliverClassTrainingAcceptCrumb = node("DeliverClassTrainingAcceptCrumb", nt.AcceptLynxesAndClassTraining):deliver(9676, 8328, 8564, 9392, 9393, 8563):accept(10068, 10069, 10070, 10071, 10072, 10073):other("Train and sell")
nt.DeliverCrumbAcceptBigRoundMore = node("DeliverCrumbAcceptBigRoundMore", nt.DeliverClassTrainingAcceptCrumb):deliver(10068, 10069, 10070, 10071, 10072, 10073):accept(8346, 8326, 8336, 8330)
nt.SolaniansJournal = node("SolaniansJournal", nt.DeliverCrumbAcceptBigRoundMore):loot({[8330]={"Solanian's Journal"}})
nt.CompleteLynxes = node("CompleteLynxes", nt.SolaniansJournal):complete(8326)
nt.DeliverLynxes = node("DeliverLynxes", nt.CompleteLynxes):deliver(8326)
nt.AcceptToLanthan = node("AcceptToLanthan", nt.DeliverLynxes):accept(8327)
nt.GoToLanthan = node("GoToLanthan", nt.AcceptToLanthan):deliver(8327):other("Kill on the way")
nt.AcceptAggression = node("AcceptAggression", nt.GoToLanthan):accept(8334)
nt.KillAllAndSolaniansOtherTwo = node("KillAllAndSolaniansOtherTwo", nt.AcceptAggression):complete(8334, 8346, 8336, 8330)
nt.Shrine = node("Shrine", nt.KillAllAndSolaniansOtherTwo):complete(8345)
nt.TurninMost = node("TurninMost", nt.Shrine):deliver(8334, 8346, 8336, 8330, 8345):other("Sell")
nt.TurninAggression = node("TurninAggression", nt.TurninMost):deliver(8334)
nt.AcceptFelendren = node("AcceptFelendren", nt.TurninAggression):accept(8335)
nt.CompleteFelendrenAndPickUpTainted = node("CompleteFelendrenAndPickUpTainted", nt.AcceptFelendren):accept(8338):complete(8335)
nt.HearthOrGoTo = node("HearthOrGoTo", nt.CompleteFelendrenAndPickUpTainted):other("User your Hearthstone"):deliver(8335, 8338)
nt.AcceptAidingTheOutrunners = node("AcceptAidingTheOutrunners", nt.HearthOrGoTo):accept(8347)
nt.DeliverAidingTheOutrunners = node("DeliverAidingTheOutrunners", nt.AcceptAidingTheOutrunners):deliver(8347)
nt.AcceptPickUpFromCorpse = node("AcceptPickUpFromCorpse", nt.DeliverAidingTheOutrunners):accept(9704)
nt.DeliverPickUpFromCorpse = node("DeliverPickUpFromCorpse", nt.AcceptPickUpFromCorpse):deliver(9704)
nt.AcceptPickUpFromCorpseReturn = node("AcceptPickUpFromCorpseReturn", nt.DeliverPickUpFromCorpse):accept(9705)
nt.DeliverPickUpFromCorpseReturn = node("DeliverPickUpFromCorpseReturn", nt.AcceptPickUpFromCorpseReturn):deliver(9705)
nt.AcceptInnQuest = node("AcceptInnQuest", nt.DeliverPickUpFromCorpseReturn):accept(8350)
nt.DeliverInnQuest = node("DeliverInnQuest", nt.AcceptInnQuest):deliver(8350)
--[[
nt.AcceptFirstQuestsInFalconwingSquare = node("AcceptFirstQuestsInFalconwingSquare", nt.DeliverInnQuest):accept(8472, 8468, 8463):other("Bind to Falconwing Inn"):other("Sell and train professions if wanted")
nt.CompleteFirstQuestsFromFalconwingSquare = node("CompleteFirstQuestsFromFalconwingSquare", nt.AcceptFirstQuestsInFalconwingSquare):complete(8472, 8468, 8463)
nt.DeliverFirstQuestsInFalconwingSquare = node("DeliverFirstQuestsInFalconwingSquare", nt.CompleteFirstQuestsFromFalconwingSquare):deliver(8472, 8468, 8463):accept(9352, 8895)
nt.DeliverNorthSanctum = node("DeliverNorthSanctum", nt.DeliverFirstQuestsInFalconwingSquare):deliver(8895):accept(9119)
]]--
   return nt
end
-- q = quest ID, t = title, l = level, r = requires level, n = next in series, o = opens quests, c = required completed quest, a = class
Adventum_Belf_1_12_QDB={
   [10068]={ q=10068, t="Well Watcher Solanian", class="MAGE", c={8328}, l=2, r=2,},
   [10069]={ q=10069, t="Well Watcher Solanian", class="PALADIN", c={9676}, l=2, r=2,},
   [10070]={ q=10070, t="Well Watcher Solanian", class="HUNTER", c={9393}, l=2, r=2,},
   [10071]={ q=10071, t="Well Watcher Solanian", class="ROGUE", c={9392}, l=2, r=2,},
   [10072]={ q=10072, t="Well Watcher Solanian", class="PRIEST", c={8564}, l=2, r=2,},
   [10073]={ q=10073, t="Well Watcher Solanian", class="WARLOCK", c={8563}, l=2, r=2,},
   [9676]={ q=9676, t="Paladin Training", class="PALADIN", o={10069}, l=1, r=1,},
   [8328]={ q=8328, t="Mage Training", class="MAGE",o={10068}, l=1, r=1,},
   [8564]={ q=8564, t="Priest Training", class="PRIEST",o={10070}, l=1, r=1,},
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
