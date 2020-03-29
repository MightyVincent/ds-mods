PrefabFiles = {
  "z_carver",
  "z_bow",
  "z_arrows",
  "z_crossbow",
  "z_bolts",
  "z_musket",
  "z_bullets",
  "z_archeryfxs",
  "z_quiver",
  "sparkles",
  "zupalexsingredients",

  "z_skin_crate",
}

Assets = {
  Asset( "ANIM", "anim/bow_attack.zip" ),
  Asset( "ANIM", "anim/bow_attack_new.zip" ),
  Asset( "ANIM", "anim/swap_mloader.zip" ),

  Asset( "ANIM", "anim/new_archery_skin.zip" ),

  Asset("SOUNDPACKAGE", "sound/bow_shoot.fev"),
  Asset("SOUND", "sound/bow_shoot_bank00.fsb"),

  Asset("ATLAS", "images/tabimages/archery_tab.xml"),
  Asset("IMAGE", "images/tabimages/archery_tab.tex"),

  Asset("ATLAS", "images/tabimages/quiver_slot.xml"),
  Asset("IMAGE", "images/tabimages/quiver_slot.tex"),

  Asset("ATLAS", "images/required/mnzironore.xml"),
  Asset("IMAGE", "images/required/mnzironore.tex"),

  Asset( "ANIM", "anim/archery_skin_display.zip" ),
}

local require = GLOBAL.require

require("common_archery_functions")

function GLOBAL.ARCHERYFUNCS.GenerateSkinAssets(skinname)
  local assets = {
    -- Asset("ANIM", "anim/swap_" .. skinname .. ".zip"),
    Asset("ANIM", "anim/" .. skinname .. ".zip"),

    Asset("ATLAS", "images/inventoryimages/" .. skinname.. ".xml"),
    Asset("IMAGE", "images/inventoryimages/" .. skinname.. ".tex")
  }

  return assets
end

----------------------------------CROSS MOD CHECKS-----------------------------------------------

GLOBAL.ARCHERYPARAMS = {}
ARCHERYPARAMS = GLOBAL.ARCHERYPARAMS

ARCHERYPARAMS.IsSentriesModEnabled = false
ARCHERYPARAMS.IsMiningMachineEnabled = false

if GLOBAL.TheNet:GetIsClient() then
  local ListOfServerMods = GLOBAL.TheNet:GetServerModNames()
  for k, v in pairs(ListOfServerMods) do
    if v == "workshop-488009136" or v == "Sentries Mod WIP" or v == "Sentries Mod Candidate" then
      ARCHERYPARAMS.IsSentriesModEnabled = true
    end
    if v == "workshop-516523980" or v == "Mining Machine WIP" or v == "Mining Machine Candidate" then
      ARCHERYPARAMS.IsMiningMachineEnabled = true
    end
  end
end

if GLOBAL.KnownModIndex then
  if GLOBAL.KnownModIndex:IsModEnabled("workshop-508739792") or GLOBAL.KnownModIndex:IsModEnabled("Sentries Mod WIP") or GLOBAL.KnownModIndex:IsModEnabled("Sentries Mod Candidate") then
    ARCHERYPARAMS.IsSentriesModEnabled = true
  end
  if GLOBAL.KnownModIndex:IsModEnabled("workshop-516523980") or GLOBAL.KnownModIndex:IsModEnabled("Mining Machine WIP") or GLOBAL.KnownModIndex:IsModEnabled("Mining Machine Candidate") then
    ARCHERYPARAMS.IsMiningMachineEnabled = true
  end
end

if ARCHERYPARAMS.IsSentriesModEnabled then
  print("----> Sentries Mod Is Enabled!")
end
if ARCHERYPARAMS.IsMiningMachineEnabled then
  print("----> Mining Machine Is Enabled!")
end

-------------------------------------------------------------------------------------------

STRINGS = GLOBAL.STRINGS
RECIPETABS = GLOBAL.RECIPETABS
Recipe = GLOBAL.Recipe
GIngredient = GLOBAL.Ingredient
TECH = GLOBAL.TECH

FRAMES = GLOBAL.FRAMES
ACTIONS = GLOBAL.ACTIONS
State = GLOBAL.State
EventHandler = GLOBAL.EventHandler
ActionHandler = GLOBAL.ActionHandler
TimeEvent = GLOBAL.TimeEvent
EQUIPSLOTS = GLOBAL.EQUIPSLOTS

GLOBAL.INVINFO = {}

if GLOBAL.FUELTYPE["ZUPALEX"] == nil then
  GLOBAL.FUELTYPE["ZUPALEX"] = "ZUPALEX"
end

function TryDoUntil(inst, conditionfn, interval, initial_delay, timeout, fn, ...)
  if conditionfn == nil then
    print("No condition fn specified in TryDoUntil!")
    return
  end

  if timeout <= 0 then
    print("TryDoUntil timed out")
    return
  end

  if initial_delay ~= nil then
    print("Initial delay: " .. tostring(initial_delay))
    inst:DoTaskInTime(initial_delay, TryDoUntil, conditionfn, interval, nil, timeout, fn, ...)
    return
  end

  print("TryDoUntil: time before timeout: " .. tostring(timeout))

  if conditionfn(inst, ...) then
    fn(inst, ...)
    return
  else
    inst:DoTaskInTime(interval, TryDoUntil, conditionfn, interval, nil, timeout-interval, fn, ...)
    return
  end
end

local curr_env = GLOBAL.getfenv(1)

------------------------------------- MOD SKINS UTILS ------------------------------------------------------------------------

GLOBAL.ARCHERYSKINS = {
  bow = {
    { skin = "z_bow_skin_leaf", displayname = "Leaf Bow" },
    { skin = "z_bow_skin_spike", displayname = "Spiky Bow" },
    { skin = "z_bow_skin_jungle", displayname = "Jungle Bow" },
  }
}

-- 泡椒Vincent: add clear function for Wendy Remake 2020 update
function GLOBAL.bow_clear_fn(inst, build_name)
  inst.AnimState:SetBuild("bow")
end

local sab = GLOBAL.loadfile("scripts/skin_account_binder.lua")
if type(sab) == "string" then
  print("ERROR while loading skin_account_binder.lua:" .. tostring(sab))
end
GLOBAL.setfenv(sab, curr_env)
sab()

for k, v in pairs(GLOBAL.ARCHERYSKINS) do
  if GLOBAL.PREFAB_SKINS[k] == nil then
    GLOBAL.PREFAB_SKINS[k] = {}
  end

  if GLOBAL.PREFAB_SKINS_IDS[k] == nil then
    GLOBAL.PREFAB_SKINS_IDS[k] = {}
  end

  for i, skin_info in ipairs(v) do
    table.insert(PrefabFiles, skin_info.skin)
    table.insert(GLOBAL.PREFAB_SKINS[k], skin_info.skin)
    GLOBAL.PREFAB_SKINS_IDS[k][skin_info.skin] = i
    STRINGS.SKIN_NAMES[skin_info.skin] = skin_info.displayname
  end
end

function GLOBAL.ARCHERYFUNCS.MakeSkinnableItem(inst)
  local origOnSave = inst.OnSave
  local origOnLoad = inst.OnLoad

  inst.OnSave = function(inst, data)
    if origOnSave then origOnSave(inst, data) end

    if inst._skinname then
      data._skinname = inst._skinname
    end
  end

  inst.OnLoad = function(inst, data)
    if origOnLoad then origOnLoad(inst, data) end

    if data and data._skinname then
      inst._skinname = data._skinname

      inst.AnimState:SetSkin(inst._skinname, inst._skinname)

      if inst.components and inst.components.inventoryitem then
        inst.components.inventoryitem:ChangeImageName(inst._skinname)
        inst.components.inventoryitem.atlasname = "images/inventoryimages/" .. inst._skinname .. ".xml"
      end
    end
  end
end

function GLOBAL.ARCHERYFUNCS.MakeSwappableSkin(inst)
  GLOBAL.ARCHERYFUNCS.MakeSkinnableItem(inst)

  if inst.components and inst.components.equippable then
    local orig_onequipfn = inst.components.equippable.onequipfn

    inst.components.equippable:SetOnEquip(function(inst, owner)
        orig_onequipfn(inst, owner)

        local skin_build = inst._skinname
        if skin_build ~= nil then
          -- print("This item has a skin!")
          owner:PushEvent("equipskinneditem", skin_build)
          -- owner.AnimState:OverrideItemSkinSymbol("swap_object", "swap_" .. skin_build, "swap_" .. skin_build, inst.GUID, "swap_" .. skin_build )
          owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_" .. skin_build, inst.GUID, skin_build )
        end
      end)

    local orig_onunequipfn = inst.components.equippable.onunequipfn

    inst.components.equippable:SetOnUnequip(function(inst, owner)
        orig_onunequipfn(inst, owner)

        local skin_build = inst._skinname
        if skin_build ~= nil then
          owner:PushEvent("unequipskinneditem", skin_build)
        end
      end)
  end
end

------------------------------------- LOAD MOD CONFIG ------------------------------------------------------------------------

local loadmodconfig = GLOBAL.loadfile("scripts/loadmodconfig")
GLOBAL.setfenv(loadmodconfig, curr_env)
loadmodconfig()

------------------------------------- QUIVER EXTRA EQUIP SLOT -------------------------------------------------------------------

GLOBAL.EQUIPSLOTS.QUIVER = "quiver"

AddGlobalClassPostConstruct("widgets/inventorybar", "Inv", function(self, owner)
    self.bg:SetScale(1.15+0.05,1,1)
    self.bgcover:SetScale(1.15+0.05,1,1)

    self:AddEquipSlot(GLOBAL.EQUIPSLOTS.QUIVER, "images/tabimages/quiver_slot.xml", "quiver_slot.tex",99)
  end
)

local function InvBarPostConstruct(self, owner)
  owner:DoTaskInTime(1, function()
      GLOBAL.INVINFO["ITEMSLOTSNUM"] = self.owner.replica.inventory:GetNumSlots()
      GLOBAL.INVINFO["EQUIPSLOTINFO"] = self.equipslotinfo
      GLOBAL.INVINFO["EQUIP"] = self.equip
      GLOBAL.INVINFO["INV"] = self.inv
    end
  )
end

AddClassPostConstruct("widgets/inventorybar", InvBarPostConstruct)

local function EquipSlotPostConstruct(self, equipslot, atlas, bgim, owner)
  GLOBAL.INVINFO["EQUIPSLOT_"..equipslot] = self
end

AddClassPostConstruct("widgets/equipslot", EquipSlotPostConstruct)

------------------------------------- BOW TARGETING -------------------------------------------------------------------

AddComponentPostInit("playercontroller", function(controller)
    local OrigGetAttackTarget = controller.GetAttackTarget

    controller.GetAttackTarget = function(self, force_attack, force_target, isretarget)
      local origTarget = OrigGetAttackTarget(self, force_attack, force_target, isretarget)

      local weap = self.inst.replica and self.inst.replica.inventory and self.inst.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)

      if weap and weap:HasTag("zupalexsrangedweapons") and origTarget ~= nil and (origTarget:HasTag("wall") or origTarget:HasTag("butterfly")) then
        local combat = self.inst.replica.combat
        if combat == nil then
          return
        end

        local x, y, z = self.inst.Transform:GetWorldPosition()
        local attackrange = combat:GetAttackRangeWithWeapon()
        local rad = self.directwalking and attackrange or attackrange + 6

        local newTarget = nil
        local nearby_ents = GLOBAL.TheSim:FindEntities(x, y, z, rad + 5, { "_combat" }, { "INLIMBO", "wall", "butterfly" })

        local potentialTargets = {}

        for i, v in ipairs(nearby_ents) do
          local dsq = self.inst:GetDistanceSqToInst(v)
          local dist_ = 	(dsq <= 0 and 0) or
          (v.Physics ~= nil and math.max(0, math.sqrt(dsq) - v.Physics:GetRadius())) or
          math.sqrt(dsq)

          table.insert(potentialTargets, {entity = v, dist = dist_})
        end

        table.sort(potentialTargets, function(l_, r_) return l_.dist < r_.dist end)

        local iter = 1

        while newTarget == nil and iter <= #potentialTargets do
          newTarget = OrigGetAttackTarget(self, force_attack, potentialTargets[iter].entity, isretarget)
          iter = iter+1
        end

        return newTarget
      else
        return origTarget
      end
    end
  end)

------------------------------------- RECIPES ------------------------------------------------------------------------------------

local recipemods = GLOBAL.loadfile("scripts/archery_recipe_mods")
GLOBAL.setfenv(recipemods, curr_env)
recipemods()

------------------------------------- NEW ACTIONS ---------------------------------------------------------------------------------

local actionsmods = GLOBAL.loadfile("scripts/archery_actions_mods")
GLOBAL.setfenv(actionsmods, curr_env)
actionsmods()

------------------------------------------------------ STATEGRAPHES --------------------------------------------------------------

local sgmods = GLOBAL.loadfile("scripts/archery_stategraph_mods")

if type(sgmods) == "string" then
  print("************* ERROR while loading scripts/archery_stategraph_mods: " .. tostring(sgmods))
end

GLOBAL.setfenv(sgmods, curr_env)
sgmods()

AddStategraphState("wilson", bow_attack)
AddStategraphState("wilson", crossbow_attack)
AddStategraphState("wilson", crossbow_arm)

AddStategraphState("wilson_client", bow_attack_client)
AddStategraphState("wilson_client", crossbow_attack_client)
AddStategraphState("wilson_client", crossbow_arm_client)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.CHANGEARROWTYPE, "doshortaction"))

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.TRANSFERCHARGETOPROJECTILE, "dolongaction"))

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.ARMCROSSBOW, function(inst, action)
      local weapon = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
      if weapon:HasTag("crossbow") then
        return "crossbow_arm"
      elseif weapon:HasTag("musket") then
        return "dolongaction"
      end
    end
  )
)

AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.CHANGEARROWTYPE, "doshortaction"))

AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.TRANSFERCHARGETOPROJECTILE, "dolongaction"))

AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.ARMCROSSBOW, function(inst, action)
      local weapon = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
      if weapon:HasTag("crossbow") then
        return "crossbow_arm"
      elseif weapon:HasTag("musket") then
        return "dolongaction"
      end
    end
  )
)

------------------------------------------------------ COMPONENT ACTIONS --------------------------------------------------------------

local function bow_attack_useitem(inst, doer, target, actions, right)
  if inst:HasTag("zupalexsrangedweapons") and inst:HasTag("electric") and inst:HasTag("discharged") and
  target.prefab == "lightning_rod"
  then
    if not GLOBAL.TheNet:GetIsClient()  and target.chargeleft then
      table.insert(actions, TRANSFERCHARGETOPROJECTILE)
    elseif GLOBAL.TheNet:GetIsClient() then
      SendModRPCToServer(MOD_RPC["Archery Mod"]["RequestLightningRodChargeNum"], target)
      if target:HasTag("z_ischarged") then
        table.insert(actions, TRANSFERCHARGETOPROJECTILE)
      end
    end
  elseif inst:HasTag("bullet") and target:HasTag("musket") then
    table.insert(actions, ARMCROSSBOW)
  end
end


local function bow_attack_inventory(inst, doer, actions, right)
  local quiver = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.QUIVER)
  local equiphand = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)

  if inst.replica.inventoryitem ~= nil then
--		local iteminquiver = quiver.replica.container:GetItemInSlot(1)
    if quiver ~= nil and
    inst:HasTag("zupalexsrangedweapons") and (inst:HasTag("arrow") or inst:HasTag("bolt")) and
    quiver:HasTag("zupalexsrangedweapons") and quiver.replica.container~= nil
    then
      table.insert(actions, CHANGEARROWTYPE)
    elseif inst:HasTag("zupalexsrangedweapons") and (inst:HasTag("crossbow") or inst:HasTag("musket")) and inst == equiphand then
      table.insert(actions, ARMCROSSBOW)
    end
  end
end

AddComponentAction("USEITEM", "zupalexsrangedweapons", bow_attack_useitem)
AddComponentAction("INVENTORY", "zupalexsrangedweapons", bow_attack_inventory)

------------------------------------------------------ RPCs --------------------------------------------------------------

AddModRPCHandler("Archery Mod", "RequestLightningRodChargeNum", function(player, inst)
    if inst.chargeleft and not inst:HasTag("z_ischarged") then
      inst:AddTag("z_ischarged")
    end
  end)

AddModRPCHandler("Archery Mod", "RequestProcessCarverCrafting", function(player, inst)
    if inst.components and inst.components.container and inst._worker then
      local feather = inst.components.container:GetItemInSlot(1)
      local body = inst.components.container:GetItemInSlot(2)
      local head = inst.components.container:GetItemInSlot(3)

      local results, feather_remain, body_remain, head_remain = GLOBAL.ARCHERYFUNCS.ProcessCarverRecipe(feather, body, head)

      if results ~= nil then inst._worker.components.inventory:GiveItem(results) end
      if feather_remain ~= nil then inst._worker.components.inventory:GiveItem(feather_remain) end
      if body_remain ~= nil then inst._worker.components.inventory:GiveItem(body_remain) end
      if head_remain ~= nil then inst._worker.components.inventory:GiveItem(head_remain) end
    end
  end)

--------------------------------------------WILSON SG ACTIONHANDLER FOR ATTACK OVERRIDE---------------------------------------------------------------------------

local SGWils = require "stategraphs/SGwilson"
local OriginalDestStateATTACK

for k1, v1 in pairs(SGWils.actionhandlers) do
  if SGWils.actionhandlers[k1]["action"]["id"] == "ATTACK" then
    OriginalDestStateATTACK = SGWils.actionhandlers[k1]["deststate"]
  end
end

local function NewDestStateATTACK(inst, action)
  inst.sg.mem.localchainattack = not action.forced or nil
  local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil

  if weapon and weapon:HasTag("zupalexsrangedweapons") and not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") and inst.components.combat ~= nil then
    return (weapon:HasTag("bow") and "bow")
    or ((weapon:HasTag("crossbow") or weapon:HasTag("musket")) and "crossbow")
  else
    return OriginalDestStateATTACK(inst, action)
  end
end

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.ATTACK, NewDestStateATTACK))
GLOBAL.package.loaded["stategraphs/SGwilson"] = nil

--------------------------------------------WILSON_CLIENT SG ACTIONHANDLER FOR ATTACK OVERRIDE---------------------------------------------------------------------------

local SGWilsClient = require "stategraphs/SGwilson_client"
local OriginalClientDestStateATTACK

for k1, v1 in pairs(SGWilsClient.actionhandlers) do
  if SGWilsClient.actionhandlers[k1]["action"]["id"] == "ATTACK" then
    OriginalClientDestStateATTACK = SGWilsClient.actionhandlers[k1]["deststate"]
  end
end

local function NewClientDestStateATTACK(inst, action)
  local weapon = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
  if weapon and weapon:HasTag("zupalexsrangedweapons") and not inst.sg:HasStateTag("attack") and inst.replica.combat then
    if inst.replica.combat then
      return (weapon:HasTag("bow") and "bow")
      or ((weapon:HasTag("crossbow") or weapon:HasTag("musket")) and "crossbow")
    end
  else
    return OriginalClientDestStateATTACK(inst, action)
  end
end

AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.ATTACK, NewClientDestStateATTACK))
GLOBAL.package.loaded["stategraphs/SGwilson_client"] = nil



-------------------------------- RANDOM TEST ----------------------

AddComponentPostInit("playeractionpicker", function(self)
    local GetLeftClickActionsOld = self.GetLeftClickActions

    self.GetLeftClickActions = function(self, position, target)
      local actions = GetLeftClickActionsOld(self, position, target)

      for i, v in ipairs(actions) do
        if v.action == GLOBAL.ACTIONS.EAT and v.invobject and (v.invobject:HasTag("badfood") or v.invobject:HasTag("spoiled")) then
          GLOBAL.table.remove(actions, i)
          break
        end
      end

      return actions
    end
  end)
