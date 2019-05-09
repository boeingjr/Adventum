local nt = {}
local node = AdventumClassesNewNode

Adventum_Orc_1_12_NodeTrail = nt

nt.first = node("first", nil):ding(2)
nt.acceptYourPlace = node("acceptYourPlace", nt.first):accept(4641)
nt.deliverYourPlace = node("deliverYourPlace", nt.acceptYourPlace):deliver(4641)
nt.acceptSome = node("acceptSome", nt.deliverYourPlace):accept(788)
nt.acceptSarkoth = node("acceptSarkoth", nt.acceptSome):accept(790) -- 790 - 804
nt.completeSarkoth = node("completeSarkoth", nt.acceptSarkoth):complete(790)
nt.deliverSarkoth = node("deliverSarkoth", nt.completeSarkoth):deliver(790)
nt.acceptSecondSarkothDoCutting = node("acceptSecondSarkothDoCutting", nt.deliverSarkoth):accept(804):complete(788)
nt.completeCuttingAndAcceptMoar = node("completeCuttingAndAcceptMoar", nt.acceptSecondSarkothDoCutting):deliver(788, 804):accept(789, 792, 4402, 5441):other("Sell and train"):other("Do your class quest"):other("Warlocks, pick up your class quest \"Vile Familiars\"")
nt.completeMoar = node("completeMoar", nt.completeCuttingAndAcceptMoar):complete(789, 792, 4402, 5441)
nt.deliverMoarAcceptCave = node("deliverMoarAcceptCave", nt.completeMoar):deliver(789, 792, 4402, 5441):accept(794, 6394)
nt.completeCave = node("completeCave", nt.deliverMoarAcceptCave):complete(794, 6394):ding(6)
nt.deliverCaveAcceptCrumb = node("deliverCaveAcceptCrumb", nt.completeCave):deliver(794, 6394):accept(805):other("Tip: hearth out of cave")
nt.acceptNotherCrumb = node("acceptNotherCrumb", nt.deliverCaveAcceptCrumb):accept(2161, 786)
nt.deliverFirstCrumbAcceptMoar = node("deliverFirstCrumbAcceptMoar", nt.acceptNotherCrumb):deliver(805):accept(818, 817, 808, 823, 826)
nt.deliverOrgnilAcceptHillQs = node("deliverOrgnilAcceptHillQs", nt.deliverFirstCrumbAcceptMoar):deliver(823, 2161):accept(806, 784, 837, 815, 791):other("Set hearth, sell and train")
nt.complete = node("complete", nt.deliverOrgnilAcceptHillQs):complete(784, 791)
nt.acceptLetterFromChest = node("acceptLetterFromChest", nt.complete):accept(830)
nt.deliverLetterEtc = node("deliverLetterEtc", nt.acceptLetterFromChest):deliver(830, 784, 791):accept(825, 831)
nt.doInWater = node("doInWater", nt.deliverLetterEtc):complete(818, 825):ding(8)
nt.deliverWaterAndSomeMore = node("deliverWaterAndSomeMore", nt.doInWater):deliver(825):other("Sell and train")
nt.completeKolkars = node("completeKolkars", nt.deliverWaterAndSomeMore):complete(786)
nt.deliverKolkarsAndSolvent = node("deliverKolkars", nt.completeKolkars):deliver(786, 818)
nt.completeEchoes = node("completeEchoes", nt.deliverKolkarsAndSolvent):complete(815, 817, 808, 826)
nt.deliverEchoes = node("deliverEchoes", nt.completeEchoes):deliver(817, 808, 826):other("Hearth to Razor Hill")
nt.deliverEggs = node("deliverEggs", nt.deliverEchoes):deliver(815)
nt.completeEncroachment = node("completeEncroachment", nt.deliverEggs):complete(837)
nt.getLostButNotAndWind = node("getLostButNotAndWind", nt.completeEncroachment):accept(816, 834)
nt.doWinds = node("doWinds", nt.getLostButNotAndWind):complete(834)
nt.deliverWinds = node("deliverWinds", nt.doWinds):deliver(834)
nt.acceptFUSecuring = node("acceptFUSecuring", nt.deliverWinds):accept(835):ding(10)
nt.deliverEncroachment = node("deliverEncroachment", nt.acceptFUSecuring):deliver(837):other("Sell and train, do class quest")
nt.acceptNeedForCure = node("acceptNeedForCure", nt.deliverEncroachment):accept(812)
nt.deliverAdmiralAcceptHidden = node("deliverAdmiral", nt.acceptNeedForCure):deliver(831):accept(5726, 813)
nt.completeSecuring = node("completeSecuring", nt.deliverAdmiralAcceptHidden):complete(835)
nt.deliverSecuring = node("deliverSecuring", nt.completeSecuring):deliver(835)
nt.completePoison = node("completePoison", nt.deliverSecuring):complete(813, 816, 806)
nt.deliverLost = node("deliverLost", nt.completePoison):deliver(816)
nt.deliverDarStormsAcceptMargoz = node("deliverDarStormsAcceptMargoz", nt.deliverLost):deliver(806):accept(828)
nt.deliverMargozAcceptSkullRock = node("deliverMargozAcceptSkullRock", nt.deliverDarStormsAcceptMargoz):deliver(828):accept(827)
nt.completeSkullRockInsignia = node("completeSkullRockInsignia", nt.deliverMargozAcceptSkullRock):complete(827, 5726):other("Kill Gazz'uz for bonus quest")
nt.deliverSkullGetNeeru = node("deliverSkullGetNeeru", nt.completeSkullRockInsignia):deliver(827):accept(829)
nt.deliverHiddenGetFU = node("deliverHiddenGetFU", nt.deliverSkullGetNeeru):deliver(5726):accept(5727)
nt.deliverPoison = node("deliverPoison", nt.deliverHiddenGetFU):deliver(813, 829):complete(5727)
nt.deliverHidden = node("deliverHidden", nt.deliverPoison):deliver(5727):ding(12)
nt.deliverAntidote = node("deliverAntidote", nt.deliverHidden):deliver(812):other("You probably need to abandon the quest then pick it up again"):other("Hearth to Razor Hill")
nt.acceptConscript = node("acceptConscript", nt.deliverAntidote):accept(840):other("Sell and train")



-- q = quest ID, t = title, l = level, r = requires level, n = next in series, o = opens quests, c = required completed quest
Adventum_Orc_1_12_QDB={
  [2161]={ q=2161, t="A Peon's Burden", l=5, r=1,},
  [818]={ q=818, t="A Solvent Spirit", l=7, r=5,},
  [809]={ q=809, t="Ak'Zeloth", l=13, r=4, n=924,},
  [815]={ q=815, t="Break a Few Eggs", l=8, r=6,},
  [794]={ q=794, t="Burning Blade Medallion", l=5, r=1, n=805,},
  [832]={ q=832, t="Burning Shadows", l=12, r=4,},
  [791]={ q=791, t="Carry Your Weight", l=7, r=4,},
  [840]={ q=840, t="Conscript of the Horde", l=12, r=10, n=842,},
  [842]={ q=842, t="Crossroads Conscription", l=12, r=10,},
  [788]={ q=788, t="Cutting Teeth", l=2, r=1, o={789,2383,3065,3082,3083,3084,3085,3086,3087,3088,3089,3090,4402},},
  [806]={ q=806, t="Dark Storms", l=12, r=4, c={823,828},},
  [837]={ q=837, t="Encroachment", l=10, r=6,},
  [813]={ q=813, t="Finding the Antidote", l=9, r=7,},
  [926]={ q=926, t="Flawed Power Stone", l=14, r=1,},
  [825]={ q=825, t="From The Wreckage....", l=8, r=3,},
  [4402]={ q=4402, t="Galgar's Cactus Apple Surprise", l=3, r=1, c={788},},
  [5441]={ q=5441, t="Lazy Peons", l=4, r=3, n=6394,},
  [816]={ q=816, t="Lost But Not Forgotten", l=11, r=8,},
  [828]={ q=828, t="Margoz", l=12, r=4, n=827, c={806},},
  [808]={ q=808, t="Minshina's Skull", l=9, r=4,},
  [812]={ q=812, t="Need for a Cure", l=9, r=7,},
  [829]={ q=829, t="Neeru Fireblade", l=12, r=4, n=809, c={827},},
  [817]={ q=817, t="Practical Prey", l=8, r=5,},
  [823]={ q=823, t="Report to Orgnil", l=7, r=4, c={805,806},},
  [805]={ q=805, t="Report to Sen'jin Village", l=5, r=1, o={823},},
  [790]={ q=790, t="Sarkoth", l=5, r=1, n=804,},
  [804]={ q=804, t="Sarkoth", l=5, r=1,},
  [835]={ q=835, t="Securing the Lines", l=11, r=7,},
  [827]={ q=827, t="Skull Rock", l=12, r=4, o={829},},
  [789]={ q=789, t="Sting of the Scorpid", l=3, r=1, c={788},},
  [6394]={ q=6394, t="Thazz'ril's Pick", l=4, r=3,},
  [830]={ q=830, t="The Admiral's Orders", l=7, r=1, n=831,},
  [831]={ q=831, t="The Admiral's Orders", l=7, r=1,},
  [924]={ q=924, t="The Demon Seed", l=14, r=9,},
  [787]={ q=787, t="The New Horde", l=1, r=1, n=788,},
  [786]={ q=786, t="Thwarting Kolkar Aggression", l=8, r=5,},
  [784]={ q=784, t="Vanquish the Betrayers", l=7, r=3, n=825,},
  [792]={ q=792, t="Vile Familiars", l=4, r=2, n=794, o={794},},
  [834]={ q=834, t="Winds in the Desert", l=9, r=7, n=835,},
  [4641]={ q=4641, t="Your Place In The World", l=1, r=1, n=788,},
  [826]={ q=826, t="Zalazane", l=10, r=4,},
}
