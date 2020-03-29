local assets=
{
  Asset("ANIM", "anim/bow.zip"),
  Asset("ANIM", "anim/swap_quiver.zip"),


  Asset("ATLAS", "images/inventoryimages/quiver.xml"),
  Asset("IMAGE", "images/inventoryimages/quiver.tex"),

  Asset("ANIM", "anim/ui_quiver_1x1.zip")
}
local prefabs = {
}

-------------------------------------------------------------QUIVER --------------------------------------------------------

local quiverwidgetparams =
{
  widget =
  {
    slotpos = {Vector3(0, -5, 0)},
    animbank = "ui_quiver_1x1",
    animbuild = "ui_quiver_1x1",
    pos = Vector3(0, 0, 0)
  },
  issidewidget = false,
  type = "quiver",
}

function quiverwidgetparams.itemtestfn(container, item, slot)
  if item:HasTag("zupalexsrangedweapons") and (item:HasTag("arrow") or item:HasTag("bolt")) then 
    return true
  else
    return false
  end
end

local function OnQuiverGetItem(inst, data)
  local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
  if owner == nil then return end

  local equiphand = owner.components.inventory and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
  if equiphand == nil or not equiphand:HasTag("zupalexsrangedweapons") or not equiphand:HasTag("usequiverproj") or not data.item:HasTag("zupalexsrangedweapons") then
    return
  end

  equiphand.components.weapon:SetProjectile(data.item.prefab)		
end

local function CheckBodyEquip(owner, data)
  if data and data.eslot and data.eslot == EQUIPSLOTS.BODY then
    if data.item and data.item.AnimState:BuildHasSymbol("swap_body_tall") then
      local quiver = owner.components.inventory:Unequip(EQUIPSLOTS.QUIVER)
      owner.components.inventory:GiveItem(quiver)
    end
  end
end

local function OnEquipQuiver(inst, owner)
  local bodyequip = owner and owner.components and owner.components.inventory and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)

  if bodyequip then
    if bodyequip.AnimState:BuildHasSymbol("swap_body_tall") then
      local item = owner.components.inventory:Unequip(EQUIPSLOTS.BODY)
      if item ~= nil then
        owner.components.inventory:GiveItem(item)
      end
    end
  end

  inst:ListenForEvent("equip", CheckBodyEquip, owner)

  owner.AnimState:OverrideSymbol("swap_body_tall", "swap_quiver", "swap_body")

  if inst.components.container ~= nil then
    inst:DoTaskInTime(1, function(inst) 
        inst.components.container:Open(owner)
        inst:ListenForEvent("itemget", OnQuiverGetItem)
      end)
  end

  local equiphand = owner.components.inventory and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)

  if equiphand == nil or not equiphand:HasTag("zupalexsrangedweapons") or not equiphand:HasTag("usequiverproj") then
    return
  end

  local projinquiver = inst.components.container:GetItemInSlot(1)
  if projinquiver == nil or not projinquiver:HasTag("zupalexsrangedweapons") then
    return
  end

  equiphand.components.weapon:SetProjectile(projinquiver.prefab)	
end

local function OnUnequipQuiver(inst, owner)
  inst:RemoveEventCallback("equip", CheckBodyEquip, owner)

  local newequip = owner and owner.components and owner.components.inventory and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)

  if not newequip or (newequip and not newequip.AnimState:BuildHasSymbol("swap_body_tall")) then owner.AnimState:ClearOverrideSymbol("swap_body_tall") end
  if inst.components.container ~= nil then
    inst.components.container:Close(owner)
  end
end

local function SpecialQuiverWidgetFn(self, doer)
  if not TheNet:IsDedicated() then
    local hudscaleadjust = Profile:GetHUDSize()*2
    local qs_pos = INVINFO.EQUIPSLOT_quiver:GetWorldPosition()

    if doer and doer.HUD and doer.HUD.controls then		
      if doer.HUD.controls.containers[self.inst].QuiverHasAnchor == nil then
        doer.HUD.controls.containers[self.inst].QuiverHasAnchor = true

        doer.HUD.controls.containers[self.inst]:SetVAnchor(ANCHOR_BOTTOM)
        doer.HUD.controls.containers[self.inst]:SetHAnchor(ANCHOR_LEFT)
      end

      if doer.HUD.controls.containers[self.inst] then
        doer.HUD.controls.containers[self.inst]:UpdatePosition(qs_pos.x, (qs_pos.y+60+hudscaleadjust))	
      end
    end
  end
end

local function quiverfn()
  local inst = CreateEntity()
  local trans = inst.entity:AddTransform()
  local anim = inst.entity:AddAnimState()
  local netw = inst.entity:AddNetwork()

  MakeInventoryPhysics(inst)

  anim:SetBank("quiver")
  anim:SetBuild("swap_quiver")
  anim:PlayAnimation("anim")

  inst:AddTag("quiver")

  inst.entity:SetPristine()

  -------------------------------------------------------------------------------------

  if TheWorld.ismastersim then
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = true
    inst.components.inventoryitem.imagename = "quiver"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/quiver.xml"

    inst:AddComponent("container")
    inst.components.container.WidgetSetup = ARCHERYFUNCS.MyWidgetSetup
    inst.replica.container.WidgetSetup = ARCHERYFUNCS.MyWidgetSetup_replica

    -- inst:DoTaskInTime(0, function(inst) inst.components.container:WidgetSetup(inst.prefab, quiverwidgetparams) end)
    inst.components.container:WidgetSetup(inst.prefab, quiverwidgetparams)

    local origOpen = inst.components.container.Open
    inst.components.container.Open = function(self, doer)
      origOpen(self, doer)
      SpecialQuiverWidgetFn(self, doer)
    end

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.QUIVER
    inst.components.equippable:SetOnEquip( OnEquipQuiver )
    inst.components.equippable:SetOnUnequip( OnUnequipQuiver )

    inst:AddComponent("zupalexsrangedweapons")

    MakeHauntableLaunch(inst)
  end

  inst:DoTaskInTime(0, function(inst)
      inst.replica.container.WidgetSetup = ARCHERYFUNCS.MyWidgetSetup_replica
      inst.replica.container:WidgetSetup(inst.prefab, quiverwidgetparams)

      local origReplicaOpen = inst.replica.container.Open
      inst.replica.container.Open = function(self, doer)
        origReplicaOpen(self, doer)
        SpecialQuiverWidgetFn(self, doer)
      end
    end)

  return inst
end


return  Prefab("common/inventory/quiver", quiverfn, assets, prefabs)