-- This information tells other players more about the mod
name = "Archery Mod DST [401750fix]"
description = "Focusing on bringing more ranged weapons to the game. \nNow with FULL Controller Support! \nCheckout Apothecary Medicamento Mod which add a drug improving your Archer efficiency!"
author = "ZupaleX & Yuri69~<3"
version = "1.0.0"

forumthread = ""

api_version = 10

-- Can specify a custom icon for this mod!
icon_atlas = "modicon.xml"
icon = "modicon.tex"

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = true

all_clients_require_mod = true
client_only_mod = false

--These tags allow the server running this mod to be found with filters from the server listing screen
server_filter_tags = {"weapon", "bow"}

priority = 0.000026082015

configuration_options =
{
	{
		name = "BowUses",
		label = "Bow Uses",
		hover = "How many time can you use the bow before it breaks",
		options =
		{
			{description = "20", data = 20},
			{description = "40", data = 40},
			{description = "50", data = 50},
			{description = "60", data = 60},
			{description = "80", data = 80},
			{description = "100", data = 100},
			{description = "120", data = 120},
			{description = "150 (spear)", data = 150},
			{description = "175", data = 175},
			{description = "200", data = 200},
			{description = "Inf.", data = 999},
		},
		default = 50,
	},

	{
		name = "BowDmg",
		label = "Bow Damage",
		hover = "Amount of damage dealt by the bow ",
		options =
		{
			{description = "17", data = 17, hover = "Hammer damage"},
			{description = "24", data = 24, hover = "A bit less than the Axe"},
			{description = "27", data = 27, hover = "Axe damage"},
			{description = "30", data = 30, hover = "A bit less than the Spear"},
			{description = "34", data = 34, hover = "Spear damage"},
			{description = "38", data = 38, hover = "A bit more than the spear"},
			{description = "43", data = 43, hover = "Batbat damage"},
			{description = "47", data = 47, hover = "Slightly more than the Batbat"},
			{description = "51", data = 51, hover = "Intermediate between Batbat and Ruinbat"},
			{description = "55", data = 55, hover = "Slightly less than Ruinbat"},
			{description = "60", data = 60, hover = "Hambat/Ruinbat damage"},
			{description = "65", data = 65, hover = "Slightly more than the Ruinbat"},
			{description = "70", data = 70, hover = "are you serious?"},
			{description = "75", data = 75, hover = "are you serious?!"},
			{description = "80", data = 80, hover = "are you serious?!!"},
			{description = "90", data = 90, hover = "use c_godmode() instead"},

		},
		default = 27,
	},

	{
		name = "BowRange",
		label = "Bow Range",
		hover = "Range of your bow",
		options =
		{
			{description = "10 (blowdartt)", data = 10},
			{description = "11", data = 11},
			{description = "12", data = 12},
			{description = "13", data = 13},
			{description = "14", data = 14},
			{description = "15", data = 15},
			{description = "16", data = 16},
			{description = "17", data = 17},
			{description = "18", data = 18},
			{description = "19", data = 19},
			{description = "20", data = 20},
			{description = "21", data = 21},
			{description = "22", data = 22},
		},
		default = 13,
	},

	{
		name = "BowMissChanceSmall",
		label = "Bow Miss Small",
		hover = "Probability to miss a small target",
		options =
		{
			{description = "0%", data = 0},
			{description = "10%", data = 0.1},
			{description = "20%", data = 0.2},
			{description = "30%", data = 0.3},
			{description = "40%", data = 0.4},
			{description = "50%", data = 0.5},
			{description = "60%", data = 0.6},
			{description = "70%", data = 0.7},
			{description = "80%", data = 0.8},
			{description = "90%", data = 0.9},
			{description = "100%", data = 1.0},
		},
		default = 0.4,
	},

	{
		name = "BowMissChanceBig",
		label = "Bow Miss Big",
		hover = "Probability to miss a big target",
		options =
		{
			{description = "0%", data = 0},
			{description = "5%", data = 0.05},
			{description = "10%", data = 0.1},
			{description = "15%", data = 0.15},
			{description = "20%", data = 0.20},
			{description = "25%", data = 0.25},
			{description = "30%", data = 0.30},
			{description = "35%", data = 0.35},
			{description = "40%", data = 0.40},
			{description = "45%", data = 0.45},
			{description = "50%", data = 0.50},
		},
		default = 0.15,
	},

	{
		name = "HitChanceBugs",
		label = "Bow Miss Tiny",
		hover = "Activate the override of the miss chance on butterflies and bees",
		options =
		{
			{description = "no", data = false, hover= "Desactivate the reduced hit chance on bees and butterflies"},
			{description = "yes", data = true, hover= "The hit chance on bees and butterflies is reduced to 1%"},
		},
		default = true,
	},

	{
		name = "HitChanceTakeOff",
		label = "Bow Miss Flying Birds",
		hover = "Activate the override of the miss chance on birds which are flying",
		options =
		{
			{description = "no", data = false, hover= "Desactivate the reduced hit chance on flying birds"},
			{description = "yes", data = true, hover= "The hit chance on flying birds is reduced to 0.5%"},
		},
		default = true,
	},

	{
		name = "ActivateCollisions",
		label = "Activate Collisions",
		hover = "Will your arrows/bolts be stopped by obstacles (walls, trees, etc...)",
		options =
		{
			{description = "yes", data = true},
			{description = "no", data = false},
		},
		default = true,
	},

	{
		name = "ArrowHitRecovery",
		label = "Hit Recovery",
		hover = "Chance to recover the arrow after a successful shot",
		options =
		{
			{description = "0%", data = 0},
			{description = "10%", data = 0.1},
			{description = "20%", data = 0.2},
			{description = "30%", data = 0.3},
			{description = "40%", data = 0.4},
			{description = "50%", data = 0.5},
			{description = "60%", data = 0.6},
			{description = "70%", data = 0.7},
			{description = "80%", data = 0.8},
			{description = "90%", data = 0.9},
			{description = "100%", data = 1.0},
		},
		default = 0.1,
	},

	{
		name = "ArrowMissRecovery",
		label = "Miss Recovery",
		hover = "Chance to recover the arrow after a failed shot",
		options =
		{
			{description = "0%", data = 0},
			{description = "10%", data = 0.1},
			{description = "20%", data = 0.2},
			{description = "30%", data = 0.3},
			{description = "40%", data = 0.4},
			{description = "50%", data = 0.5},
			{description = "60%", data = 0.6},
			{description = "70%", data = 0.7},
			{description = "80%", data = 0.8},
			{description = "90%", data = 0.9},
			{description = "100%", data = 1.0},
		},
		default = 0.8,
	},

	{
		name = "CritPvE",
		label = "Critical % Mob",
		hover = "Chance to score a critical hit against a Creature",
		options =
		{
			{description = "Disabled", data = 0},
			{description = "5%", data = 0.05},
			{description = "10%", data = 0.1},
			{description = "15%", data = 0.15},
			{description = "20%", data = 0.2},
			{description = "25%", data = 0.25},
			{description = "30%", data = 0.3},
			{description = "35%", data = 0.35},
			{description = "40%", data = 0.4},
			{description = "45%", data = 0.45},
			{description = "50%", data = 0.5},
		},
		default = 0.05,
	},

	{
		name = "CritDmgModPvE",
		label = "Crit Dmg Mob",
		hover = "Damage modifier for critical hit against creatures",
		options =
		{
			{description = "25%", data = 1.25},
			{description = "50%", data = 1.5},
			{description = "75%", data = 1.75},
			{description = "100%", data = 2.0},
			{description = "125%", data = 2.25},
			{description = "150%", data = 2.50},
			{description = "175%", data = 2.75},
			{description = "200%", data = 3.0},
			{description = "250%", data = 3.5},
			{description = "300%", data = 4.0},
			{description = "350%", data = 4.5},
			{description = "400%", data = 5.0},
		},
		default = 2.0,
	},

	{
		name = "CritPvP",
		label = "Critical % Player",
		hover = "Chance to score a critical hit against a Player",
		options =
		{
			{description = "Disabled", data = 0},
			{description = "5%", data = 0.05},
			{description = "10%", data = 0.1},
			{description = "15%", data = 0.15},
			{description = "20%", data = 0.2},
			{description = "25%", data = 0.25},
			{description = "30%", data = 0.3},
			{description = "35%", data = 0.35},
			{description = "40%", data = 0.4},
			{description = "45%", data = 0.45},
			{description = "50%", data = 0.5},
		},
		default = 0.05,
	},

	{
		name = "CritDmgModPvP",
		label = "Crit Dmg Player",
		hover = "Damage modifier for critical hit against Players",
		options =
		{
			{description = "25%", data = 1.25},
			{description = "50%", data = 1.5},
			{description = "75%", data = 1.75},
			{description = "100%", data = 2.0},
			{description = "125%", data = 2.25},
			{description = "150%", data = 2.50},
			{description = "175%", data = 2.75},
			{description = "200%", data = 3.0},
			{description = "250%", data = 3.5},
			{description = "300%", data = 4.0},
			{description = "350%", data = 4.5},
			{description = "400%", data = 5.0},
		},
		default = 1.5,
	},

	{
		name = "AccuracyDrugEffect",
		label = "Vitmin R Effects",
		hover = "Effects of the Vitamin R on Accuracy and Recovery chance (Require Apothecary Medicamento Mod)",
		options =
		{
			{description = "small", data = "small", hover = "Reduce Miss Chance by 30% and add 15% to Projectile Recovery"},
			{description = "medium", data = "medium", hover = "Reduce Miss Chance by 60% and add 35% to Projectile Recovery"},
			{description = "strong", data = "strong", hover = "Reduce Miss Chance by 85% and add 60% to Projectile Recovery"},
			{description = "Robin Hood Mod", data = "robinhood", hover = "You will never miss and always recover projectiles. Cheater!"},
		},
		default = "medium",
	},

	{
		name = "BowTwigs_req",
		label = "Bow recipe - Twigs",
		hover = "Amount of Twigs required to craft the Bow",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
		},
		default = 1,
	},

	{
		name = "BowSilk_req",
		label = "Bow recipe - Silk",
		hover = "Amount of Silk required to craft the Bow",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
		},
		default = 2,
	},

	{
		name = "BowTechLevel",
		label = "Bow Tech. Level",
		hover = "Machine required to craft the Bow",
		options =
		{
			{description = "None", data = "NONE"},
			{description = "Sc. Mach.", data = "SCIENCE_ONE"},
			{description = "Alch. Eng.", data = "SCIENCE_TWO"},
		},
		default = "SCIENCE_ONE",
	},

	{
		name = "CrossbowDmgMod",
		label = "Crossbow Dmg. Mod.",
		hover = "Damage modifier of the Crossbow compared to the Regular Bow",
		options =
		{
			{description = "same", data = 1.0},
			{description = "+25%", data = 1.25},
			{description = "+50%", data = 1.5},
			{description = "+75%", data = 1.75},
			{description = "+100%", data = 2.0},
			{description = "+125%", data = 2.25},
			{description = "+150%", data = 2.5},
			{description = "+175%", data = 2.75},
			{description = "+200%", data = 3.0},
			{description = "+250%", data = 3.5},
			{description = "+300%", data = 4.0},
		},
		default = 2.0,
	},

	{
		name = "CrossbowRangeMod",
		label = "Crossbow Range Mod.",
		hover = "Range modifier of the Crossbow compared to the Regular Bow",
		options =
		{
			{description = "same", data = 1},
			{description = "+5%", data = 1.05},
			{description = "+10%", data = 1.10},
			{description = "+15%", data = 1.15},
			{description = "+20%", data = 1.20},
			{description = "+25%", data = 1.25},
			{description = "+30%", data = 1.30},
			{description = "+35%", data = 1.35},
			{description = "+40%", data = 1.40},
			{description = "+45%", data = 1.45},
			{description = "+50%", data = 1.50},
			{description = "+55%", data = 1.55},
			{description = "+60%", data = 1.60},
		},
		default = 1.20,
	},

	{
		name = "CrossbowAccMod",
		label = "Crossbow Accuracy Mod.",
		hover = "Accurancy modifier of the Crossbow compared to the Regular Bow",
		options =
		{
			{description = "-50%", data = 1.50},
			{description = "-45%", data = 1.45},
			{description = "-40%", data = 1.40},
			{description = "-35%", data = 1.35},
			{description = "-30%", data = 1.30},
			{description = "-25%", data = 1.25},
			{description = "-20%", data = 1.20},
			{description = "-15%", data = 1.15},
			{description = "-10%", data = 1.10},
			{description = "-5%", data = 1.05},
			{description = "same", data = 1},
			{description = "+5%", data = 0.95},
			{description = "+10%", data = 0.90},
			{description = "+15%", data = 0.85},
			{description = "+20%", data = 0.80},
			{description = "+25%", data = 0.75},
			{description = "+30%", data = 0.70},
			{description = "+35%", data = 0.65},
			{description = "+40%", data = 0.60},
			{description = "+45%", data = 0.55},
			{description = "+50%", data = 0.50},
			{description = "+55%", data = 0.45},
			{description = "+60%", data = 0.40},
		},
		default = 0.80,
	},

	{
		name = "CrossbowBoards_req",
		label = "Crossbow recipe - Boards",
		hover = "Amount of Boards required to craft the Crossbow",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
		},
		default = 2,
	},

	{
		name = "CrossbowSilk_req",
		label = "Crossbow recipe - Silk",
		hover = "Amount of Silk required to craft the Crossbow",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
		},
		default = 2,
	},

	{
		name = "CrossbowHammer_req",
		label = "Crossbow recipe - Hammer",
		hover = "Amount of Hammer required to craft the Crossbow",
		options =
		{
			{description = "0", data = 0},
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
		},
		default = 1,
	},

	{
		name = "CrossbowTechLevel",
		label = "Crossbow Tech. Level",
		hover = "Machine required to craft the Crossow",
		options =
		{
			{description = "None", data = "NONE"},
			{description = "Sc. Mach.", data = "SCIENCE_ONE"},
			{description = "Alch. Eng.", data = "SCIENCE_TWO"},
		},
		default = "SCIENCE_ONE",
	},

	{
		name = "MagicBowDmgMod",
		label = "Magic Bow Dmg. Mod.",
		hover = "Damage modifier of the Magic Bow compared to the Regular Bow",
		options =
		{
			{description = "same", data = 1.0},
			{description = "+25%", data = 1.25},
			{description = "+50%", data = 1.5},
			{description = "+75%", data = 1.75},
			{description = "+100%", data = 2.0},
			{description = "+125%", data = 2.25},
			{description = "+150%", data = 2.5},
			{description = "+175%", data = 2.75},
			{description = "+200%", data = 3.0},
			{description = "+250%", data = 3.5},
			{description = "+300%", data = 4.0},
		},
		default = 1.5,
	},

	{
		name = "MagicBowLivingLog_req",
		label = "Mag. Bow recipe - Living Logs",
		hover = "Amount of Living Logs required to craft the Magic Bow",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
		},
		default = 2,
	},

	{
		name = "MagicBowPurpleGem_req",
		label = "Mag. Bow recipe - Gem",
		hover = "Amount of Purple Gems required to craft the Magic Bow",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
		},
		default = 1,
	},

	{
		name = "MagicBowGlommerFlower_req",
		label = "Mag. Bow recipe - Glommer",
		hover = "Require a Glommer Flower to craft the Magic Bow",
		options =
		{
			{description = "no", data = false},
			{description = "yes", data = true},
		},
		default = true,
	},

	{
		name = "MagicBowTechLevel",
		label = "Magic Bow Tech. Level",
		hover = "Machine required to craft the Magic Bow",
		options =
		{
			{description = "None", data = "NONE"},
			{description = "Sc. Mach.", data = "SCIENCE_ONE"},
			{description = "Alch. Eng.", data = "SCIENCE_TWO"},
			{description = "Prestihat.", data = "MAGIC_TWO"},
			{description = "Sh. Manip.", data = "MAGIC_THREE"},
		},
		default = "MAGIC_THREE",
	},

	{
		name = "QuiverPigskin_req",
		label = "Quiver recipe - Pig Skin",
		hover = "Amount of Pig Skin required to craft the Quiver",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
		},
		default = 2,
	},

	{
		name = "QuiverRope_req",
		label = "Quiver recipe - Rope",
		hover = "Amount of Rope required to craft the Quiver",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
		},
		default = 3,
	},

	{
		name = "QuiverTechLevel",
		label = "Quiver Tech. Level",
		hover = "Machine required to craft the Quiver",
		options =
		{
			{description = "None", data = "NONE"},
			{description = "Sc. Mach.", data = "SCIENCE_ONE"},
			{description = "Alch. Eng.", data = "SCIENCE_TWO"},
		},
		default = "SCIENCE_ONE",
	},

	{
		name = "MusketDmgMod",
		label = "Musket Dmg. Mod.",
		hover = "Damage modifier of the Musket compared to the Regular Bow",
		options =
		{
			{description = "same", data = 1.0},
			{description = "+25%", data = 1.25},
			{description = "+50%", data = 1.5},
			{description = "+75%", data = 1.75},
			{description = "+100%", data = 2.0},
			{description = "+125%", data = 2.25},
			{description = "+150%", data = 2.5},
			{description = "+175%", data = 2.75},
			{description = "+200%", data = 3.0},
			{description = "+250%", data = 3.5},
			{description = "+300%", data = 4.0},
		},
		default = 3.0,
	},

	{
		name = "MusketRangeMod",
		label = "Musket Range Mod.",
		hover = "Range modifier of the Musket compared to the Regular Bow",
		options =
		{
			{description = "-30%", data = 0.70},
			{description = "-25%", data = 0.75},
			{description = "-20%", data = 0.80},
			{description = "-15%", data = 0.85},
			{description = "-10%", data = 0.90},
			{description = "-5%", data = 0.95},
			{description = "same", data = 1},
			{description = "+5%", data = 1.05},
			{description = "+10%", data = 1.10},
			{description = "+15%", data = 1.15},
			{description = "+20%", data = 1.20},
			{description = "+25%", data = 1.25},
			{description = "+30%", data = 1.30},
			{description = "+35%", data = 1.35},
			{description = "+40%", data = 1.40},
			{description = "+45%", data = 1.45},
			{description = "+50%", data = 1.50},
			{description = "+55%", data = 1.55},
			{description = "+60%", data = 1.60},
		},
		default = 0.90,
	},

	{
		name = "MusketAccMod",
		label = "Musket Accuracy Mod.",
		hover = "Accurancy modifier of the Musket compared to the Regular Bow",
		options =
		{
			{description = "-50%", data = 1.50},
			{description = "-45%", data = 1.45},
			{description = "-40%", data = 1.40},
			{description = "-35%", data = 1.35},
			{description = "-30%", data = 1.30},
			{description = "-25%", data = 1.25},
			{description = "-20%", data = 1.20},
			{description = "-15%", data = 1.15},
			{description = "-10%", data = 1.10},
			{description = "-5%", data = 1.05},
			{description = "same", data = 1},
			{description = "+5%", data = 0.95},
			{description = "+10%", data = 0.90},
			{description = "+15%", data = 0.85},
			{description = "+20%", data = 0.80},
			{description = "+25%", data = 0.75},
			{description = "+30%", data = 0.70},
			{description = "+35%", data = 0.65},
			{description = "+40%", data = 0.60},
			{description = "+45%", data = 0.55},
			{description = "+50%", data = 0.50},
			{description = "+55%", data = 0.45},
			{description = "+60%", data = 0.40},
		},
		default = 1.10,
	},

	{
		name = "MusketBoards_req",
		label = "Musket recipe - Boards",
		hover = "Amount of Boards required to craft the Musket",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
		},
		default = 2,
	},

	{
		name = "MusketGold_req",
		label = "Musket recipe - Gold",
		hover = "Amount of Gold Nuggets required to craft the Musket",
		options =
		{
			{description = "0", data = 0},
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 5,
	},

	{
		name = "MusketIron_req",
		label = "Musket recipe - Iron",
		hover = "(REQUIRE Mining Machine Mod) Amount of Iron Ores required to craft the Musket",
		options =
		{
			{description = "0", data = 0},
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 5,
	},

	{
		name = "MusketFlint_req",
		label = "Musket recipe - Flint",
		hover = "Amount of Flint required to craft the Musket",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 5,
	},

	{
		name = "MusketTechLevel",
		label = "Musket Tech. Level",
		hover = "Machine required to craft the Crossow",
		options =
		{
			{description = "None", data = "NONE"},
			{description = "Sc. Mach.", data = "SCIENCE_ONE"},
			{description = "Alch. Eng.", data = "SCIENCE_TWO"},
		},
		default = "SCIENCE_TWO",
	},

	{
		name = "ProjShaftType",
		label = "Projectile Shaft : ",
		hover = "Which material will be used for the projectiles shafts",
		options =
		{
			{description = "Log", data = "log"},
			{description = "Twigs", data = "twigs"},
			{description = "Reeds", data = "cutreeds"},
		},
		default = "log",
	},

	{
		name = "ArrowLog_req",
		label = "Arrow recipe - Shafts",
		hover = "Amount of Shafts required to craft Arrows",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "ArrowFeather_req",
		label = "Arrow recipe - Feather",
		hover = "Amount of Crow Feather required to craft Arrows",
		options =
		{
			{description = "0", data = 0},
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "ArrowHeadType",
		label = "Arrow Head : ",
		hover = "Which material will be used for the Arrows heads",
		options =
		{
			{description = "Flint", data = "flint"},
			{description = "Stinger", data = "stinger"},
			{description = "Tooth", data = "houndstooth"},
		},
		default = "flint",
	},

	{
		name = "ArrowHead_req",
		label = "Arrow recipe - Head",
		hover = "Amount of the material chosen for the head required to craft Arrows",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "ArrowCraftAmount",
		label = "Arrow recipe - Result",
		hover = "Amount of Arrows you get from the recipe",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 5,
	},

	{
		name = "ArrowTechLevel",
		label = "Arrow Tech. Level",
		hover = "Machine required to craft the Arrows",
		options =
		{
			{description = "None", data = "NONE"},
			{description = "Sc. Mach.", data = "SCIENCE_ONE"},
			{description = "Alch. Eng.", data = "SCIENCE_TWO"},
		},
		default = "SCIENCE_ONE",
	},

	{
		name = "GoldArrowLog_req",
		label = "Gold Arrow recipe - Shafts",
		hover = "Amount of Shafts required to craft Gold Arrows",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "GoldArrowFeather_req",
		label = "Gold Arrow recipe - Feather",
		hover = "Amount of Crow Feather required to craft Gold Arrows",
		options =
		{
			{description = "0", data = 0},
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "GoldArrowHead_req",
		label = "Gold Arrow recipe - Gold",
		hover = "Amount of Gold required to craft Gold Arrows",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "GoldArrowCraftAmount",
		label = "Gold Arrow recipe - Result",
		hover = "Amount of Gold Arrows you get from the recipe",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 5,
	},

	{
		name = "GoldArrowTechLevel",
		label = "Gold Arrow Tech. Level",
		hover = "Machine required to craft the Gold Arrows",
		options =
		{
			{description = "None", data = "NONE"},
			{description = "Sc. Mach.", data = "SCIENCE_ONE"},
			{description = "Alch. Eng.", data = "SCIENCE_TWO"},
			{description = "Prestihat.", data = "MAGIC_TWO"},
			{description = "Sh. Manip.", data = "MAGIC_THREE"},
		},
		default = "MAGIC_TWO",
	},

	{
		name = "GoldArrowDmgMod",
		label = "Gold Arrow Dmg. Mod.",
		hover = "Damage modifier of the Gold Arrows compared to the regular Arrow",
		options =
		{
			{description = "+25%", data = 1.25},
			{description = "+50%", data = 1.5},
			{description = "+75%", data = 1.75},
			{description = "+100%", data = 2.0},
			{description = "+125%", data = 2.25},
			{description = "+150%", data = 2.5},
			{description = "+175%", data = 2.75},
			{description = "+200%", data = 3.0},
			{description = "+250%", data = 3.5},
			{description = "+300%", data = 4.0},
			{description = "+350%", data = 4.5},
			{description = "+400%", data = 5.0},
		},
		default = 1.5,
	},

	{
		name = "GoldArrowRecoveryMod",
		label = "Gold Arrow Rec. Mod.",
		hover = "Recovery modifier of the Gold Arrows compared to the regular Arrow",
		options =
		{
			{description = "-100%", data = -1},
			{description = "-90%", data = 0.1},
			{description = "-80%", data = 0.2},
			{description = "-70%", data = 0.3},
			{description = "-60%", data = 0.4},
			{description = "-50%", data = 0.5},
			{description = "-40%", data = 0.6},
			{description = "-30%", data = 0.7},
			{description = "-20%", data = 0.8},
			{description = "-10%", data = 0.9},
			{description = "same", data = 1},
		},
		default = 0.6,
	},

	{
		name = "MoonstoneArrowLog_req",
		label = "Moon Rock Arrow recipe - Shafts",
		hover = "Amount of Shafts required to craft Moon Rock Arrows",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "MoonstoneArrowFeather_req",
		label = "Moon Rock Arrow recipe - Feather",
		hover = "Amount of Crow Feather required to craft Moon Rock Arrows",
		options =
		{
			{description = "0", data = 0},
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "MoonstoneArrowHead_req",
		label = "Moon Rock Arrow recipe - Head",
		hover = "Amount of Moon Rock required to craft Moon Rock Arrows",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "MoonstoneArrowCraftAmount",
		label = "Moon Rock Arrow recipe - Result",
		hover = "Amount of Moon Rock Arrows you get from the recipe",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "MoonstoneArrowTechLevel",
		label = "Moon Rock Arrow Tech. Level",
		hover = "Machine required to craft the Moon Rock Arrows",
		options =
		{
			{description = "None", data = "NONE"},
			{description = "Sc. Mach.", data = "SCIENCE_ONE"},
			{description = "Alch. Eng.", data = "SCIENCE_TWO"},
			{description = "Prestihat.", data = "MAGIC_TWO"},
			{description = "Sh. Manip.", data = "MAGIC_THREE"},
		},
		default = "MAGIC_TWO",
	},

	{
		name = "MoonstoneArrowDmgMod",
		label = "Moon Rock Arrow Dmg. Mod.",
		hover = "Damage modifier of the Moon Rock Arrows compared to the regular Arrow",
		options =
		{
			{description = "+25%", data = 1.25},
			{description = "+50%", data = 1.5},
			{description = "+75%", data = 1.75},
			{description = "+100%", data = 2.0},
			{description = "+125%", data = 2.25},
			{description = "+150%", data = 2.5},
			{description = "+175%", data = 2.75},
			{description = "+200%", data = 3.0},
			{description = "+250%", data = 3.5},
			{description = "+300%", data = 4.0},
			{description = "+350%", data = 4.5},
			{description = "+400%", data = 5.0},
		},
		default = 2.0,
	},

	{
		name = "FireArrowLog_req",
		label = "Fire Arrow recipe - Shafts",
		hover = "Amount of Shafts required to craft Fire Arrows",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "FireArrowFeather_req",
		label = "Fire Arrow recipe - Feather",
		hover = "Amount of Crimson Feather required to craft Fire Arrows",
		options =
		{
			{description = "0", data = 0},
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "FireArrowGrass_req",
		label = "Fire Arrow recipe - Grass",
		hover = "Amount of Grass required to craft Fire Arrows",
		options =
		{
			{description = "0", data = 0},
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "FireArrowHeadType",
		label = "Fire Arrow Head : ",
		hover = "Which material will be used for the Fire Arrows heads",
		options =
		{
			{description = "Charcoal", data = "charcoal"},
			{description = "Torch", data = "torch"},
		},
		default = "charcoal",
	},

	{
		name = "FireArrowHead_req",
		label = "Fire Arrow recipe - Head",
		hover = "Amount of the material chosen for the head required to craft Fire Arrows",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "FireArrowCraftAmount",
		label = "Fire Arrow recipe - Result",
		hover = "Amount of Fire Arrows you get from the recipe",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 5,
	},

		{
		name = "FireArrowTechLevel",
		label = "Fire Arrow Tech. Level",
		hover = "Machine required to craft the Fire Arrows",
		options =
		{
			{description = "None", data = "NONE"},
			{description = "Sc. Mach.", data = "SCIENCE_ONE"},
			{description = "Alch. Eng.", data = "SCIENCE_TWO"},
			{description = "Prestihat.", data = "MAGIC_TWO"},
			{description = "Sh. Manip.", data = "MAGIC_THREE"},
		},
		default = "SCIENCE_TWO",
	},

	{
		name = "FireArrowDmgMod",
		label = "Fire Arrow Dmg. Mod.",
		hover = "Damage modifier of the Fire Arrows compared to the regular Arrow",
		options =
		{
			{description = "same", data = 1.0},
			{description = "+25%", data = 1.25},
			{description = "+50%", data = 1.5},
			{description = "+75%", data = 1.75},
			{description = "+100%", data = 2.0},
			{description = "+125%", data = 2.25},
			{description = "+150%", data = 2.5},
			{description = "+175%", data = 2.75},
			{description = "+200%", data = 3.0},
			{description = "+250%", data = 3.5},
			{description = "+300%", data = 4.0},
		},
		default = 1.25,
	},

	{
		name = "IceArrowLog_req",
		label = "Ice Arrow recipe - Shafts",
		hover = "Amount of Shafts required to craft Ice Arrows",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "IceArrowFeather_req",
		label = "Ice Arrow recipe - Feather",
		hover = "Amount of Azure Feather required to craft Ice Arrows",
		options =
		{
			{description = "0", data = 0},
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "IceArrowHeadType",
		label = "Ice Arrow Head : ",
		hover = "Which material will be used for the Ice Arrows heads",
		options =
		{
			{description = "Ice", data = "ice"},
			{description = "Blue Gem", data = "bluegem"},
		},
		default = "ice",
	},

	{
		name = "IceArrowHead_req",
		label = "Ice Arrow recipe - Head",
		hover = "Amount of the material chosen for the head required to craft Ice Arrows",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "IceArrowCraftAmount",
		label = "Ice Arrow recipe - Result",
		hover = "Amount of Ice Arrows you get from the recipe",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 5,
	},

		{
		name = "IceArrowTechLevel",
		label = "Ice Arrow Tech. Level",
		hover = "Machine required to craft the Ice Arrows",
		options =
		{
			{description = "None", data = "NONE"},
			{description = "Sc. Mach.", data = "SCIENCE_ONE"},
			{description = "Alch. Eng.", data = "SCIENCE_TWO"},
			{description = "Prestihat.", data = "MAGIC_TWO"},
			{description = "Sh. Manip.", data = "MAGIC_THREE"},
		},
		default = "SCIENCE_TWO",
	},

	{
		name = "IceArrowDmgMod",
		label = "Ice Arrow Dmg. Mod.",
		hover = "Damage modifier of the Ice Arrows compared to the regular Arrow",
		options =
		{
			{description = "-60%", data = 0.40},
			{description = "-55%", data = 0.45},
			{description = "-50%", data = 0.50},
			{description = "-45%", data = 0.55},
			{description = "-40%", data = 0.60},
			{description = "-35%", data = 0.65},
			{description = "-30%", data = 0.70},
			{description = "-25%", data = 0.75},
			{description = "-20%", data = 0.80},
			{description = "-15%", data = 0.85},
			{description = "-10%", data = 0.90},
			{description = "-5%", data = 0.95},
			{description = "same", data = 1.0},
			{description = "same", data = 1.0},
			{description = "+25%", data = 1.25},
			{description = "+50%", data = 1.5},
			{description = "+75%", data = 1.75},
			{description = "+100%", data = 2.0},
			{description = "+125%", data = 2.25},
			{description = "+150%", data = 2.5},
			{description = "+175%", data = 2.75},
			{description = "+200%", data = 3.0},
			{description = "+250%", data = 3.5},
			{description = "+300%", data = 4.0},
		},
		default = 0.75,
	},

	{
		name = "ThunderArrowLog_req",
		label = "Thunder Arrow recipe - Shafts",
		hover = "Amount of Shafts required to craft Thunder Arrows",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "ThunderArrowFeather_req",
		label = "Thunder Arrow recipe - Feather",
		hover = "Amount of Azure Feather required to craft Thunder Arrows",
		options =
		{
			{description = "0", data = 0},
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "ThunderArrowHeadType",
		label = "Thunder Arrow Head : ",
		hover = "Which material will be used for the Thunder Arrows heads",
		options =
		{
			{description = "Volt Goat Horn", data = "lightninggoathorn"},
			{description = "Elec. Doodad", data = "transistor"},
		},
		default = "lightninggoathorn",
	},

	{
		name = "ThunderArrowHead_req",
		label = "Thunder Arrow recipe - Head",
		hover = "Amount of the material chosen for the head required to craft Thunder Arrows",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "ThunderArrowCraftAmount",
		label = "Thunder Arrow recipe - Result",
		hover = "Amount of Thunder Arrows you get from the recipe",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 5,
	},

		{
		name = "ThunderArrowTechLevel",
		label = "Thunder Arrow Tech. Level",
		hover = "Machine required to craft the Thunder Arrows",
		options =
		{
			{description = "None", data = "NONE"},
			{description = "Sc. Mach.", data = "SCIENCE_ONE"},
			{description = "Alch. Eng.", data = "SCIENCE_TWO"},
			{description = "Prestihat.", data = "MAGIC_TWO"},
			{description = "Sh. Manip.", data = "MAGIC_THREE"},
		},
		default = "SCIENCE_TWO",
	},

	{
		name = "ThunderArrowDmgMod",
		label = "Thunder Arrow Dmg. Mod.",
		hover = "Damage modifier of the Thunder Arrows compared to the regular Arrow",
		options =
		{
			{description = "-60%", data = 0.40},
			{description = "-55%", data = 0.45},
			{description = "-50%", data = 0.50},
			{description = "-45%", data = 0.55},
			{description = "-40%", data = 0.60},
			{description = "-35%", data = 0.65},
			{description = "-30%", data = 0.70},
			{description = "-25%", data = 0.75},
			{description = "-20%", data = 0.80},
			{description = "-15%", data = 0.85},
			{description = "-10%", data = 0.90},
			{description = "-5%", data = 0.95},
			{description = "same", data = 1.0},
			{description = "same", data = 1.0},
			{description = "+25%", data = 1.25},
			{description = "+50%", data = 1.5},
			{description = "+75%", data = 1.75},
			{description = "+100%", data = 2.0},
			{description = "+125%", data = 2.25},
			{description = "+150%", data = 2.5},
			{description = "+175%", data = 2.75},
			{description = "+200%", data = 3.0},
			{description = "+250%", data = 3.5},
			{description = "+300%", data = 4.0},
		},
		default = 0.50,
	},

	{
		name = "LightningRodChargesNum",
		label = "Lightning Rod Charges",
		hover = "Amount of time a charged lightning rod can be used to recharge Thunder Arrows",
		options =
		{
			{description = "1", data = 1},
			{description = "5", data = 5},
			{description = "10", data = 10},
			{description = "15", data = 15},
			{description = "20", data = 20},
			{description = "25", data = 25},
			{description = "30", data = 30},
			{description = "40", data = 40},
		},
		default = 5,
	},

	{
		name = "BoltLog_req",
		label = "Bolt recipe - Shafts",
		hover = "Amount of Shafts required to craft Bolts",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "BoltFeather_req",
		label = "Bolt recipe - Feather",
		hover = "Amount of Crow Feather required to craft Bolts",
		options =
		{
			{description = "0", data = 0},
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "BoltHeadType",
		label = "Bolt Head : ",
		hover = "Which material will be used for the Bolt Heads",
		options =
		{
			{description = "Flint", data = "flint"},
			{description = "Stinger", data = "stinger"},
			{description = "Tooth", data = "houndstooth"},
		},
		default = "stinger",
	},

	{
		name = "BoltHead_req",
		label = "Bolt recipe - Head",
		hover = "Amount of the material chose for the head required to craft Bolts",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 2,
	},

	{
		name = "BoltCraftAmount",
		label = "Bolt recipe - Result",
		hover = "Amount of Bolts you get from the recipe",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 5,
	},

	{
		name = "BoltTechLevel",
		label = "Bolt Tech. Level",
		hover = "Machine required to craft the Bolts",
		options =
		{
			{description = "None", data = "NONE"},
			{description = "Sc. Mach.", data = "SCIENCE_ONE"},
			{description = "Alch. Eng.", data = "SCIENCE_TWO"},
		},
		default = "SCIENCE_ONE",
	},

	{
		name = "PoisonBoltLog_req",
		label = "Poison Bolt recipe - Shafts",
		hover = "Amount of Shafts required to craft Poison Bolts",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "PoisonBoltFeather_req",
		label = "Poison Bolt recipe - Feather",
		hover = "Amount of Crow Feather required to craft Poison Bolts",
		options =
		{
			{description = "0", data = 0},
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "PoisonBoltRedCap_req",
		label = "Poison Bolt recipe - Red Cap",
		hover = "Amount of Red Cap required to craft Poison Bolts",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "PoisonBoltHeadType",
		label = "Poison Bolt Head : ",
		hover = "Which material will be used for the Poison Bolts Heads",
		options =
		{
			{description = "Flint", data = "flint"},
			{description = "Stinger", data = "stinger"},
			{description = "Tooth", data = "houndstooth"},
		},
		default = "stinger",
	},

	{
		name = "PoisonBoltHead_req",
		label = "Poison Bolt recipe - Head",
		hover = "Amount of the material chose for the head required to craft Poison Bolts",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 2,
	},

	{
		name = "PoisonBoltCraftAmount",
		label = "PoisonBolt recipe - Result",
		hover = "Amount of Poison Bolts you get from the recipe",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 5,
	},

	{
		name = "PoisonBoltTechLevel",
		label = "Poison Bolt Tech. Level",
		hover = "Machine required to craft the Poison Bolts",
		options =
		{
			{description = "None", data = "NONE"},
			{description = "Sc. Mach.", data = "SCIENCE_ONE"},
			{description = "Alch. Eng.", data = "SCIENCE_TWO"},
			{description = "Prestihat.", data = "MAGIC_TWO"},
			{description = "Sh. Manip.", data = "MAGIC_THREE"},
		},
		default = "SCIENCE_ONE",
	},

	{
		name = "PoisonBoltDmgMod",
		label = "Poison Bolt Dmg. Mod.",
		hover = "Additional damages over time of the Poison Bolts compared to the regular Bolt",
		options =
		{
			{description = "none", data = 0},
			{description = "+25%", data = 0.25},
			{description = "+50%", data = 0.5},
			{description = "+75%", data = 0.75},
			{description = "+100%", data = 1.0},
			{description = "+125%", data = 1.25},
			{description = "+150%", data = 1.5},
			{description = "+175%", data = 1.75},
			{description = "+200%", data = 2.0},
			{description = "+250%", data = 2.5},
			{description = "+300%", data = 3.0},
		},
		default = 0.75,
	},

	{
		name = "PoisonBoltDuration",
		label = "Poison Bolt Duration",
		hover = "Duration of the poisoning effect of the Poison Bolts",
		options =
		{
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
			{description = "11", data = 11},
			{description = "12", data = 12},
			{description = "13", data = 13},
			{description = "14", data = 14},
		},
		default = 8,
	},

	{
		name = "ExplosiveBoltLog_req",
		label = "Explosive Bolt recipe - Shafts",
		hover = "Amount of Shafts required to craft Explosive Bolts",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "ExplosiveBoltFeather_req",
		label = "Explosive Bolt recipe - Feather",
		hover = "Amount of Crow Feather required to craft Explosive Bolts",
		options =
		{
			{description = "0", data = 0},
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "ExplosiveBoltMosquitoSack_req",
		label = "Explosive Bolt recipe - Mosquito Sack",
		hover = "Amount of Mosquito Sack required to craft Explosive Bolts",
		options =
		{
			{description = "0", data = 0},
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "ExplosiveBoltHeadType",
		label = "Explosive Bolt Head : ",
		hover = "Which material will be used for the Explosive Bolt Heads",
		options =
		{
			{description = "Gun Powd.", data = "gunpowder"},
			{description = "Red Gem", data = "redgem"},
		},
		default = "gunpowder",
	},

	{
		name = "ExplosiveBoltHead_req",
		label = "Explosive Bolt recipe - Head",
		hover = "Amount of the material chose for the head required to craft Explosive Bolts",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 2,
	},

	{
		name = "ExplosiveBoltCraftAmount",
		label = "Explosive Bolt recipe - Result",
		hover = "Amount of Explosive Bolts you get from the recipe",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 5,
	},

	{
		name = "ExplosiveBoltTechLevel",
		label = "Explosive Bolt Tech. Level",
		hover = "Machine required to craft the Explosive Bolts",
		options =
		{
			{description = "None", data = "NONE"},
			{description = "Sc. Mach.", data = "SCIENCE_ONE"},
			{description = "Alch. Eng.", data = "SCIENCE_TWO"},
			{description = "Prestihat.", data = "MAGIC_TWO"},
			{description = "Sh. Manip.", data = "MAGIC_THREE"},
		},
		default = "SCIENCE_TWO",
	},

	{
		name = "ExplosiveBoltRadius",
		label = "Explosive Bolt Radius",
		hover = "Radius of the explosion of the Explosive Bolts",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 4,
	},

	{
		name = "ExplosiveBoltExpDmg",
		label = "Explosive Bolt Exp. Damages",
		hover = "Explosive damages of the Explosive Bolts",
		options =
		{
			{description = "20", data = 20},
			{description = "30 (~spear damage)", data = 30},
			{description = "40", data = 40},
			{description = "50", data = 50},
			{description = "60", data = 60},
			{description = "70", data = 70},
			{description = "80", data = 80},
			{description = "90", data = 90},
			{description = "100", data = 100},
			{description = "110", data = 110},
			{description = "120", data = 120},
			{description = "130", data = 130},
			{description = "140", data = 140},
			{description = "150", data = 150},
			{description = "160", data = 160},
			{description = "170", data = 170},
			{description = "180", data = 180},
			{description = "190", data = 190},
			{description = "200", data = 200},
		},
		default = 80,
	},

	{
		name = "MusketBulletType",
		label = "Musket Bullet Material : ",
		hover = "Which material will be used for the Musket Bullets",
		options =
		{
			{description = "Rocks", data = "rocks", hover = "Rocks will be used as a base"},
			{description = "Iron Ore", data = "mnzironore", hover = "(REQUIRE Mining Machine Mod) Iron Ore will be used as a base"},
		},
		default = "mnzironore",
	},

	{
		name = "MusketBulletHead_req",
		label = "Musket Bullet recipe - Type",
		hover = "Amount of the material chosen for the Musket Bullets",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "MusketBulletGP_req",
		label = "Musket Bullet recipe - Gun Pwd.",
		hover = "Amount of Gun Powder required to craft Musket Bullets",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 1,
	},

	{
		name = "MusketBulletCraftAmount",
		label = "Musket Bullet recipe - Result",
		hover = "Amount of Musket Bullets you get from the recipe",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 5,
	},
}


