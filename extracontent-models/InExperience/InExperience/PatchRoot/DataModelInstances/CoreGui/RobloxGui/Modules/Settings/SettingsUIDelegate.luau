local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local CorePackages = game:GetService("CorePackages")
local Observable = require(CorePackages.Workspace.Packages.Observable)
local VrSpatialUi = require(CorePackages.Workspace.Packages.VrSpatialUi)
local PanelType = VrSpatialUi.Constants.PanelType
local UIManager = VrSpatialUi.UIManager
local Theme = require(script.Parent.Theme)
local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create

require(CorePackages.Packages.UIBlox)

local GetStyleTokens = require(RobloxGui.Modules.Chrome.ChromeShared.Utility.GetStyleTokens)
local ChatSelector = require(RobloxGui.Modules.ChatSelector)
local EngineFeature = game:GetEngineFeature("CoreScriptVersionEnabled")
local v12 = game:DefineFastInt("SpatialUIDarkenBackgroundTransparency", 0)
local v13 = game:DefineFastInt("SpatialUIVersionTextSizeScaled", 1400)
local InExperienceUIVRIXP = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).InExperienceUIVRIXP
local FFlagSpatialUIFixMenuPanelChatExclusive = require(RobloxGui.Modules.Settings.Flags.FFlagSpatialUIFixMenuPanelChatExclusive)
local v16 = game:DefineFastFlag("SpatialUIFixGameInviteChatExclusive", false)
local _ = {
	HUB_BAR_WIDTH = 800,
	ASPECT_RATIO = 1.3333333333333333
}
local _ = {
	BOTTOM_BUTTON_MAX_SIZE_IN_PIXEL = 233
}
local u19 = nil

local function setFieldWithBackup(t1: {[any]: any}, t2: {[any]: any}?, s1: string, p1) -- line: 44
	if t2 ~= nil then
		t2[s1] = t1[s1]
		t1[s1] = p1
	end
end
local function restoreFieldFromBackup(t3: {[any]: any}, t4: {[any]: any}?, s2: string) -- line: 57
	if t4 ~= nil then
		t3[s2] = t4[s2]
	end
end

local t5 = {}

t5.__index = t5

function t5.new(p2) -- line: 66
	-- upvalues: t5 (copy)
	local t6 = {
		_originalShieldConfig = nil,
		_backgroundUICorner = nil,
		_vrEnabled = false,
		_surfaceGuiEnabledConnection = nil,
		_topBarConnection = nil,
		_userGui = nil,
		_openVRMenuHandler = nil,
		_settingsHub = p2,
		_windowsVisibilityValues = {},
		_windowsDisconnectCallbacks = {},
		_originalVersionTextSizes = {}
	}

	setmetatable(t6, t5)

	return t6
end
function t5.enableVR(p3) -- line: 84
	-- upvalues: PanelType (copy), UIManager (copy), Observable (copy), Create (copy), Theme (copy), CorePackages (copy), RobloxGui (copy)
	local t7 = {
		panelType = PanelType.MoreMenu,
		screenGuiProps = {
			Name = "MoreMenu",
			ResetOnSpawn = false,
			DisplayOrder = -1,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		}
	}
	local v37 = UIManager.getInstance():createUI(t7)

	if v37 == nil then
		return
	end

	local panelObject = v37.panelObject
	local v39 = Observable.ObservableValue.new(p3._settingsHub.Visible)

	p3._surfaceGuiEnabledConnection = v39:connect(function() -- line: 100
		-- upvalues: panelObject (copy), v39 (copy)
		panelObject.Enabled = v39:get()
	end)
	p3:connectWindowsVisibility(v39)
	UIManager.getInstance():connectPanelVisibility(PanelType.MoreMenu, v39)
	p3._originalShieldConfig = {}

	local ClippingShield = p3._settingsHub.ClippingShield
	local _originalShieldConfig = p3._originalShieldConfig

	if _originalShieldConfig ~= nil then
		_originalShieldConfig.Parent = ClippingShield.Parent
		ClippingShield.Parent = panelObject
	end

	local ClippingShield2 = p3._settingsHub.ClippingShield
	local _originalShieldConfig2 = p3._originalShieldConfig
	local uDim2 = UDim2.new(1, 0, 1, 0)

	if _originalShieldConfig2 ~= nil then
		_originalShieldConfig2.Size = ClippingShield2.Size
		ClippingShield2.Size = uDim2
	end

	local ClippingShield3 = p3._settingsHub.ClippingShield
	local _originalShieldConfig3 = p3._originalShieldConfig
	local uDim2_2 = UDim2.new(0, 0, 0, 0)

	if _originalShieldConfig3 ~= nil then
		_originalShieldConfig3.Position = ClippingShield3.Position
		ClippingShield3.Position = uDim2_2
	end

	if p3._settingsHub.DarkenBackground then
		p3._backgroundUICorner = Create("UICorner")({
			CornerRadius = Theme.MenuContainerCornerRadius,
			Parent = p3._settingsHub.DarkenBackground
		})
	end

	p3._vrEnabled = true

	if p3._topBarConnection == nil then
		local VRHub = require(CorePackages.Workspace.Packages.VrCommon).VRHub
		local v49 = Observable.ObservableValue.new(VRHub.ShowTopBar)

		p3._topBarConnection = VRHub.ShowTopBarChanged.Event:connect(function() -- line: 121
			-- upvalues: v49 (copy), VRHub (copy)
			v49:set(VRHub.ShowTopBar)
		end)
		UIManager.getInstance():connectTopBarVisibility(v49)

		local Chrome = RobloxGui.Modules.Chrome
		local Service = require(Chrome.ChromeShared.Service)

		Service:onTriggerVRToggleButton():connect(function(p4) -- line: 128
			-- upvalues: VRHub (copy)
			VRHub:SetShowTopBar(p4)
		end)
		Service:connectTopBarVisibility(v49)
	end

	p3:setVersionTextSize()
end
function t5.isInputEventNeededBySettings(p5, p6, p7, p8) -- line: 136
	-- upvalues: RobloxGui (copy)
	if p5._vrEnabled then
		if p5._userGui == nil then
			p5._userGui = require(RobloxGui.Modules.VR.UserGui)
		end

		if p5._userGui:isInputNeededForOpenVRMenu(p8) then
			if p5._openVRMenuHandler == nil then
				p5._openVRMenuHandler = p5._userGui:getOpenVRMenuHandler()
			end

			p5._openVRMenuHandler(p6, p7, p8)

			return false
		end

		if p8.KeyCode == Enum.KeyCode.Thumbstick2 then
			return true
		end
	end

	return false
end
function t5.disableVR(p9) -- line: 157
	-- upvalues: UIManager (copy), PanelType (copy)
	if not p9._vrEnabled then
		return
	end

	local ClippingShield = p9._settingsHub.ClippingShield
	local _originalShieldConfig = p9._originalShieldConfig

	if _originalShieldConfig ~= nil then
		ClippingShield.Parent = _originalShieldConfig.Parent
	end

	local ClippingShield4 = p9._settingsHub.ClippingShield
	local _originalShieldConfig4 = p9._originalShieldConfig

	if _originalShieldConfig4 ~= nil then
		ClippingShield4.Size = _originalShieldConfig4.Size
	end

	local ClippingShield5 = p9._settingsHub.ClippingShield
	local _originalShieldConfig5 = p9._originalShieldConfig

	if _originalShieldConfig5 ~= nil then
		ClippingShield5.Position = _originalShieldConfig5.Position
	end

	p9._originalShieldConfig = nil

	if p9._backgroundUICorner then
		p9._backgroundUICorner.Parent = nil
		p9._backgroundUICorner = nil
	end

	if p9._surfaceGuiEnabledConnection ~= nil then
		p9._surfaceGuiEnabledConnection:disconnect()
	end

	p9._openVRMenuHandler = nil
	p9:disconnectWindowsVisibility()
	UIManager.getInstance():disconnectPanelVisibility(PanelType.MoreMenu)
	p9:restoreVersionTextSize()
	p9._vrEnabled = false
end
function t5.getAspectRatio(p10) -- line: 179
	-- upvalues: UIManager (copy), PanelType (copy)
	if p10._vrEnabled then
		local v64 = UIManager.getInstance():getPanelSizeInPixel(PanelType.MoreMenu)

		return v64.X / v64.Y
	end

	return 1.3333333333333333
end
function t5.getHubBarSize(p11) -- line: 188
	-- upvalues: Theme (copy), UIManager (copy), PanelType (copy)
	if p11._vrEnabled then
		local v66 = Theme.HubPadding()
		local n1 = 0

		if v66 and v66.PaddingLeft then
			n1 += v66.PaddingLeft.Offset
		end

		if v66 and v66.PaddingRight then
			n1 += v66.PaddingRight.Offset
		end

		return UIManager.getInstance():getPanelSizeInPixel(PanelType.MoreMenu).X - n1
	end

	return 800
end
function t5.getMenuContainerPositionOverride(p12) -- line: 205
	if p12._vrEnabled then
		return {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X
		}
	end

	return nil
end
function t5.getFullScreenSize(p13) -- line: 218
	-- upvalues: UIManager (copy), PanelType (copy), RobloxGui (copy)
	if p13._vrEnabled then
		return UIManager.getInstance():getPanelSizeInPixel(PanelType.MoreMenu).Y
	end

	return RobloxGui.AbsoluteSize.y
end
function t5.getDarkBackgroundTheme(p14) -- line: 227
	-- upvalues: u19 (ref), GetStyleTokens (copy), v12 (copy), Theme (copy)
	if p14._vrEnabled then
		if u19 == nil then
			u19 = GetStyleTokens()
		end

		return {
			Color = u19.Color.OverMedia.OverMedia_100.Color3,
			Transparency = math.min(math.max(v12, 0), 100) / 100
		}
	end

	return {
		Color = Theme.color("DarkenBackground"),
		Transparency = Theme.transparency("DarkenBackground")
	}
end
function t5.getBottomButtonSize(p15, p16) -- line: 243
	if p15._vrEnabled then
		return (math.min(p16, 233))
	end

	return p16
end
function t5.updatePanelVisibility(p17, p18) -- line: 251
	-- upvalues: InExperienceUIVRIXP (copy), FFlagSpatialUIFixMenuPanelChatExclusive (copy), ChatSelector (copy), PanelType (copy)
	for _, v76 in p17._windowsVisibilityValues do
		if v76 then
			if InExperienceUIVRIXP:isMovePanelToCenter() and FFlagSpatialUIFixMenuPanelChatExclusive then
				ChatSelector:HideTemp(PanelType.MoreMenu, true)
			end

			p18:set(true)

			return
		end
	end

	if InExperienceUIVRIXP:isMovePanelToCenter() and FFlagSpatialUIFixMenuPanelChatExclusive then
		ChatSelector:HideTemp(PanelType.MoreMenu, false)
	end

	p18:set(false)
end

local function v23(p19) -- line: 268
	-- upvalues: CorePackages (copy), InExperienceUIVRIXP (copy), v16 (copy), ChatSelector (copy)
	local connection = require(CorePackages.Workspace.Packages.GameInvite).GameInviteModalManager.ToggleGameInviteModalEvent.Event:Connect(function(p20) -- line: 271
		-- upvalues: p19 (copy), InExperienceUIVRIXP (copy), v16 (copy), ChatSelector (copy)
		p19("GameInvite", p20)

		if InExperienceUIVRIXP:isMovePanelToCenter() and v16 then
			if p20 then
				ChatSelector:HideTemp("SettingsMenu", true)

				return
			end

			ChatSelector:HideTemp("SettingsMenu", false)
		end
	end)

	return function() -- line: 283
		-- upvalues: connection (ref)
		if connection then
			connection:Disconnect()
			connection = nil
		end
	end
end
local function v24(p21) -- line: 291
	local GuiService = game:GetService("GuiService")
	local connection = GuiService.InspectPlayerFromUserIdWithCtxRequest:Connect(function() -- line: 294
		-- upvalues: p21 (copy)
		p21("InspectAndBuy", true)
	end)
	local connection2 = GuiService.CloseInspectMenuRequest:Connect(function() -- line: 297
		-- upvalues: p21 (copy)
		p21("InspectAndBuy", false)
	end)
	local connection3 = GuiService.InspectMenuEnabledChangedSignal:Connect(function(p22) -- line: 300
		-- upvalues: p21 (copy)
		if not p22 then
			p21("InspectAndBuy", false)
		end
	end)

	return function() -- line: 306
		-- upvalues: connection (ref), connection2 (ref), connection3 (ref)
		if connection then
			connection:Disconnect()
			connection = nil
		end

		if connection2 then
			connection2:Disconnect()
			connection2 = nil
		end

		if connection3 then
			connection3:Disconnect()
			connection3 = nil
		end
	end
end

function t5.connectWindowsVisibility(p23, p24) -- line: 322
	-- upvalues: v23 (copy), v24 (copy)
	for _, v87 in {
		function(p25) -- line: 328
			-- upvalues: p23 (copy)
			local u111 = p23._settingsHub.SettingsShowSignal:connect(function(p26) -- line: 329
				-- upvalues: p25 (copy)
				p25("SettingsHub", p26)
			end)

			return function() -- line: 333
				-- upvalues: u111 (ref)
				if u111 then
					u111:Disconnect()
					u111 = nil
				end
			end
		end,
		v23,
		v24
	} do
		local v88 = v87(function(s3: string, b1: boolean) -- line: 323
			-- upvalues: p23 (copy), p24 (copy)
			p23._windowsVisibilityValues[s3] = b1
			p23:updatePanelVisibility(p24)
		end)

		table.insert(p23._windowsDisconnectCallbacks, v88)
	end
end
function t5.disconnectWindowsVisibility(p27) -- line: 353
	for _, v91 in p27._windowsDisconnectCallbacks do
		v91()
	end

	p27._windowsDisconnectCallbacks = {}
	p27._windowsVisibilityValues = {}
end
function t5.isOpenCloseAnimationAllowed(p28) -- line: 361
	if p28._vrEnabled then
		return false
	end

	return true
end
function t5.getMenuContainerExtraSpace(p29) -- line: 369
	if p29._vrEnabled then
		local MenuContainerPadding = p29._settingsHub.MenuContainerPadding

		return MenuContainerPadding.PaddingTop.Offset + MenuContainerPadding.PaddingBottom.Offset
	end

	return 0
end

local function refreshVersionTextLabelSize(p30) -- line: 378
	-- upvalues: EngineFeature (copy)
	local uDim2 = UDim2.new(0.2, -6, 1, 0)

	p30.Size = if not EngineFeature then uDim2 else UDim2.new(0, p30.TextBounds.X + 6, 1, 0)
end

function t5.setVersionTextSize(p31) -- line: 384
	-- upvalues: Theme (copy), v13 (copy), EngineFeature (copy)
	for _, child in (p31._settingsHub.VersionContainer:GetChildren()) do
		if child:IsA("TextLabel") then
			p31._originalVersionTextSizes[child] = child.TextSize
			child.TextSize = Theme.textSize(v13 / 100)

			local uDim2 = UDim2.new(0.2, -6, 1, 0)

			child.Size = if not EngineFeature then uDim2 else UDim2.new(0, child.TextBounds.X + 6, 1, 0)
		end
	end
end
function t5.restoreVersionTextSize(p32) -- line: 395
	-- upvalues: EngineFeature (copy)
	for _, child in (p32._settingsHub.VersionContainer:GetChildren()) do
		if child:IsA("TextLabel") and p32._originalVersionTextSizes[child] then
			child.TextSize = p32._originalVersionTextSizes[child]

			local uDim2 = UDim2.new(0.2, -6, 1, 0)

			child.Size = if not EngineFeature then uDim2 else UDim2.new(0, child.TextBounds.X + 6, 1, 0)
			p32._originalVersionTextSizes[child] = nil
		end
	end

	p32._originalVersionTextSizes = {}
end

return t5
