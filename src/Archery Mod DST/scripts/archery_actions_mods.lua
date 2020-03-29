local global_facing

local global_havearrow			 
local global_targetisok          
local global_targetislimbo       
local global_havequiver          
local global_projtypeok          
local global_xbowisarmed         
local global_finishedarming   
local global_hasbullet   
local global_conditions_fulfilled

local global_isbowmagic
local global_magicweaponhasfuel

local global_weapname

allowedprojcrossbow = { "bolt", "poisonbolt", "explosivebolt" }

local function ClearUseArrowTags(inst)
	inst:RemoveTag("use_arrow")
	inst:RemoveTag("use_firearrow")
end

CHANGEARROWTYPE = GLOBAL.Action({priority = 5, rmb = true})
CHANGEARROWTYPE.str = "Change the ammo type to use"
CHANGEARROWTYPE.id = "CHANGEARROWTYPE"
CHANGEARROWTYPE.fn = function(act)
--	print("I entered the  ACTION CHANGEARROWTYPE!")

	local quiver = act.doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.QUIVER)
	local useditem = act.invobject
	local inventory = act.doer.components.inventory
					
--	print("Used object is : ", useditem.prefab)
	
	if useditem ~= nil and quiver.replica.container ~= nil and quiver:HasTag("zupalexsrangedweapons") then
--		print("I have a quiver and a used item")
		local slotitem = quiver.replica.container:GetItemInSlot(1)
			if useditem ~= slotitem then
				if slotitem == nil and
				quiver.replica.container:CanTakeItemInSlot(useditem, 1) and
				(quiver.replica.container:AcceptsStacks() or
				useditem.components.stackable == nil or
				not useditem.components.stackable:IsStack()) 
				then
--					print("there is nothing in the quiver and I put new arrows")
					local newactivearrow = GLOBAL.SpawnPrefab(string.lower(useditem.prefab))
					newactivearrow.components.stackable:SetStackSize(useditem.components.stackable.stacksize)
					quiver.components.container:GiveItem(newactivearrow, 1)
					useditem:Remove()
			elseif useditem ~= nil and
				slotitem ~= nil and
				quiver.replica.container:CanTakeItemInSlot(useditem, 1) and
				slotitem.prefab == useditem.prefab and
				slotitem.components.stackable ~= nil and
				quiver.replica.container:AcceptsStacks() 
				then	
--					print("there is something in the quiver and i add to the existing stack")
					local currentactivestack = useditem.components.stackable.stacksize
					local currentstackinquiver = slotitem.components.stackable.stacksize
					local stackoverflow = currentactivestack - slotitem.components.stackable:RoomLeft()
					
--					print("inv stack = ", currentactivestack, "     /     quiver stack = ", currentstackinquiver, "     /     overflow = ", stackoverflow)
					
					if stackoverflow <= 0 then
						slotitem.components.stackable:SetStackSize(currentactivestack + currentstackinquiver)
						useditem:Remove()
					else
						slotitem.components.stackable:SetStackSize(slotitem.components.stackable.maxsize)
						useditem.components.stackable:SetStackSize(stackoverflow)
--						print("quiver stack old = ", currentstackinquiver, "     /     quiver stack new = ", slotitem.components.stackable.stacksize, "     /     leftover = ", useditem.components.stackable.stacksize)
					end
			elseif useditem ~= nil and
				slotitem ~= nil and
				quiver.replica.container:CanTakeItemInSlot(useditem, slot) and
				not (slotitem.prefab == useditem.prefab and
					slotitem.components.stackable ~= nil and
					quiver.replica.container:AcceptsStacks()) and
				not (useditem.components.stackable ~= nil and
					useditem.components.stackable:IsStack() and
					not quiver.replica.container:AcceptsStacks()) 
				then
--					print("there is something in the quiver and i swap the two stacks")
					
					local newactivearrow = GLOBAL.SpawnPrefab(useditem.prefab)
					newactivearrow.components.stackable:SetStackSize(useditem.components.stackable.stacksize)
					
					local previnquiver = GLOBAL.SpawnPrefab(slotitem.prefab)
					previnquiver.components.stackable:SetStackSize(slotitem.components.stackable.stacksize)							
							
					slotitem:Remove()
					useditem:Remove()
					quiver.components.container:GiveItem(newactivearrow, 1)	
					inventory:GiveItem(previnquiver)
			end
		end
	end
	
	return true
end

AddAction(CHANGEARROWTYPE)

ARMCROSSBOW = GLOBAL.Action(	{priority = 5, rmb = true})
ARMCROSSBOW.strfn = function(act)
	if act.invobject:HasTag("crossbow") then
		return "XBOW"
	elseif act.invobject:HasTag("musket") or act.invobject:HasTag("bullet") then
		return "MUSKET"
	end
end
ARMCROSSBOW.id = "ARMCROSSBOW"
ARMCROSSBOW.fn = function(act)
--	print("I entered the  ACTION ARMCROSSBOW!")
	local invobj = act.invobject
	local target = act.target
	local inventory = act.doer.components.inventory
	
	if invobj.components.zupalexsrangedweapons ~= nil and 
		(invobj:HasTag("crossbow") or 
		(invobj:HasTag("musket") and inventory and (inventory:Has("musket_bullet", 1) or inventory:Has("musket_silverbullet", 1)))) then
			if not invobj:HasTag("readytoshoot") then
				invobj.components.zupalexsrangedweapons:OnArmed(act.doer)
			end
	end
	
	if target and invobj and invobj.components.zupalexsrangedweapons and target.components.zupalexsrangedweapons and invobj:HasTag("bullet") and target:HasTag("musket") then
		if not target:HasTag("readytoshoot") then
			target.components.zupalexsrangedweapons:OnArmed(act.doer, invobj.prefab)
		end
	end

	return true
end

AddAction(ARMCROSSBOW)

TRANSFERCHARGETOPROJECTILE = GLOBAL.Action({priority = 6})
TRANSFERCHARGETOPROJECTILE.str = "Recharge one projectile"
TRANSFERCHARGETOPROJECTILE.id = "TRANSFERCHARGETOPROJECTILE"
TRANSFERCHARGETOPROJECTILE.fn = function(act)
	local target = act.target
	local useditem = act.invobject
	local inventory = act.doer.components.inventory
	
	if target.chargeleft then
		if target.zchargeleft == nil then
			target.zchargeleft = GLOBAL.TUNING.LRCHARGENUM
		end
		
		target.zchargeleft = target.zchargeleft - 1

		if target.zchargeleft <= 0 then
			target.AnimState:ClearBloomEffectHandle()
			target.charged = false
			target.chargeleft = nil
			target.zchargeleft = nil
			target.Light:Enable(false)
			if target.zaptask then
				target.zaptask:Cancel()
				target.zaptask = nil
			end
			if target:HasTag("z_ischarged") then
				target:RemoveTag("z_ischarged")
			end
		end
	end
		
	local currentstack = useditem.components.stackable.stacksize
	
	local newproj = GLOBAL.SpawnPrefab("arrow_" .. useditem.components.zupalexsrangedweapons.feather .. "_" .. useditem.components.zupalexsrangedweapons.body .. "_horn")
	
	if currentstack > 1 then
		useditem.components.stackable:SetStackSize(currentstack - 1)
	else
		useditem:Remove()
	end
	
	inventory:GiveItem(newproj)
	
	return true
end

AddAction(TRANSFERCHARGETOPROJECTILE)


GLOBAL.STRINGS.ACTIONS["ARMCROSSBOW"] = {
	XBOW = "Arm the Crossbow",
	MUSKET = "Reload the Musket",
}