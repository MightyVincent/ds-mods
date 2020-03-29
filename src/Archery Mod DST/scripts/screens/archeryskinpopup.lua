local Screen = require "widgets/screen"
local Button = require "widgets/button"
local ImageButton = require "widgets/imagebutton"
local Text = require "widgets/text"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local Menu = require "widgets/menu"
local UIAnim = require "widgets/uianim"

local SCREEN_OFFSET = -.22 * RESOLUTION_X

local ArcherySkinPopUp = Class(Screen, function(self, owner, skin)
    Screen._ctor(self, "ArcherySkinPopUp")

    self.owner = owner
	print("ArcherySkinPopUp contructor:")
	print(" ===> Owner = " .. tostring(owner))
	
    self.root = self:AddChild(Widget("ROOT"))
    self.root:SetVAnchor(ANCHOR_MIDDLE)
    self.root:SetHAnchor(ANCHOR_MIDDLE)
    self.root:SetPosition(0,45,0)
    self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)

	self.subroot = self.root:AddChild(Widget("fixed_root"))

    -- Will display the skin obtained
    local skin_display_scale = 0.8
    self.skin_display = self.subroot:AddChild(UIAnim())
    self.skin_display:GetAnimState():SetBuild("archery_skin_display")
    self.skin_display:GetAnimState():SetBank("archery_skin_display")
    self.skin_display:SetScale(skin_display_scale)

    local title_height = 152
    --title 
    self.title = self.root:AddChild(Text(UIFONT, 42))
    self.title:SetPosition(0, title_height - 15, 0)
    self.title:SetString("You received the following item for the Archery Mod")
    self.title:SetColour(1,1,1,1)
	self.title:Hide()
	
	-- banner
    self.banner = self.root:AddChild(Image("images/giftpopup.xml", "banner.tex"))
    self.banner:SetPosition(0, -200, 0)
    self.banner:SetScale(0.8)
    self.name = self.banner:AddChild(Text(UIFONT, 55))
    self.name:SetHAlign(ANCHOR_MIDDLE)
    self.name:SetPosition(0, -10, 0)
    self.name:SetColour(1, 1, 1, 1)

    self.banner:Hide()  

    self.anims = self.openanims
	self.skin = skin
	print(" ===> Skin = " .. tostring(skin))
    self:RevealItem()

    TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/Together_HUD/player_receives_gift_animation_spin")

    TheCamera:PushScreenHOffset(self, SCREEN_OFFSET)
end)

function ArcherySkinPopUp:AddButtons()
	self.show_menu = true
	
	if not TheInput:ControllerAttached() then
		print("Adding the close button")
		local button_w = 200
		local space_between = 40
		local spacing = button_w + space_between
		local buttons = {{text = "Close", cb = function() self:OnClose() end}}
		self.menu = self.root:AddChild(Menu(buttons, spacing, true))
		self.menu:SetPosition(25, -290, 0)
		self.menu:SetScale(0.8)
		self.menu:Show()
		self.menu:SetFocus()

		self.default_focus = self.menu
	end
end

function ArcherySkinPopUp:OnClose()
	print("Clicked on the Close button")
    TheFrontEnd:GetSound():KillSound("gift_idle")
    TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/Together_HUD/player_receives_gift_animation_skinout")
    self.skin_display:GetAnimState():PlayAnimation("zoomout")
    if self.menu then
		self.menu:Kill()
	end
	self.show_menu = false
	
	if TheWorld.ismastersim and self.owner and self.owner.components then
		if self.owner.components.playercontroller ~= nil then
			self.owner.components.playercontroller:EnableMapControls(true)
			self.owner.components.playercontroller:Enable(true)
		end
		self.owner.components.inventory:Show()
		self.owner:ShowActions(true)
	else
		SendModRPCToServer(MOD_RPC["Archery Mod"]["GiveBackPlayerControl"])
	end
end

function ArcherySkinPopUp:OnUpdate(dt)
	if self.skin_display:GetAnimState():IsCurrentAnimation("zoomout") and self.skin_display:GetAnimState():AnimDone() then
        TheFrontEnd:PopScreen(self)
        -- if not TheWorld.ismastersim then
            -- SendRPCToServer(RPC.DoneOpenGift)
        -- elseif self.owner.components.giftreceiver ~= nil then
            -- self.owner.components.giftreceiver:OnStopOpenGift()
        -- end
    end
end

function ArcherySkinPopUp:OnControl(control, down)
    if ArcherySkinPopUp._base.OnControl(self, control, down) then return true end

    if TheInput:ControllerAttached() and self.show_menu then 
    	if not down and control == CONTROL_CANCEL then
    		self:OnClose()
			return true
		end
    end
end

function ArcherySkinPopUp:RevealItem()
    local skin = self.skin
    if skin == nil then
        return
    end

	print("Attempt to override SWAP_ICON with " .. "swap_" .. skin .. " from bank " .. skin)
    self.skin_display:GetAnimState():OverrideSkinSymbol("SWAP_ICON", skin, "swap_" .. skin)
	print("symbol override done")

    self.skin_display:GetAnimState():PlayAnimation("zoomin")
	print("Start playing zoomin")
		
    TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/Together_HUD/player_receives_gift_animation_spin")

    self.open_box = true
    self.skin_display:GetAnimState():PushAnimation("idle")
	print("Pushed idle")

    self.inst:DoTaskInTime(27 * FRAMES, function()
		self.title:Show()
		self.banner:Show()
        self:AddButtons()
    end)

    local name_string = STRINGS.SKIN_NAMES[skin] or skin
    self.name:SetTruncatedString(name_string, 500, 35, true)

    self.name:SetColour(GetColorForItem(skin))
end

return ArcherySkinPopUp