--Update inventoryitem_replica constructor if any more properties are added

local function onattackrange(self, attackrange)
    if self.inst.replica.inventoryitem ~= nil then
        self.inst.replica.inventoryitem:SetAttackRange(attackrange)
    end
end

local Zupalexsrangedweapons = Class(function(self, inst)
    self.inst = inst
	self.arrowbasedamage = 0
	self.owner = nil
	self.cooldowntime = nil
	self.fueledby = nil
	self.targx = nil
	self.targy = nil
	self.targz = nil
	
	self.baseproj = nil
	
	self.feather = nil
	self.body = nil
	self.head = nil
	
	self.basedmg = TUNING.BOWDMG
	
	self.lastattacktime = nil
	
	self.onarmedfn = nil
	
	self.specificOnHit = nil
	self.specificOnMiss = nil

    self.inst:AddTag("zupalexsrangedweapons")
end,
nil,
{
    attackrange = onattackrange,
})
	
function Zupalexsrangedweapons:OnRemoveFromEntity()
    if self.inst.replica.inventoryitem ~= nil then
        self.inst.replica.inventoryitem:SetAttackRange(-1)
    end
end

function Zupalexsrangedweapons:SetSpecificOnHitfn(specOnHitfn)
	self.specificOnHit = specOnHitfn
end

function Zupalexsrangedweapons:SetSpecificOnMissfn(specOnMissfn)
	self.specificOnMiss = specOnMissfn
end

function Zupalexsrangedweapons:SetOnArmedFn(onarmedfn)
	self.onarmedfn = onarmedfn
end

function Zupalexsrangedweapons:OnArmed(armer, projtouse)
	if self.onarmedfn then
		self.onarmedfn(self.inst, armer, projtouse)
	end
end

function Zupalexsrangedweapons:SetTargetPosition(x, y, z)
	self.targx = x
	self.targy = y
	self.targz = z	
end

function Zupalexsrangedweapons:GetTargetPosition()
	return self.targx, self.targy, self.targz
end


function Zupalexsrangedweapons:SetBaseDamage(dmg)
	self.basedmg = dmg
end

function Zupalexsrangedweapons:GetBasicAmmo()
	if self.baseproj ~= nil then	
		return self.baseproj
	elseif self.inst:HasTag("arrow") then
		return "arrow_" .. self.feather .. "_" .. self.body .. "_" .. self.head
	elseif self.inst:HasTag("bolt") then
		if self.inst:HasTag("poison") then
			return string.lower("poisonbolt")
		else
			return string.lower("bolt")
		end
	end
end

function Zupalexsrangedweapons:SetCooldownTime(cdtime)
	self.cooldowntime = cdtime
end

function Zupalexsrangedweapons:GetCooldownTime()
	return self.cooldowntime
end

function Zupalexsrangedweapons:GetMissChance()
	if self.inst:HasTag("arrow") then
		return TUNING.BOWMISSCHANCESMALL, TUNING.BOWMISSCHANCEBIG
	elseif self.inst:HasTag("bolt") then
		return TUNING.BOWMISSCHANCESMALL*TUNING.CROSSBOWACCMOD, TUNING.BOWMISSCHANCEBIG*TUNING.CROSSBOWACCMOD
	elseif self.inst:HasTag("bullet") then
		return TUNING.BOWMISSCHANCESMALL*TUNING.MUSKETACCMOD, TUNING.BOWMISSCHANCEBIG*TUNING.MUSKETACCMOD
	end
end

function Zupalexsrangedweapons:GetRecChance(hit)
	local RecChance

	if hit then
		RecChance = TUNING.HITREC
	else
		RecChance = TUNING.MISSREC
	end

	if self.inst:HasTag("arrow") then
		if self.inst:HasTag("golden") then
			return (RecChance*TUNING.GOLDARROWRECCHANCEMOD)
		elseif self.inst:HasTag("moonstone") then
			return 0.995
		else
			return RecChance
		end
	elseif self.inst:HasTag("bolt") then
		return RecChance
	end
end

function Zupalexsrangedweapons:SetFueledBy(itemprefab)
	self.fueledby = itemprefab
end

function Zupalexsrangedweapons:OnSave()

end

function Zupalexsrangedweapons:OnLoad(data)

end

return Zupalexsrangedweapons