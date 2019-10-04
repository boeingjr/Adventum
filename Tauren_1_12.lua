local node = AdventumClassesNewNode

function Adventum_Tauren_1_6()
   local nt = {}
   nt.first = node("first", nil):accept(747, 752)
   nt.CompleteHumble = node("CompleteHumble", nt.first):complete(752):other("Always kill quest mobs on sight")
   nt.DeliverHumble = node("DeliverHumble", nt.CompleteHumble):deliver(752):accept(753)
   nt.DeliverHumberAndHunt = node("DeliverHumberAndHunt", nt.DeliverHumble):deliver(747, 753):accept(750, 755, 3091, 3092, 3093, 3094)
   nt.DeliverClassQsAcceptRites = node("DeliverClassQsAcceptRites", nt.DeliverHumberAndHunt):deliver(3091, 3092, 3093, 3094):accept(755)
   nt.DeliverRitesEM = node("DeliverRitesEM", nt.DeliverClassQsAcceptRites):deliver(755):accept(757):complete(750):ding(4)
   nt.DeliverHuntCont = node("DeliverHuntCont", nt.DeliverRitesEM):deliver(750):accept(780, 3376, 1519)
   nt.CompleteBoars = node("CompleteBoars", nt.DeliverHuntCont):complete(780)
   nt.CompleteStrengthChief = node("CompleteStrengthChief", nt.CompleteBoars):complete(757, 3376, 1519):accept(24857) -- 781 aka 24857
   nt.DeliverAll = node("DeliverAll", nt.CompleteStrengthChief):deliver(780, 757, 3376, 24857, 1519):accept(763, 1520):other("Hearth home") -- 781 aka 24857
   nt.ShammyNodeDo = node("ShammyNodeDo", nt.DeliverAll):deliver(1520)
   nt.ShammyNodeDoDo = node("ShammyNodeDoDo", nt.ShammyNodeDo):accept(1521)
   nt.ShammyNodeFinish = node("ShammyNodeFinish", nt.ShammyNodeDoDo):deliver(1521)
   nt.Journy = node("Journy", nt.ShammyNodeFinish):accept(1656)
   nt.GoToVillage = node("GoToVillage", nt.Journy):deliver(763, 1656)
   nt.last = node("last", nt.GoToVillage):other("Choose a new quest path")
   return nt
end

function Adventum_Tauren_6_12()
   local nt = {}
   nt.first = node("first", nil):accept(752):other("This is at Red Cloud Mesa")
   nt.dohumbletask = node("dohumbletask", nt.first):deliver(752)
   nt.getnexthumbletask = node("getnexthumbletask", nt.dohumbletask):accept(753)
   nt.completehumbletask = node("completehumbletask", nt.getnexthumbletask):complete(753)
   nt.deliverhumbletask = node("deliverhumbletask", nt.completehumbletask):deliver(753)
   nt.acceptRitesOfEM = node("acceptRitesOfEM", nt.deliverhumbletask):accept(755, 3376)
   nt.deliverRitesOfEm = node("deliverRitesOfEm", nt.acceptRitesOfEM):deliver(755)
   nt.acceptRiteOfStrength = node("acceptRiteOfStrength", nt.deliverRitesOfEm):accept(757)
   nt.completeRiteOfStrength = node("completeRiteOfStrength", nt.acceptRiteOfStrength):complete(757, 3376)
   nt.deliverRiteOfStrength = node("deliverRiteOfStrength", nt.completeRiteOfStrength):deliver(757, 3376):accept(763)
   nt.Journey = node("Journey", nt.deliverRiteOfStrength):accept(1656)
   nt.GoToVillage = node("GoToVillage", nt.Journey):deliver(763, 1656)
   nt.normalfirst = node("normalfirst", nt.GoToVillage):accept(743, 745, 746, 748, 767):other("Set your Hearthstone here")
   nt.DeliverRites = node("DeliverRites", nt.normalfirst):deliver(767)
   nt.AcceptNextRitesAndM = node("AcceptNextRitesAndM", nt.DeliverRites):accept(771, 766)
   nt.BigRoundFirst = node("BigRoundFirst", nt.AcceptNextRitesAndM):complete(771, 748, 766)
   nt.SharingTheLand = node("SharingTheLand", nt.BigRoundFirst):complete(745, 743)
   nt.AcceptFromMorin = node("AcceptFromMorin", nt.SharingTheLand):accept(749)
   nt.DoFromMorin = node("DoFromMorin", nt.AcceptFromMorin):deliver(749):accept(751)
   nt.HearthTurninBig = node("HearthTurninBig", nt.DoFromMorin):deliver(745, 743, 748, 771, 754, 766):accept(772):other("Hearth home"):ding(9)
   nt.MorinAgain = node("MorinAgain", nt.HearthTurninBig):deliver(751):accept(764,765)
   nt.CompleteWinterhoofCleansing = node("CompleteWinterhoofCleansing", nt.MorinAgain):complete(754)
   nt.DeliverWCandGetThunderhorns = node("DeliverWCandGetThunderhorns", nt.CompleteWinterhoofCleansing):deliver(754):accept(756)
   nt.DoDwarvesAndThunderhorns = node("DoDwarvesAndThunderhorns", nt.DeliverWCandGetThunderhorns):complete(756):loot({[746]={"Prospector's Pick"}}):other("You need 5 picks") -- TODO Picks for 746
   nt.DeliverRitesWisdom = node("DeliverRitesWisdom", nt.DoDwarvesAndThunderhorns):deliver(772):accept(773)
   nt.AcceptBurial = node("AcceptBurial", nt.DeliverRitesWisdom):accept(833)
   nt.DeliverRitesWisdomAgain = node("DeliverRitesWisdomAgain", nt.AcceptBurial):deliver(773):accept(775)
   nt.DeliverBurial = node("DeliverBurial", nt.DeliverRitesWisdomAgain):deliver(833)
   nt.DingTenAndGetHuntersWay = node("DingTenAndGetHuntersWay", nt.DeliverBurial):ding(10):accept(861)
   nt.DeliverThunderhornsGetNext = node("DeliverThunderhornsGetNext", nt.DingTenAndGetHuntersWay):deliver(756, 761):accept(758):other("Train and sell, do your lvl 10 class quests")
   nt.FInalizeThunderhorns = node("FInalizeThunderhorns", nt.DeliverThunderhornsGetNext):complete(758):other("Go to Thunder Bluff")
   nt.AcceptPreparations = node("AcceptPreparations", nt.FInalizeThunderhorns):accept(744, 776):complete(746):deliver(775)
   nt.DoVentureCo = node("DoVentureCo", nt.AcceptPreparations):complete(765, 764)
   nt.DieOnPurposeToTurnIn = node("DieOnPurposeToTurnIn", nt.DoVentureCo):deliver(746, 758):accept(759)
   nt.TurnInToMorin = node("TurnInToMorin", nt.DieOnPurposeToTurnIn):deliver(764, 765)
   nt.HuntersWayRites = node("HuntersWayRites", nt.TurnInToMorin):complete(861, 759, 776, 744)
   nt.ThunderBluffRound = node("ThunderBluffRound", nt.HuntersWayRites):deliver(776, 861, 744):accept(886, 860)
   nt.LastBloodHoof = node("LastBloodHoof", nt.ThunderBluffRound):other("Hearth if up"):deliver(759):accept(760)
   nt.WildmaneStuff = node("WildmaneStuff", nt.LastBloodHoof):complete(760)
   nt.ToTaurajo = node("ToTaurajo", nt.WildmaneStuff):other("Get the FP"):accept(854)
   nt.ToXRoads = node("ToXRoads", nt.ToTaurajo):other("Go to Crossroads"):deliver(886, 860, 854)
   nt.last = node("last", nt.ToXRoads):other("Choose a new quest path")
   return nt
end



Adventum_Tauren_1_12_Mined={
   [747]={ q=747, t="The Hunt Begins", lvl=2, minerclass="SHAMAN", minerrace="Tauren",}, -- [1]
   [752]={ q=752, t="A Humble Task", lvl=2, minerclass="SHAMAN", minerrace="Tauren",}, -- [2]
   [753]={ q=753, t="A Humble Task", lvl=3, minerclass="SHAMAN", minerrace="Tauren",}, -- [3]
   [750]={ q=750, t="The Hunt Continues", lvl=3, minerclass="SHAMAN", minerrace="Tauren",}, -- [4]
   [3093]={ q=3093, t="Rune-Inscribed Note", lvl=1, minerclass="SHAMAN", minerrace="Tauren",}, -- [5]
   [755]={ q=755, t="Rites of the Earthmother", lvl=3, minerclass="SHAMAN", minerrace="Tauren",}, -- [6]
   [3376]={ q=3376, t="Break Sharptusk!", lvl=5, minerclass="SHAMAN", minerrace="Tauren",}, -- [7]
   [757]={ q=757, t="Rite of Strength", lvl=4, minerclass="SHAMAN", minerrace="Tauren",}, -- [8]
   [780]={ q=780, t="The Battleboars", lvl=4, minerclass="SHAMAN", minerrace="Tauren",}, -- [9]
   [1519]={ q=1519, t="Call of Earth", lvl=4, class="SHAMAN",}, -- [10]
   [24857]={ q=24857, t="Attack on Camp Narache", lvl=4, minerclass="SHAMAN", minerrace="Tauren",}, -- [11]
   [1520]={ q=1520, t="Call of Earth", lvl=4, minerclass="SHAMAN", minerrace="Tauren",}, -- [12]
   [1462]={ q=1462, t="Earth Sapta", lvl=4, minerclass="SHAMAN", minerrace="Tauren",}, -- [13]
   [763]={ q=763, t="Rites of the Earthmother", lvl=5, minerclass="SHAMAN", minerrace="Tauren",}, -- [14]
   [1521]={ q=1521, t="Call of Earth", lvl=4, minerclass="SHAMAN", minerrace="Tauren",}, -- [15]
   [1656]={ q=1656, t="A Task Unfinished", lvl=5, minerclass="SHAMAN", minerrace="Tauren",}, -- [16]
}
