local NAME = ...

local ACR = LibStub("AceConfigRegistry-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
local db

local defaults = {
	darkFrames = true,
	eliteFrame = true,
	classIconPortraits = true,
	customHealthMana = true,
	bottomRaidFrame = true,
	hideMacros = true,
	hideBinds = true,
}

local options = {
	type = "group",
	name = format("%s |cffADFF2Fv%s|r", NAME, GetAddOnMetadata(NAME, "Version")),
	args = {
		group1 = {
			type = "group", order = 1,
			name = "Action Bar",	
			inline = true,
			get = function(i) return db[i[#i]] end,
			set = function(i,v) db[i[#i]] = v end,
			args = {
				hideBinds = {
					type = "toggle",
					name = "Hide binds",
					desc = "Show/Hide binds on action bar",
				},
				hideMacros = {
					type = "toggle",
					name = "Hide macros",
					desc = "Show/Hide macros on action bar",
				},
			},
		},
		group2 = {
			type = "group", order = 1,
			name = "Frames",	
			inline = true,
			get = function(i) return db[i[#i]] end,
			set = function(i,v) db[i[#i]] = v end,
			args = {
				darkFrames = {
					type = "toggle",
					name = "Dark Frames",
					desc = "Enable/Disable darker frames",
				},
				eliteFrame = {
					type = "toggle",
					name = "Elite Frame",
					desc = "Enable/Disable elite frame",
				},
				classIconPortraits = {
					type = "toggle",
					name = "Class Icon Portraits",
					desc = "Enable/Disable class icon portraits",
				},
				bottomRaidFrame = {
					type = "toggle",
					name = "Bottom Raid Frame",
					desc = "Sets you to the bottom on raid frames",
				},
			},
		},
		group3 = {
			type = "group", order = 1,
			name = "Miscellaneous",	
			inline = true,
			get = function(i) return db[i[#i]] end,
			set = function(i,v) db[i[#i]] = v end,
			args = {
				customHealthMana = {
					type = "toggle",
					name = "Custom Health/Mana Text",
					desc = "Enable/Disable custom health/mana text",
				},
			},
		},
		reload = {
			type = "execute",
			name = "Reload UI",
			func = function() ReloadUI() end,
		},
	},
}

local f = CreateFrame("Frame")
local fRaid = CreateFrame("Frame")

function f:OnEvent(event, addon)
	if addon == NAME then
		if not XunaTweaksDB then
			XunaTweaksDB = CopyTable(defaults)
		end
		db = XunaTweaksDB
		
		ACR:RegisterOptionsTable(NAME, options)
		ACD:AddToBlizOptions(NAME, NAME)
		ACD:SetDefaultSize(NAME, 600, 400)


		---- DO MAGIC ----
		if db.eliteFrame then eliteFrame() end
		if db.darkFrames then darkFrames() end
		if db.classIconPortraits then classIconPortraits() end
		if db.customHealthMana then customHealthMana() end
		if db.bottomRaidFrame then bottomRaidFrame() end

		fixActionBar(db.hideMacros, db.hideBinds)
		MinimapZoomOut:Hide()
		MinimapZoomIn:Hide()
		--ToggleFramerate

		-- Set fonts
		setFonts()
	end
end

function fRaid:OnEvent(event, addon)
		if UnitInRaid("player") then
			for i=1,GetNumGroupMembers() do
				_,_,subgroup = GetRaidRosterInfo(i)
				_G["CompactRaidGroup"..subgroup.."Title"]:Hide()
			end
		else
			-- CompactPartyFrameTitle:Hide()
		end
end

f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", f.OnEvent)
fRaid:RegisterEvent("GROUP_ROSTER_UPDATE")
fRaid:RegisterEvent("RAID_ROSTER_UPDATE")
fRaid:SetScript("OnEvent", fRaid.OnEvent)

for i, v in pairs({"xt", "xuna"}) do
	_G["SLASH_XunaTweaks"..i] = "/"..v
end

SlashCmdList.XunaTweaks = function()
	ACD:Open(NAME)
end

---------------------------------------------
----------------- FUNCTIONS -----------------
---------------------------------------------

function setFonts()
	for _, font in pairs({
	    GameFontHighlight,
	    GameFontDisable,
	    GameFontHighlightMedium,
	    GameFontNormal,
	    FriendsFont_Normal,
	    
	}) do
	    font:SetFont('Fonts\\ARIALN.ttf', 14)
	    font:SetShadowOffset(1, -1)
	end

	TextStatusBarText:SetFont('Fonts\\ARIALN.ttf', 12, "OUTLINE")
	TextStatusBarText:SetShadowOffset(1, -1)

	for _, font in pairs({
	    GameFontDisableSmall,
	    GameFontHighlightSmall,
	    GameFontNormalSmall,
	    FriendsFont_Small,
	    GameFontHighlightExtraSmall,
	}) do
	    font:SetFont('Fonts\\ARIALN.ttf', 12)
	    font:SetShadowOffset(1, -1)
	end
end

function eliteFrame()
	local f=_G["PlayerFrame"]
	local t=f:CreateTexture(nil,"BORDER")
	--t:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Elite")
	t:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Rare-Elite");
	t:SetAllPoints(f)
	t:SetTexCoord(1,.09375,0,.78125)
	if db.darkFrames then
		t:SetVertexColor(.3, .3, .3)
	else
		t:SetVertexColor(1,1,1,1)
	end
end

function darkFrames()
	for i, v in pairs({PlayerFrameTexture, TargetFrameTextureFrameTexture, PetFrameTexture, PartyMemberFrame1Texture, PartyMemberFrame2Texture, PartyMemberFrame3Texture, PartyMemberFrame4Texture,
			PartyMemberFrame1PetFrameTexture, PartyMemberFrame2PetFrameTexture, PartyMemberFrame3PetFrameTexture, PartyMemberFrame4PetFrameTexture, FocusFrameTextureFrameTexture,
			TargetFrameToTTextureFrameTexture, FocusFrameToTTextureFrameTexture, BonusActionBarFrameTexture0, BonusActionBarFrameTexture1, BonusActionBarFrameTexture2, BonusActionBarFrameTexture3,
			BonusActionBarFrameTexture4, MainMenuBarTexture0, MainMenuBarTexture1, MainMenuBarTexture2, MainMenuBarTexture3, MainMenuMaxLevelBar0, MainMenuMaxLevelBar1, MainMenuMaxLevelBar2,
			MainMenuMaxLevelBar3, MinimapBorder, CastingBarFrame.Border, FocusFrameSpellBar.Border, TargetFrameSpellBar.Border, MiniMapTrackingButtonBorder, MiniMapLFGFrameBorder, MiniMapBattlefieldBorder,
			MiniMapMailBorder, MinimapBorderTop, MainMenuBarLeftEndCap, MainMenuBarRightEndCap
	}) do
		v:SetVertexColor(.3, .3, .3)
	end
end

function classIconPortraits()
	hooksecurefunc("UnitFramePortrait_Update",function(self)
		if self.portrait then
			if UnitIsPlayer(self.unit) then                         
				local t = CLASS_ICON_TCOORDS[select(2, UnitClass(self.unit))]
				if t then
					self.portrait:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
					self.portrait:SetTexCoord(unpack(t))
				end
			else
				self.portrait:SetTexCoord(0,1,0,1)
			end
		end
	end)
end

function customHealthMana()
	hooksecurefunc("TextStatusBar_UpdateTextStringWithValues", function()
        PlayerFrameHealthBar.TextString:SetText(AbbreviateLargeNumbers(UnitHealth("player"))..' - '..format("%.0f",(UnitHealth("player") / UnitHealthMax("player")) * 100)..'%')
        PlayerFrameManaBar.TextString:SetText(AbbreviateLargeNumbers(UnitPower("player"))..' - '..format("%.0f",(UnitPower("player") / UnitPowerMax("player")) * 100)..'%')
        
        TargetFrameHealthBar.TextString:SetText(AbbreviateLargeNumbers(UnitHealth("target"))..' - '..format("%.0f",(UnitHealth("target") / UnitHealthMax("target")) * 100)..'%')
        TargetFrameManaBar.TextString:SetText(AbbreviateLargeNumbers(UnitPower("target"))..' - '..format("%.0f",(UnitPower("target") / UnitPowerMax("target")) * 100)..'%')
        
        FocusFrameHealthBar.TextString:SetText(AbbreviateLargeNumbers(UnitHealth("focus"))..' - '..format("%.0f",(UnitHealth("focus") / UnitHealthMax("focus")) * 100)..'%')
        FocusFrameManaBar.TextString:SetText(AbbreviateLargeNumbers(UnitPower("focus"))..' - '..format("%.0f",(UnitPower("focus") / UnitPowerMax("focus")) * 100)..'%')
	end)
end

function bottomRaidFrame()
    CRFSort_Group = function(t1, t2)
    	if UnitIsUnit(t1,"player") then
    		return false
    	elseif UnitIsUnit(t2,"player") then
    		return true
    	else
    		return t1 < t2
    	end
   	end
    CompactRaidFrameContainer.flowSortFunc = CRFSort_Group;
end

function fixActionBar(macro, binds)
	-- remove cooldowns while CC'd
	hooksecurefunc('CooldownFrame_Set', function(self) if self.currentCooldownType == COOLDOWN_TYPE_LOSS_OF_CONTROL then self:SetCooldown(0,0) end end)

	-- font fix
	local Path, Height = NumberFontNormalSmall:GetFont();
	NumberFontNormalSmall:SetFont(Path, Height, 'OUTLINE');

	for i=1,12 do
		if macro then
			_G["ActionButton"..i.."Name"]:SetAlpha(0)
			_G["MultiBarBottomRightButton"..i.."Name"]:SetAlpha(0)
			_G["MultiBarBottomLeftButton"..i.."Name"]:SetAlpha(0)
			_G["MultiBarRightButton"..i.."Name"]:SetAlpha(0)
			_G["MultiBarLeftButton"..i.."Name"]:SetAlpha(0)
		end
		if binds then
			_G["ActionButton"..i.."HotKey"]:SetAlpha(0)
			_G["MultiBarBottomRightButton"..i.."HotKey"]:SetAlpha(0)
			_G["MultiBarBottomLeftButton"..i.."HotKey"]:SetAlpha(0)
			_G["MultiBarRightButton"..i.."HotKey"]:SetAlpha(0)
			_G["MultiBarLeftButton"..i.."HotKey"]:SetAlpha(0)
		end
	end
end