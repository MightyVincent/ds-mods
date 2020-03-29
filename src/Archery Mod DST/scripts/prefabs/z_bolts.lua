local assets=
{
	Asset("ATLAS", "images/inventoryimages/bolt.xml"),
    Asset("IMAGE", "images/inventoryimages/bolt.tex"),
	Asset("ATLAS", "images/inventoryimages/poisonbolt.xml"),
    Asset("IMAGE", "images/inventoryimages/poisonbolt.tex"),
	Asset("ATLAS", "images/inventoryimages/explosivebolt.xml"),
    Asset("IMAGE", "images/inventoryimages/explosivebolt.tex")
}

local prefabs = {
    "explode_small",
	"poisoncloud",
	"stuneffect"
}

------------------------------------------------------------ BOLTS ----------------------------------------------------------------

local function PoisonWearOff(target)
	 if target.components.combat then
		target.components.combat.damagemultiplier = nil
		
		if	target.components.locomotor then
			target.components.locomotor.externalspeedmultiplier = 1
		end
		
		if target:HasTag("poisoned") then
			target:RemoveTag("poisoned")
		end
		
		if TheWorld.ismastersim and target.poisoncloud ~= nil then
			target.poisoncloud:SetFollowTarget(nil)
			target.poisoncloud = nil
		end
		
		if target.poisonwearofftask then
			target.poisonwearofftask:Cancel()
			target.poisonwearofftask = nil
		end
	 end
end

local function onhitbolt_poison(inst, attacker, target)
--	print("I am shooting an Ice Arrow")
   
    if target.components.combat then
		if not target:HasTag("poisoned") then
			target:AddTag("poisoned")
			
			if TheWorld.ismastersim and target.components.burnable and target.poisoncloud == nil then
				local symboltofollow = nil
				local symboltofollow_x = 0
				local symboltofollow_y = 0
				local symboltofollow_z = 0.02
			
				symboltofollow = target.components.combat.hiteffectsymbol			
			
				if (symboltofollow == "marker" or symboltofollow == nil) and target.components.burnable then
					for k, v in pairs(target.components.burnable.fxdata) do
						if v.follow ~= nil then
							symboltofollow = v.follow
							symboltofollow_x = v.x
							symboltofollow_y = v.y - 30
							symboltofollow_z = v.z
						end
					end
				end
			
				if symboltofollow ~= nil and symboltofollow ~= "marker" then
					target.poisoncloud = SpawnPrefab("poisoncloud")
					target.poisoncloud.Transform:SetPosition(target:GetPosition():Get())
					target.poisoncloud:SetFollowTarget(target, symboltofollow, 0, 0, 1)	
					target:ListenForEvent("death", function()
													if target.poisoncloud ~= nil then
														target.poisoncloud:SetFollowTarget(nil)
														target.poisoncloud = nil
													end
												end
										)
				end
			end
		end
		
		target.components.combat.damagemultiplier = 0.6
		
		if target.components.health and not target.components.health:IsDead() then
			local timeouttick = 0
			
			if target.loosehealthovertime ~= nil then
				target.loosehealthovertime:Cancel()
				target.loosehealthovertime = nil
			end
			
			target.loosehealthovertime = target:DoPeriodicTask(1, function(target) 
																	target.components.health:DoDelta(-TUNING.BOWDMG*TUNING.CROSSBOWDMGMOD*TUNING.POISONBOLTDMGMOD/TUNING.POISONBOLTDURATION, true)
																	timeouttick = timeouttick+1
																	if timeouttick == TUNING.POISONBOLTDURATION then
																		target.loosehealthovertime:Cancel()
																		target.loosehealthovertime = nil
																	end
																end
															)															
		end
		
		if	target.components.locomotor then
			target.components.locomotor.externalspeedmultiplier = 0.5
		end
		
		if target.poisonwearofftask == nil then
			target.poisonwearofftask = target:DoPeriodicTask(10, PoisonWearOff)
		else
			target.poisonwearofftask:Cancel()
			target.poisonwearofftask = nil
			target.poisonwearofftask = target:DoPeriodicTask(10, PoisonWearOff)
		end
	end
end

local function onhitbolt_explosive(inst, attacker, target)
--	print("I am shooting an Explosive Bolt")
	local isPvPon = TheNet:GetPVPEnabled()
	
	local targposx, targposy, targposz
	if target ~= inst then
		targposx, targposy, targposz = target.Transform:GetWorldPosition()
	else
		targposx, targposy, targposz = inst.Transform:GetWorldPosition()
	end
	
	for i, v in ipairs(AllPlayers) do
        local distSq = v:GetDistanceSqToInst(inst)
        local k = math.max(0, math.min(1, distSq / 1600))
        local intensity = k * (k - 2) + 1 --easing.outQuad(k, 1, -1, 1)
        if intensity > 0 then
            v:ScreenFlash(intensity)
            v:ShakeCamera(CAMERASHAKE.FULL, .7, .02, intensity / 2)
        end
    end
	
	local ents = TheSim:FindEntities(targposx, targposy, targposz, TUNING.EXPLOSIVEBOLTRAD)
    for i, ent in ipairs(ents) do
		if (not isPvPon and not ent:HasTag("player")) or (isPvPon) then
			if ent ~= inst and attacker.components.combat:IsValidTarget(ent)
				then
					ent.components.combat:GetAttacked(attacker, TUNING.EXPLOSIVEBOLTDMG)
			elseif ent.components.workable ~= nil and ent.components.workable:CanBeWorked() then
					ent.components.workable:WorkedBy(inst, TUNING.EXPLOSIVEBOLTDMG)
			elseif ent == attacker then
					ent.components.combat:GetAttacked(attacker, TUNING.EXPLOSIVEBOLTDMG*0.2)
			elseif isPvPon and ent:HasTag("player") then
					ent.components.combat:GetAttacked(attacker, TUNING.EXPLOSIVEBOLTDMG*0.2)
			end
			
			ent:DoTaskInTime(0.5, function()
										if ent:IsValid() and not ent:IsInLimbo() then
											if ent.components.burnable and
											not ent.components.burnable:IsBurning() and
											not ent:HasTag("burnt")
											then
												ent.components.burnable:Ignite(true)
											end
										end
									end
							)
		end
    end

    SpawnPrefab("explode_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_explo")
	
	local rdmradius = TUNING.EXPLOSIVEBOLTRAD/4
	
	TheWorld:DoTaskInTime(0.15, function() SpawnPrefab("explode_small").Transform:SetPosition(targposx+math.random(-rdmradius, rdmradius), targposy+math.random(-rdmradius, rdmradius), targposz+math.random(-rdmradius, rdmradius)) end)
	target:DoTaskInTime(0.15, function() target.SoundEmitter:PlaySound("dontstarve/common/blackpowder_explo") end)
	TheWorld:DoTaskInTime(0.25, function() SpawnPrefab("explode_small").Transform:SetPosition(targposx+math.random(-rdmradius, rdmradius), targposy+math.random(-rdmradius, rdmradius), targposz+math.random(-rdmradius, rdmradius)) end)
	target:DoTaskInTime(0.25, function() target.SoundEmitter:PlaySound("dontstarve/common/blackpowder_explo") end)
	TheWorld:DoTaskInTime(0.4, function() SpawnPrefab("explode_small").Transform:SetPosition(targposx+math.random(-rdmradius, rdmradius), targposy+math.random(-rdmradius, rdmradius), targposz+math.random(-rdmradius, rdmradius)) end)
	target:DoTaskInTime(0.4, function() target.SoundEmitter:PlaySound("dontstarve/common/blackpowder_explo") end)
	
end

local function commonboltfn(boltanim, tags) 
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local netw = inst.entity:AddNetwork()
	
    MakeInventoryPhysics(inst)
     
    anim:SetBank("bolt")
    anim:SetBuild("crossbow")
    anim:PlayAnimation(boltanim)
 
	inst:AddTag("projectile") -- Tag is not doing anything by itself. I can be called by other stuffs though.
	inst:AddTag("bolt")

	inst:AddTag("zrw_valid")
	
	if tags ~= nil then
        for i, v in ipairs(tags) do
            inst:AddTag(v)
        end
    end

 --The following section is suitable for a DST compatible prefab.
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
----------------------------------------------------------------
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(0)
	inst:AddComponent("projectile")
	
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnPickupFn(ARCHERYFUNCS.onpickup)
	inst.components.inventoryitem:SetOnPutInInventoryFn(ARCHERYFUNCS.onputininventory)
	
	inst:AddComponent("zupalexsrangedweapons")
	inst.components.zupalexsrangedweapons:SetBaseDamage(TUNING.BOWDMG*TUNING.CROSSBOWDMGMOD)
	
	inst:AddComponent("stackable")
	
    inst:ListenForEvent("onthrown", ARCHERYFUNCS.onthrown_regular)
	
    return inst
end

local function shootbolt(inst)
    inst.AnimState:PlayAnimation("bolt_flight",true)
    inst:AddTag("NOCLICK")
    inst.persists = false
	
	local owner = inst.components.projectile.owner
	if owner and not owner:HasTag("player") then
		inst.components.projectile.owner = owner and owner.components.inventoryitem and owner.components.inventoryitem:GetGrandOwner() or owner
	end
end
	
local function regularboltfn()
	local inst = commonboltfn("bolt_idle", { "piercing", "sharp", "recoverable" })
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.Physics:SetCollisionCallback(ARCHERYFUNCS.oncollide)
	
	inst.components.projectile:SetSpeed(40)
	inst.components.projectile:SetOnThrownFn(shootbolt)
    inst.components.projectile:SetOnHitFn(ARCHERYFUNCS.onhitcommon)
    inst.components.projectile:SetOnMissFn(ARCHERYFUNCS.onmissarrow_regular)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
	
	inst.components.inventoryitem.imagename = "bolt"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/bolt.xml"
	
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	return inst
end

local function shootpoisonbolt(inst)
    inst.AnimState:PlayAnimation("poisonbolt_flight",true)
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function poisonboltfn()
	local inst = commonboltfn("poisonbolt_idle", { "poison" })
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.Physics:SetCollisionCallback(ARCHERYFUNCS.oncollide)
	
	inst.components.zupalexsrangedweapons:SetSpecificOnHitfn(onhitbolt_poison)
		
	inst.components.projectile:SetSpeed(40)
	inst.components.projectile:SetOnThrownFn(shootpoisonbolt)
    inst.components.projectile:SetOnHitFn(ARCHERYFUNCS.onhitcommon)
    inst.components.projectile:SetOnMissFn(ARCHERYFUNCS.onmissarrow_regular)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
	
	inst.components.inventoryitem.imagename = "poisonbolt"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/poisonbolt.xml"
	
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	return inst
end

local function onmiss_explosivebolt(inst, attacker, target)
	local shooter = inst.components.zupalexsrangedweapons.owner
	onhitbolt_explosive(inst, shooter, target)
	inst:Remove()
end

local function shootexplosivebolt(inst)
    inst.AnimState:PlayAnimation("explosivebolt_flight",true)
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function explosiveboltfn()
	local inst = commonboltfn("explosivebolt_idle", { "explosive" })
	
	inst.entity:AddSoundEmitter()
	
	if not TheWorld.ismastersim then
        return inst
    end
		
	inst.Physics:SetCollisionCallback(ARCHERYFUNCS.oncollide)
	
	inst.components.zupalexsrangedweapons:SetSpecificOnHitfn(onhitbolt_explosive)
			
	inst.components.projectile:SetSpeed(40)
	inst.components.projectile:SetOnThrownFn(shootexplosivebolt)
    inst.components.projectile:SetOnHitFn(ARCHERYFUNCS.onhitcommon)
    inst.components.projectile:SetOnMissFn(onmiss_explosivebolt)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
	
	inst.components.inventoryitem.imagename = "explosivebolt"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/explosivebolt.xml"
	
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	return inst
end


return  Prefab("common/inventory/bolt", regularboltfn, assets, prefabs),
		Prefab("common/inventory/poisonbolt", poisonboltfn, assets, prefabs),
		Prefab("common/inventory/explosivebolt", explosiveboltfn, assets, prefabs)