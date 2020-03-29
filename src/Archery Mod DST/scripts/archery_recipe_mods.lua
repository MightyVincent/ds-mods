local table = GLOBAL.table

local STRINGS = GLOBAL.STRINGS
local RECIPETABS = GLOBAL.RECIPETABS
local Recipe = GLOBAL.Recipe
local GIngredient = GLOBAL.Ingredient
local TECH = GLOBAL.TECH
local TUNING = GLOBAL.TUNING

local function ReturnTechLevel(modcfg)
	if modcfg == "NONE" then
		return TECH.NONE
	elseif modcfg == "SCIENCE_ONE" then
		return TECH.SCIENCE_ONE
	elseif modcfg == "SCIENCE_TWO" then
		return TECH.SCIENCE_TWO		
	elseif modcfg == "MAGIC_TWO" then
		return TECH.MAGIC_TWO			
	elseif modcfg == "MAGIC_THREE" then
		return TECH.MAGIC_THREE			
	end
end

local archerytab = AddRecipeTab("Archery", 6, "images/tabimages/archery_tab.xml", "archery_tab.tex", nil)

local function MakeIngredientsList(...)
	local ing_list = {}
	
	local args = {...}
	
	for i, v in ipairs(args) do
		table.insert(ing_list, GIngredient(v[1], v[2]))
	end
	
	return ing_list
end

local function AddIngredientToList(list, ingredient)
	table.insert(list, GIngredient(ingredient[1], ingredient[2]))
end

local CarverIngredients = MakeIngredientsList({"log", 1}, {"flint", 1})
AddRecipe("arrow_carver", CarverIngredients , archerytab, TECH.SCIENCE_ONE, nil, nil, nil, 1, nil, "images/inventoryimages/carver.xml", "carver.tex")

local QUIVERrecipeIngredients = MakeIngredientsList({"pigskin", GLOBAL.ARCHERYPARAMS.QUIVERREQPIGSKIN}, {"rope", GLOBAL.ARCHERYPARAMS.QUIVERREQROPE})
AddRecipe("quiver", QUIVERrecipeIngredients , archerytab, ReturnTechLevel(GLOBAL.ARCHERYPARAMS.QUIVERTECHLEVEL), nil, nil, nil, 1, nil, "images/inventoryimages/quiver.xml", "quiver.tex")

local BOWrecipeIngredients = MakeIngredientsList({"twigs", GLOBAL.ARCHERYPARAMS.BOWREQTWIGS}, {"silk", GLOBAL.ARCHERYPARAMS.BOWREQSILK})
AddRecipe("bow", BOWrecipeIngredients , archerytab, ReturnTechLevel(GLOBAL.ARCHERYPARAMS.BOWTECHLEVEL), nil, nil, nil, 1, nil, "images/inventoryimages/bow.xml", "bow.tex")

GLOBAL.ARCHERY_INGREDIENTS_INFOS = {
	feathers = {
		feather_crow = { key = "black", yield = 1 },
		feather_robin = { key = "red", yield = 1 },
		feather_robin_winter = { key = "blue", yield = 1 },
		feather_canary = { key = "yellow", yield = 1 },
	},
	
	bodies = {
		log = { key = "wood", yield = 2.5},
		twigs = { key = "wood", yield = 1},
		boneshard = { key = "bone", yield = 0.34},
	},
	
	heads = {
		flint = { key = "flint", yield = 1 },
		goldnugget = { key = "gold", yield = 1 },
		moonrocknugget = { key = "moon", yield = 1 },
		ice = { key = "ice", yield = 1 },
		-- bluegem = { key = "bluegem", yield = 1 },
		-- redgem = { key = "redgem", yield = 1 },
		-- greengem = { key = "greengem", yield = 1 },
		-- purplegem = { key = "purplegem", yield = 1 },
		-- yellowgem = { key = "yellowgem", yield = 1 },
		lightninggoathorn = { key = "horn", yield = 1 },
		-- transistor = { key = "doodad", yield = 1 },
		-- stinger = { key = "stinger", yield = 0.5 },
		-- houndstooth = { key = "tooth", yield = 1 },
		torch = { key = "fire", yield = 1 },
		charcoal = { key = "fire", yield = 1 },
	},
}

GLOBAL.ARCHERY_TAGS = {
	flint = { "piercing", "sharp", "recoverable" },
	gold = { "piercing", "sharp", "golden", "recoverable" },
	moon = { "piercing", "sharp", "moonstone", "recoverable" },
	ice = { "piercing", "freezing", "recoverable" },
	horn = { "recoverable", "electric" },
	fire = { "piercing", "burning", "recoverable" },
}

GLOBAL.ARCHERY_CTORS_COMMON = {
	moon = { { fn = "addlight", data = {intensity = 0.6, radius = 0.5, falloff = 0.75, enabled = true, b = 255} } },
}

GLOBAL.ARCHERY_CTORS_MASTER = {
	gold = {
		{ fn = "setprojdmg", data = { dmg = TUNING.BOWDMG*TUNING.GOLDARROWDMGMOD } }
	},
	
	horn = {
		{ fn = "setondropped", data = {component = inventoryitem, fn = GLOBAL.ARCHERYFUNCS.startflickering} },
		{ fn = "setonpickup", data = {component = inventoryitem, fn = GLOBAL.ARCHERYFUNCS.stopflickering} },
		{ fn = "setprojdmg", data = { dmg = TUNING.BOWDMG*TUNING.THUNDERARROWDMGMOD } },
		{ fn = "setbaseproj", data = { head = "horn", suffix = "discharged" } }
	},
	
	moon = { 
		{fn = "emitlight", data = {} },
		{ fn = "setprojdmg", data = { dmg = TUNING.BOWDMG*TUNING.MOONSTONEARROWDMGMOD } }
	},
	
	fire = {
		{ fn = "setprojdmg", data = { dmg = TUNING.BOWDMG*(TUNING.FIREARROWDMGMOD/2.0) } }	
	},
	
	ice = {
		{ fn = "setprojdmg", data = { dmg = TUNING.BOWDMG*TUNING.ICEARROWDMGMOD } }	
	}
}

GLOBAL.ARCHERY_SHOOT_FNS = {

}

GLOBAL.ARCHERY_HIT_FNS = {
	horn = {
		{ fn = "thunderfn", data = {} }
	},
	
	fire = {
		{ fn = "firefn", data = {} }	
	},
	
	ice = {
		{ fn = "icefn", data = {} }	
	}
}

GLOBAL.ARCHERY_MISS_FNS = {

}

local ingr_info = GLOBAL.ARCHERY_INGREDIENTS_INFOS

function GLOBAL.ARCHERYFUNCS.GetPrefabRecipe(feather, body, head)
	local pre_str = feather ~= nil and (feather:HasTag("bolt_ingredient") and "bolt" or "arrow") or nil
	local body_str = ingr_info.bodies[body.prefab] and ingr_info.bodies[body.prefab].key or nil
	local feather_str = ingr_info.feathers[feather.prefab] and ingr_info.feathers[feather.prefab].key or nil
	local head_str = ingr_info.heads[head.prefab] and ingr_info.heads[head.prefab].key or nil
	
	if body_str and feather_str and head_str then
		return (pre_str .. "_" .. feather_str .. "_" .. body_str .. "_" .. head_str)
	end
end

function GLOBAL.ARCHERYFUNCS.ProcessCarverRecipe(feather, body, head)
	local feather_stacksize = 1
	local body_stacksize = 1
	local head_stacksize = 1

	if feather.replica and feather.replica.stackable then
		feather_stacksize = feather.replica.stackable:StackSize()
	end
	
	if body.replica and body.replica.stackable then
		body_stacksize = body.replica.stackable:StackSize()
	end
	
	if head.replica and head.replica.stackable then
		head_stacksize = head.replica.stackable:StackSize()
	end
	
	local feather_yield = math.floor(feather_stacksize*ingr_info.feathers[feather.prefab].yield)
	local body_yield = math.floor(body_stacksize*ingr_info.bodies[body.prefab].yield)
	local head_yield = math.floor(head_stacksize*ingr_info.heads[head.prefab].yield)
	
	local final_yield = math.min(feather_yield, body_yield, head_yield)
	
	local feather_consume = math.ceil(final_yield/ingr_info.feathers[feather.prefab].yield)
	local body_consume = math.ceil(final_yield/ingr_info.bodies[body.prefab].yield)
	local head_consume = math.ceil(final_yield/ingr_info.heads[head.prefab].yield)
	
	local result = GLOBAL.ARCHERYFUNCS.GetPrefabRecipe(feather, body, head)
	
	local items = GLOBAL.SpawnPrefab(result)
	items.components.stackable:SetStackSize(final_yield)
	
	local feather_remaining = nil
	local body_remaining = nil
	local head_remaining = nil
	
	if feather.components.stackable then
		if feather_consume < feather.components.stackable:StackSize() then
			feather_remaining = GLOBAL.SpawnPrefab(feather.prefab)
			feather_remaining.components.stackable:SetStackSize(feather.components.stackable:StackSize() - feather_consume)
		end
	end
	
	feather:Remove()
	feather	= nil
	
	if body.components.stackable then
		if body_consume < body.components.stackable:StackSize() then
			body_remaining = GLOBAL.SpawnPrefab(body.prefab)
			body_remaining.components.stackable:SetStackSize(body.components.stackable:StackSize() - body_consume)
		end
	end
	
	body:Remove()
	body = nil
	
	if head.components.stackable then
		if head_consume < head.components.stackable:StackSize() then
			head_remaining = GLOBAL.SpawnPrefab(head.prefab)
			head_remaining.components.stackable:SetStackSize(head.components.stackable:StackSize() - head_consume)
		end
	end
	
	head:Remove()
	head = nil
		
	return items, feather_remaining, body_remaining, head_remaining
end

--------------------------------------------- LEGACY RECIPES ----------------------------------------------------------------------------------------------------------

local ARROWrecipeIngredients = {}

ARROWrecipeIngredients[#ARROWrecipeIngredients + 1]= GIngredient(GLOBAL.ARCHERYPARAMS.ARROWHEADTYPE, GLOBAL.ARCHERYPARAMS.ARROWREQHEAD);
ARROWrecipeIngredients[#ARROWrecipeIngredients + 1] = GIngredient(GLOBAL.ARCHERYPARAMS.PROJSHAFTTYPE, GLOBAL.ARCHERYPARAMS.ARROWREQLOG);
if GLOBAL.ARCHERYPARAMS.ARROWREQFEATHER > 0 then
	ARROWrecipeIngredients[#ARROWrecipeIngredients + 1] = GIngredient("feather_crow", GLOBAL.ARCHERYPARAMS.ARROWREQFEATHER);
end

AddRecipe("arrow", ARROWrecipeIngredients , archerytab, ReturnTechLevel(GLOBAL.ARCHERYPARAMS.ARROWTECHLEVEL), nil, nil, nil, GLOBAL.ARCHERYPARAMS.ARROWCRAFTNUM, nil, "images/inventoryimages/arrow.xml", "arrow.tex")

local GOLDARROWrecipeIngredients = {}

GOLDARROWrecipeIngredients[#GOLDARROWrecipeIngredients + 1]= GIngredient("goldnugget", GLOBAL.ARCHERYPARAMS.GOLDARROWREQHEAD);
GOLDARROWrecipeIngredients[#GOLDARROWrecipeIngredients + 1] = GIngredient(GLOBAL.ARCHERYPARAMS.PROJSHAFTTYPE, GLOBAL.ARCHERYPARAMS.GOLDARROWREQLOG);
if GLOBAL.ARCHERYPARAMS.GOLDARROWREQFEATHER > 0 then
	GOLDARROWrecipeIngredients[#GOLDARROWrecipeIngredients + 1] = GIngredient("feather_crow", GLOBAL.ARCHERYPARAMS.GOLDARROWREQFEATHER);
end

AddRecipe(	"goldarrow", GOLDARROWrecipeIngredients , archerytab, ReturnTechLevel(GLOBAL.ARCHERYPARAMS.GOLDARROWTECHLEVEL), nil, nil, nil, 
			GLOBAL.ARCHERYPARAMS.GOLDARROWCRAFTNUM, nil, "images/inventoryimages/goldarrow.xml", "goldarrow.tex")

local MOONSTONEARROWrecipeIngredients = {}

MOONSTONEARROWrecipeIngredients[#MOONSTONEARROWrecipeIngredients + 1]= GIngredient("moonrocknugget", GLOBAL.ARCHERYPARAMS.MOONSTONEARROWREQHEAD);
MOONSTONEARROWrecipeIngredients[#MOONSTONEARROWrecipeIngredients + 1] = GIngredient(GLOBAL.ARCHERYPARAMS.PROJSHAFTTYPE, GLOBAL.ARCHERYPARAMS.MOONSTONEARROWREQLOG);
if GLOBAL.ARCHERYPARAMS.MOONSTONEARROWREQFEATHER > 0 then
	MOONSTONEARROWrecipeIngredients[#MOONSTONEARROWrecipeIngredients + 1] = GIngredient("feather_crow", GLOBAL.ARCHERYPARAMS.MOONSTONEARROWREQFEATHER);
end

AddRecipe(	"moonstonearrow", MOONSTONEARROWrecipeIngredients , archerytab, ReturnTechLevel(GLOBAL.ARCHERYPARAMS.MOONSTONEARROWTECHLEVEL), nil, nil, nil, 
			GLOBAL.ARCHERYPARAMS.MOONSTONEARROWCRAFTNUM, nil, "images/inventoryimages/moonstonearrow.xml", "moonstonearrow.tex")

local FIREARROWrecipeIngredients = {}

FIREARROWrecipeIngredients[#FIREARROWrecipeIngredients + 1] = GIngredient(GLOBAL.ARCHERYPARAMS.PROJSHAFTTYPE, GLOBAL.ARCHERYPARAMS.FIREARROWREQLOG);
FIREARROWrecipeIngredients[#FIREARROWrecipeIngredients + 1]= GIngredient(GLOBAL.ARCHERYPARAMS.FIREARROWHEADTYPE, GLOBAL.ARCHERYPARAMS.FIREARROWREQHEAD);
if GLOBAL.ARCHERYPARAMS.FIREARROWREQFEATHER > 0 then
	FIREARROWrecipeIngredients[#FIREARROWrecipeIngredients + 1] = GIngredient("feather_robin", GLOBAL.ARCHERYPARAMS.FIREARROWREQFEATHER);
end
if GLOBAL.ARCHERYPARAMS.FIREARROWREQGRASS > 0 then
	FIREARROWrecipeIngredients[#FIREARROWrecipeIngredients + 1] = GIngredient("cutgrass", GLOBAL.ARCHERYPARAMS.FIREARROWREQGRASS);
end

AddRecipe(	"firearrow", FIREARROWrecipeIngredients , archerytab, ReturnTechLevel(GLOBAL.ARCHERYPARAMS.FIREARROWTECHLEVEL), nil, nil, nil, 
			GLOBAL.ARCHERYPARAMS.FIREARROWCRAFTNUM, nil, "images/inventoryimages/firearrow.xml", "firearrow.tex")

local ICEARROWrecipeIngredients = {}

ICEARROWrecipeIngredients[#ICEARROWrecipeIngredients + 1] = GIngredient(GLOBAL.ARCHERYPARAMS.PROJSHAFTTYPE, GLOBAL.ARCHERYPARAMS.ICEARROWREQLOG);
ICEARROWrecipeIngredients[#ICEARROWrecipeIngredients + 1]= GIngredient(GLOBAL.ARCHERYPARAMS.ICEARROWHEADTYPE, GLOBAL.ARCHERYPARAMS.ICEARROWREQHEAD);
if GLOBAL.ARCHERYPARAMS.ICEARROWREQFEATHER > 0 then
	ICEARROWrecipeIngredients[#ICEARROWrecipeIngredients + 1] = GIngredient("feather_robin_winter", GLOBAL.ARCHERYPARAMS.ICEARROWREQFEATHER);
end

AddRecipe(	"icearrow", ICEARROWrecipeIngredients , archerytab, ReturnTechLevel(GLOBAL.ARCHERYPARAMS.ICEARROWTECHLEVEL), nil, nil, nil, 
			GLOBAL.ARCHERYPARAMS.ICEARROWCRAFTNUM, nil, "images/inventoryimages/icearrow.xml", "icearrow.tex")

local THUNDERARROWrecipeIngredients = {}

THUNDERARROWrecipeIngredients[#THUNDERARROWrecipeIngredients + 1] = GIngredient(GLOBAL.ARCHERYPARAMS.PROJSHAFTTYPE, GLOBAL.ARCHERYPARAMS.THUNDERARROWREQLOG);
THUNDERARROWrecipeIngredients[#THUNDERARROWrecipeIngredients + 1]= GIngredient(GLOBAL.ARCHERYPARAMS.THUNDERARROWHEADTYPE, GLOBAL.ARCHERYPARAMS.THUNDERARROWREQHEAD);
if GLOBAL.ARCHERYPARAMS.THUNDERARROWREQFEATHER > 0 then
	THUNDERARROWrecipeIngredients[#THUNDERARROWrecipeIngredients + 1] = GIngredient("feather_robin_winter", GLOBAL.ARCHERYPARAMS.THUNDERARROWREQFEATHER);
end

AddRecipe(	"thunderarrow", THUNDERARROWrecipeIngredients , archerytab, ReturnTechLevel(GLOBAL.ARCHERYPARAMS.THUNDERARROWTECHLEVEL), nil, nil, nil, 
			GLOBAL.ARCHERYPARAMS.THUNDERARROWCRAFTNUM, nil, "images/inventoryimages/thunderarrow.xml", "thunderarrow.tex")

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local CROSSBOWrecipeIngredients = MakeIngredientsList({"boards", GLOBAL.ARCHERYPARAMS.CROSSBOWREQBOARDS}, {"silk", GLOBAL.ARCHERYPARAMS.CROSSBOWREQSILK})
if GLOBAL.ARCHERYPARAMS.CROSSBOWREQHAMMER > 0 then
	AddIngredientToList(CROSSBOWrecipeIngredients, {"hammer", GLOBAL.ARCHERYPARAMS.CROSSBOWREQHAMMER});
end

AddRecipe("crossbow", CROSSBOWrecipeIngredients , archerytab, ReturnTechLevel(GLOBAL.ARCHERYPARAMS.CROSSBOWTECHLEVEL), nil, nil, nil, 1, nil, "images/inventoryimages/crossbow.xml", "crossbow.tex")

local BOLTrecipeIngredients = {}

BOLTrecipeIngredients[#BOLTrecipeIngredients + 1]= GIngredient(GLOBAL.ARCHERYPARAMS.PROJSHAFTTYPE, GLOBAL.ARCHERYPARAMS.BOLTREQLOG);
if GLOBAL.ARCHERYPARAMS.BOLTREQFEATHER > 0 then
	BOLTrecipeIngredients[#BOLTrecipeIngredients + 1] = GIngredient("feather_crow", GLOBAL.ARCHERYPARAMS.BOLTREQFEATHER);
end
BOLTrecipeIngredients[#BOLTrecipeIngredients + 1] = GIngredient(GLOBAL.ARCHERYPARAMS.BOLTHEADTYPE, GLOBAL.ARCHERYPARAMS.BOLTREQHEAD);

AddRecipe("bolt", BOLTrecipeIngredients , archerytab, ReturnTechLevel(GLOBAL.ARCHERYPARAMS.BOLTTECHLEVEL), nil, nil, nil, GLOBAL.ARCHERYPARAMS.BOLTCRAFTNUM, nil, "images/inventoryimages/bolt.xml", "bolt.tex")

local POISONBOLTrecipeIngredients = {}

POISONBOLTrecipeIngredients[#POISONBOLTrecipeIngredients + 1]= GIngredient(GLOBAL.ARCHERYPARAMS.PROJSHAFTTYPE, GLOBAL.ARCHERYPARAMS.POISONBOLTREQLOG);
if GLOBAL.ARCHERYPARAMS.POISONBOLTREQFEATHER > 0 then
	POISONBOLTrecipeIngredients[#POISONBOLTrecipeIngredients + 1] = GIngredient("feather_crow", GLOBAL.ARCHERYPARAMS.POISONBOLTREQFEATHER);
end
POISONBOLTrecipeIngredients[#POISONBOLTrecipeIngredients + 1] = GIngredient(GLOBAL.ARCHERYPARAMS.POISONBOLTHEADTYPE, GLOBAL.ARCHERYPARAMS.POISONBOLTREQHEAD);
POISONBOLTrecipeIngredients[#POISONBOLTrecipeIngredients + 1] = GIngredient("red_cap", GLOBAL.ARCHERYPARAMS.POISONBOLTREQREDCAP);

AddRecipe(	"poisonbolt", POISONBOLTrecipeIngredients , archerytab, ReturnTechLevel(GLOBAL.ARCHERYPARAMS.POISONBOLTTECHLEVEL), nil, nil, nil, 
			GLOBAL.ARCHERYPARAMS.POISONBOLTCRAFTNUM, nil, "images/inventoryimages/poisonbolt.xml", "poisonbolt.tex")

local EXPLOSIVEBOLTrecipeIngredients = {}

EXPLOSIVEBOLTrecipeIngredients[#EXPLOSIVEBOLTrecipeIngredients + 1]= GIngredient(GLOBAL.ARCHERYPARAMS.PROJSHAFTTYPE, GLOBAL.ARCHERYPARAMS.EXPLOSIVEBOLTREQLOG);
if GLOBAL.ARCHERYPARAMS.EXPLOSIVEBOLTREQFEATHER > 0 then
	EXPLOSIVEBOLTrecipeIngredients[#EXPLOSIVEBOLTrecipeIngredients + 1] = GIngredient("feather_crow", GLOBAL.ARCHERYPARAMS.EXPLOSIVEBOLTREQFEATHER);
end
if GLOBAL.ARCHERYPARAMS.EXPLOSIVEBOLTREQMOSQUITO > 0 then
	EXPLOSIVEBOLTrecipeIngredients[#EXPLOSIVEBOLTrecipeIngredients + 1] = GIngredient("mosquitosack", GLOBAL.ARCHERYPARAMS.EXPLOSIVEBOLTREQMOSQUITO);
end
EXPLOSIVEBOLTrecipeIngredients[#BOLTrecipeIngredients + 1] = GIngredient(GLOBAL.ARCHERYPARAMS.EXPLOSIVEBOLTHEADTYPE, GLOBAL.ARCHERYPARAMS.EXPLOSIVEBOLTREQHEAD);

AddRecipe(	"explosivebolt", EXPLOSIVEBOLTrecipeIngredients , archerytab, ReturnTechLevel(GLOBAL.ARCHERYPARAMS.EXPLOSIVEBOLTTECHLEVEL), nil, nil, nil, 
			GLOBAL.ARCHERYPARAMS.EXPLOSIVEBOLTCRAFTNUM, nil, "images/inventoryimages/explosivebolt.xml", "explosivebolt.tex")

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local MAGICBOWrecipeIngredients = MakeIngredientsList({"livinglog", GLOBAL.ARCHERYPARAMS.MAGICBOWREQLIVINGLOG}, {"purplegem", GLOBAL.ARCHERYPARAMS.MAGICBOWREQGEM})
if GLOBAL.ARCHERYPARAMS.MAGICBOWREQGLOMMER then
	AddIngredientToList(MAGICBOWrecipeIngredients, {"glommerflower", 1});
end

AddRecipe("magicbow", MAGICBOWrecipeIngredients , archerytab, ReturnTechLevel(GLOBAL.ARCHERYPARAMS.MAGICBOWTECHLEVEL), nil, nil, nil, 1, nil, "images/inventoryimages/magicbow.xml", "magicbow.tex")

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local MUSKETrecipeIngredients = {}

MUSKETrecipeIngredients[#MUSKETrecipeIngredients + 1] = GIngredient("boards", GLOBAL.ARCHERYPARAMS.MUSKETREQBOARDS);
MUSKETrecipeIngredients[#MUSKETrecipeIngredients + 1] = GIngredient("flint", GLOBAL.ARCHERYPARAMS.MUSKETREQFLINT);
if GLOBAL.ARCHERYPARAMS.MUSKETREQGOLD > 0 then
	MUSKETrecipeIngredients[#MUSKETrecipeIngredients + 1] = GIngredient("goldnugget", GLOBAL.ARCHERYPARAMS.MUSKETREQGOLD);
end
if GLOBAL.ARCHERYPARAMS.MUSKETREQIRON > 0 then
	if GLOBAL.ARCHERYPARAMS.IsMiningMachineEnabled then
		MUSKETrecipeIngredients[#MUSKETrecipeIngredients + 1] = GIngredient("mnzironore", GLOBAL.ARCHERYPARAMS.MUSKETREQIRON, "images/required/mnzironore.xml");
	elseif GLOBAL.ARCHERYPARAMS.MUSKETREQGOLD == 0 then
		MUSKETrecipeIngredients[#MUSKETrecipeIngredients + 1] = GIngredient("goldnugget", GLOBAL.ARCHERYPARAMS.MUSKETREQIRON);
	end
end

AddRecipe("musket", MUSKETrecipeIngredients , archerytab, ReturnTechLevel(GLOBAL.ARCHERYPARAMS.MUSKETTECHLEVEL), nil, nil, nil, 1, nil, "images/inventoryimages/musket.xml", "musket.tex")

local MUSKETBULLETrecipeIngredients = {}

if GLOBAL.ARCHERYPARAMS.MUSKETBULLETTYPE == "rocks" then
	MUSKETBULLETrecipeIngredients[#MUSKETBULLETrecipeIngredients + 1] = GIngredient("rocks", GLOBAL.ARCHERYPARAMS.MUSKETBULLETREQHEAD);
elseif MUSKETBULLETTYPE == "mnzironore" then
	if GLOBAL.ARCHERYPARAMS.IsMiningMachineEnabled then
		MUSKETBULLETrecipeIngredients[#MUSKETBULLETrecipeIngredients + 1] = GIngredient("mnzironore", GLOBAL.ARCHERYPARAMS.MUSKETBULLETREQHEAD, "images/required/mnzironore.xml");
	else
		MUSKETBULLETrecipeIngredients[#MUSKETBULLETrecipeIngredients + 1] = GIngredient("rocks", GLOBAL.ARCHERYPARAMS.MUSKETBULLETREQHEAD);
	end
end

MUSKETBULLETrecipeIngredients[#MUSKETBULLETrecipeIngredients + 1] = GIngredient("gunpowder", GLOBAL.ARCHERYPARAMS.MUSKETBULLETREQGP);

AddRecipe(	"musket_bullet", MUSKETBULLETrecipeIngredients , archerytab, ReturnTechLevel(GLOBAL.ARCHERYPARAMS.MUSKETTECHLEVEL), nil, nil, nil, 
			GLOBAL.ARCHERYPARAMS.MUSKETBULLETCRAFTNUM, nil, "images/inventoryimages/musket_bullet.xml", "musket_bullet.tex")

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local FIREFLIESBALLrecipeIngredients = {}

FIREFLIESBALLrecipeIngredients[#FIREFLIESBALLrecipeIngredients + 1] = GIngredient("fireflies", 1);
FIREFLIESBALLrecipeIngredients[#FIREFLIESBALLrecipeIngredients + 1] = GIngredient("honey", 3);

AddRecipe("z_firefliesball", FIREFLIESBALLrecipeIngredients , archerytab, ReturnTechLevel(GLOBAL.ARCHERYPARAMS.MAGICBOWTECHLEVEL), nil, nil, nil, 1, nil, "images/inventoryimages/z_firefliesball.xml", "z_firefliesball.tex")

local BLUEGOOPrecipeIngredients = {}

BLUEGOOPrecipeIngredients[#BLUEGOOPrecipeIngredients + 1] = GIngredient("spidergland", 1);
BLUEGOOPrecipeIngredients[#BLUEGOOPrecipeIngredients + 1] = GIngredient("blue_cap", 1);

AddRecipe("z_bluegoop", BLUEGOOPrecipeIngredients , archerytab, ReturnTechLevel(GLOBAL.ARCHERYPARAMS.MAGICBOWTECHLEVEL), nil, nil, nil, 1, nil, "images/inventoryimages/z_bluegoop.xml", "z_bluegoop.tex")

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

STRINGS.NAMES.ARROW_CARVER = "Arrow Carver"
STRINGS.RECIPE_DESC.ARROW_CARVER = "Used to craft arrows."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARROW_CARVER = "I could make some arrows with the proper items."

STRINGS.NAMES.BOW = "Wooden Bow"
STRINGS.RECIPE_DESC.BOW = "Useful if you can aim."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOW = "I used to be a good archer... then I took an arrow in the knee."

STRINGS.NAMES.QUIVER = "Quiver"
STRINGS.RECIPE_DESC.QUIVER = "Store your arrows!"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.QUIVER = "With this stuff, I will look like a serious archer."

STRINGS.NAMES.CROSSBOW = "Crossbow"
STRINGS.RECIPE_DESC.CROSSBOW = "Heavy and powerful."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CROSSBOW = "This stuff is bigger than me."

STRINGS.NAMES.MAGICBOW = "Magic Bow"
STRINGS.RECIPE_DESC.MAGICBOW = "Just like in fairy tails."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MAGICBOW = "I expect a rainbow farting unicorns anytime soon."

STRINGS.NAMES.MUSKET = "Musket"
STRINGS.RECIPE_DESC.MUSKET = "It's loud. You're warned."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MUSKET = "Am I the fifth musketeer?"

local feather_types = {}
local body_types = {}
local head_types = {}

for k, v in pairs(ingr_info.feathers) do
	if feather_types[v.key] == nil then
		feather_types[v.key] = true
	end
end

for k, v in pairs(ingr_info.bodies) do
	if body_types[v.key] == nil then
		body_types[v.key] = true
	end
end

for k, v in pairs(ingr_info.heads) do
	if head_types[v.key] == nil then
		head_types[v.key] = true
	end
end

for feather, _ in pairs(feather_types) do
	for body, _ in pairs(body_types) do
		for head, _ in pairs(head_types) do
			STRINGS.NAMES["ARROW_" .. string.upper(feather) .. "_" .. string.upper(body) .. "_" .. string.upper(head)] = "Arrow (" .. feather .. ", " .. body .. ", " .. head .. ")"
			STRINGS.CHARACTERS.GENERIC.DESCRIBE["ARROW_" .. string.upper(feather) .. "_" .. string.upper(body) .. "_" .. string.upper(head)] = "I used to be a good archer. Then I took an arrow to the knee..."
		end
		
		STRINGS.NAMES["ARROW_" .. string.upper(feather) .. "_" .. string.upper(body) .. "_HORN_DISCHARGED"] = "Arrow (" .. feather .. ", " .. body .. ", horn) DISCHARGED"
	end
end

------------------------------------------------------------------ LEGACY CODE ------------------------------------------------------------

STRINGS.NAMES.ARROW = "Basic Arrow"
STRINGS.RECIPE_DESC.ARROW = "Do not throw it bare handed."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARROW = "Probably best used with a bow..."

STRINGS.NAMES.GOLDARROW = "Gold Arrow"
STRINGS.RECIPE_DESC.GOLDARROW = "Hunt with style."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GOLDARROW = "I'm sure I could have found a better use this..."

STRINGS.NAMES.MOONSTONEARROW = "Moon Rock Arrow"
STRINGS.RECIPE_DESC.MOONSTONEARROW = "Expensive but efficient."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MOONSTONEARROW = "Sharp and shiny!"

STRINGS.NAMES.FIREARROW = "Fire Arrow"
STRINGS.RECIPE_DESC.FIREARROW = "Better be careful with that."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FIREARROW = "I should probably avoid using it in the middle of my camp..."

STRINGS.NAMES.ICEARROW = "Freezing Arrow"
STRINGS.RECIPE_DESC.ICEARROW = "Stay cool."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ICEARROW = "Should I keep it in the fridge?"

STRINGS.NAMES.THUNDERARROW = "Thunder Arrow"
STRINGS.RECIPE_DESC.THUNDERARROW = "Storm is coming."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.THUNDERARROW = "The red wire on the plus..."

STRINGS.NAMES.DISCHARGEDTHUNDERARROW = "Discharged Thunder Arrow"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DISCHARGEDTHUNDERARROW = "It looks like it is not active anymore."

STRINGS.NAMES.BOLT = "Basic Bolt"
STRINGS.RECIPE_DESC.BOLT = "Not a toothpick."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOLT = "Small projectile for such a big weapon..."

STRINGS.NAMES.POISONBOLT = "Poison Bolt"
STRINGS.RECIPE_DESC.POISONBOLT = "Cooked with arsenic."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.POISONBOLT = "Did it have to be so ugly?"

STRINGS.NAMES.EXPLOSIVEBOLT = "Explosive Bolt"
STRINGS.RECIPE_DESC.EXPLOSIVEBOLT = "Do not use point blank."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.EXPLOSIVEBOLT = "Is it really a good idea?"

STRINGS.NAMES.MUSKET_BULLET = "Musket Bullet"
STRINGS.RECIPE_DESC.MUSKET_BULLET = "Let's go hunting my  deer."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MUSKET_BULLET = "It looks like marbles"

STRINGS.NAMES.Z_FIREFLIESBALL = "Fireflies Ball"
STRINGS.RECIPE_DESC.Z_FIREFLIESBALL = "Do not eat"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.Z_FIREFLIESBALL = "It's probably useful for something. Don't ask me what."

STRINGS.NAMES.Z_BLUEGOOP = "Blue Goop"
STRINGS.RECIPE_DESC.Z_BLUEGOOP = "Do not shoot at your foes."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.Z_BLUEGOOP = "It looks gross."