-- q = quest ID, t = title, l = level, r = requires level, s = side,
-- si = start ID, st = start type, ei = end ID, et = end type,
-- p = previous in series, n = next in series, class = quest for class,
-- o = opens quests, c = required completed quest

Adventum_Tauren_1_12_QDB={
  [770]={ q=770, t="The Demon Scarred Cloak", l=12, r=6, s="Horde", si=4854, st="item", ei=3052, et="npc",},
  [771]={ q=771, t="Rite of Vision", l=7, r=3, s="Horde", si=3054, st="npc", ei=3054, et="npc", p=767, n=0, o={772,},},
  [772]={ q=772, t="Rite of Vision", l=7, r=3, s="Horde", si=3054, st="npc", ei=2984, et="npc", p=0, n=773, c={771,},},
  [773]={ q=773, t="Rite of Wisdom", l=10, r=3, s="Horde", si=2984, st="npc", ei=2994, et="npc", p=772, n=775,},
  [775]={ q=775, t="Journey into Thunder Bluff", l=10, r=3, s="Horde", si=2994, st="npc", ei=3057, et="npc", p=773, n=776,},
  [776]={ q=776, t="Rites of the Earthmother", l=14, r=3, s="Horde", si=3057, st="npc", ei=3057, et="npc", p=775, n=0,},
  [905]={ q=905, t="The Angry Scytheclaws", l=17, r=10, s="Horde", si=3338, st="npc", ei=3338, et="npc", p=881, n=3261,},
  [907]={ q=907, t="Enraged Thunder Lizards", l=18, r=10, s="Horde", si=3387, st="npc", ei=3387, et="npc", p=882, n=913,},
  [780]={ q=780, t="The Battleboars", l=4, r=1, s="Horde", si=2980, st="npc", ei=2980, et="npc", p=750, n=0,},
  [781]={ q=781, t="Attack on Camp Narache", l=4, r=1, s="Horde", si=4851, st="item", ei=2981, et="npc",},
  [913]={ q=913, t="Cry of the Thunderhawk", l=20, r=10, s="Horde", si=3387, st="npc", ei=3387, et="npc", p=907, n=874,},
  [3091]={ q=3091, t="Simple Note", l=1, r=1, s="Tauren", si=2980, st="npc", ei=3059, et="npc", class="Warrior", c={747,},},
  [3092]={ q=3092, t="Etched Note", l=1, r=1, s="Tauren", si=2980, st="npc", ei=3061, et="npc", class="Hunter", c={747,},},
  [3093]={ q=3093, t="Rune-Inscribed Note", l=1, r=1, s="Tauren", si=2980, st="npc", ei=3062, et="npc", class="Shaman", c={747,},},
  [3094]={ q=3094, t="Verdant Note", l=1, r=1, s="Tauren", si=2980, st="npc", ei=3060, et="npc", class="Druid", c={747,},},
  [881]={ q=881, t="Echeyakee", l=16, r=10, s="Horde", si=3338, st="npc", ei=3338, et="npc", p=903, n=905,},
  [903]={ q=903, t="Prowlers of the Barrens", l=15, r=10, s="Horde", si=3338, st="npc", ei=3338, et="npc", p=845, n=881,},
  [873]={ q=873, t="Isha Awak", l=27, r=10, s="Horde", si=3388, st="npc", ei=3388, et="npc", p=874, n=0,},
  [882]={ q=882, t="Ishamuhale", l=19, r=10, s="Horde", si=3387, st="npc", ei=3387, et="npc", p=3261, n=907,},
  [3376]={ q=3376, t="Break Sharptusk!", l=5, r=3, s="Horde", si=3209, st="npc", ei=3209, et="npc",},
  [3261]={ q=3261, t="Jorn Skyseer", l=18, r=10, s="Horde", si=3338, st="npc", ei=3387, et="npc", p=905, n=882,},
  [833]={ q=833, t="A Sacred Burial", l=10, r=7, s="Horde", si=3233, st="npc", ei=3233, et="npc",},
  [874]={ q=874, t="Mahren Skyseer", l=27, r=9, s="Horde", si=3387, st="npc", ei=3388, et="npc", p=913, n=873,},
  [844]={ q=844, t="Plainstrider Menace", l=12, r=10, s="Horde", si=3338, st="npc", ei=3338, et="npc", p=860, n=845,},
  [845]={ q=845, t="The Zhevra", l=13, r=10, s="Horde", si=3338, st="npc", ei=3338, et="npc", p=844, n=903,},
  [760]={ q=760, t="Wildmane Cleansing", l=10, r=4, s="Tauren", si=2948, st="npc", ei=2948, et="npc", c={759,},},
  [5844]={ q=5844, t="Welcome!", l=1, r=1, s="Tauren", si=14650, st="item", ei=11944, et="npc",},
  [854]={ q=854, t="Journey to the Crossroads", l=12, r=9, s="Tauren", si=3418, st="npc", ei=3429, et="npc",},
  [860]={ q=860, t="Sergra Darkthorn", l=10, r=10, s="Horde", si=3441, st="npc", ei=3338, et="npc", p=0, n=844, c={861,},},
  [861]={ q=861, t="The Hunter's Way", l=10, r=10, s="Horde", si=3052, st="npc", ei=3441, et="npc", o={860,},},
  [743]={ q=743, t="Dangers of the Windfury", l=8, r=5, s="Horde", si=2985, st="npc", ei=2985, et="npc",},
  [745]={ q=745, t="Sharing the Land", l=6, r=1, s="Horde", si=2993, st="npc", ei=2993, et="npc",},
  [746]={ q=746, t="Dwarven Digging", l=8, r=6, s="Horde", si=2993, st="npc", ei=2993, et="npc",},
  [747]={ q=747, t="The Hunt Begins", l=2, r=1, s="Horde", si=2980, st="npc", ei=2980, et="npc", o={3094,3091,3092,3093,750,},},
  [748]={ q=748, t="Poison Water", l=5, r=4, s="Tauren", si=2948, st="npc", ei=2948, et="npc", o={754,},},
  [749]={ q=749, t="The Ravaged Caravan", l=8, r=5, s="Horde", si=2988, st="npc", ei=2908, et="object", p=0, n=751,},
  [750]={ q=750, t="The Hunt Continues", l=3, r=1, s="Horde", si=2980, st="npc", ei=2980, et="npc", p=0, n=780, c={747,},},
  [751]={ q=751, t="The Ravaged Caravan", l=8, r=5, s="Horde", si=2908, st="object", ei=2988, et="npc", p=749, n=0, o={764,765,},},
  [752]={ q=752, t="A Humble Task", l=2, r=1, s="Horde", si=2981, st="npc", ei=2991, et="npc", p=0, n=753,},
  [753]={ q=753, t="A Humble Task", l=3, r=1, s="Horde", si=2991, st="npc", ei=2981, et="npc", p=752, n=755,},
  [754]={ q=754, t="Winterhoof Cleansing", l=6, r=4, s="Tauren", si=2948, st="npc", ei=2948, et="npc", o={756,}, c={748,},},
  [755]={ q=755, t="Rites of the Earthmother", l=3, r=1, s="Horde", si=2981, st="npc", ei=2982, et="npc", p=753, n=757,},
  [756]={ q=756, t="Thunderhorn Totem", l=7, r=4, s="Tauren", si=2948, st="npc", ei=2948, et="npc", o={758,}, c={754,},},
  [757]={ q=757, t="Rite of Strength", l=4, r=1, s="Horde", si=2982, st="npc", ei=2981, et="npc", p=755, n=763,},
  [758]={ q=758, t="Thunderhorn Cleansing", l=8, r=4, s="Tauren", si=2948, st="npc", ei=2948, et="npc", o={759,}, c={756,},},
  [759]={ q=759, t="Wildmane Totem", l=10, r=4, s="Tauren", si=2948, st="npc", ei=2948, et="npc", o={760,}, c={758,},},
  [1656]={ q=1656, t="A Task Unfinished", l=5, r=1, s="Horde", si=6775, st="npc", ei=6747, et="npc",},
  [761]={ q=761, t="Swoop Hunting", l=6, r=4, s="Horde", si=2947, st="npc", ei=2947, et="npc",},
  [763]={ q=763, t="Rites of the Earthmother", l=5, r=1, s="Horde", si=2981, st="npc", ei=2993, et="npc", p=757, n=0, o={767,},},
  [764]={ q=764, t="The Venture Co.", l=10, r=5, s="Horde", si=2988, st="npc", ei=2988, et="npc", c={751,},},
  [765]={ q=765, t="Supervisor Fizsprocket", l=12, r=5, s="Horde", si=2988, st="npc", ei=2988, et="npc", c={751,},},
  [766]={ q=766, t="Mazzranache", l=8, r=5, s="Horde", si=3055, st="npc", ei=3055, et="npc",},
  [767]={ q=767, t="Rite of Vision", l=6, r=3, s="Horde", si=2993, st="npc", ei=3054, et="npc", p=0, n=771, c={763,},},
}
