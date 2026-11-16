local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local CorePackages = game:GetService("CorePackages")
local Observable = require(CorePackages.Workspace.Packages.Observable)
local VrSpatialUi = require(CorePackages.Workspace.Packages.VrSpatialUi)
local PanelType = VrSpatialUi.Constants.PanelType
local UIManager = VrSpatialUi.UIManager
local Theme = require(script.Parent.Theme)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create
require(CorePackages.Packages.UIBlox)
local GetStyleTokens = require(RobloxGui.Modules.Chrome.ChromeShared.Utility.GetStyleTokens)

local ChatSelector = require(RobloxGui.Modules.ChatSelector)

local engineFeature = game:GetEngineFeature("CoreScriptVersionEnabled")
local defineFastInt = game:DefineFastInt("SpatialUIDarkenBackgroundTransparency", 0)
local defineFastInt2 = game:DefineFastInt("SpatialUIVersionTextSizeScaled", 1400)

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local InExperienceUIVRIXP = SharedExperimentDefinition.InExperienceUIVRIXP
local FFlagSpatialUIFixMenuPanelChatExclusive = require(RobloxGui.Modules.Settings.Flags.FFlagSpatialUIFixMenuPanelChatExclusive)
local defineFastFlag = game:DefineFastFlag("SpatialUIFixGameInviteChatExclusive", false)

local _ = {
	HUB_BAR_WIDTH = 800,
	ASPECT_RATIO = 4 / 3
}

local _ = { BOTTOM_BUTTON_MAX_SIZE_IN_PIXEL = 233 }

local v = nil

local function setFieldWithBackup(clippingShield, originalShieldConfig, p: string, p2) -- 3 equivalent calls inferred from this helper
	if originalShieldConfig ~= nil then
		originalShieldConfig[p] = clippingShield[p]
		clippingShield[p] = p2
	end
end

local function restoreFieldFromBackup(clippingShield, originalShieldConfig, p: string) -- 3 equivalent calls inferred from this helper
	if originalShieldConfig ~= nil then
		clippingShield[p] = originalShieldConfig[p]
	end
end

local SettingsUIDelegate = {}
SettingsUIDelegate.__index = SettingsUIDelegate

function SettingsUIDelegate.new(settingsHub)
	local v2 = {
		_settingsHub = settingsHub,
		_originalShieldConfig = nil,
		_backgroundUICorner = nil,
		_vrEnabled = false,
		_surfaceGuiEnabledConnection = nil,
		_topBarConnection = nil,
		_userGui = nil,
		_windowsVisibilityValues = {},
		_windowsDisconnectCallbacks = {},
		_openVRMenuHandler = nil,
		_originalVersionTextSizes = {}
	}

	setmetatable(v2, SettingsUIDelegate)
	return v2
end

function SettingsUIDelegate:enableVR()
	local v2 = {
		panelType = PanelType.MoreMenu,
		screenGuiProps = {
			Name = "MoreMenu",
			ResetOnSpawn = false,
			DisplayOrder = -1,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		}
	}

	local ui = UIManager.getInstance():createUI(v2)

	if ui == nil then
		return
	end

	local panelObject = ui.panelObject
	local observableValue = Observable.ObservableValue.new(self._settingsHub.Visible)
	self._surfaceGuiEnabledConnection = observableValue:connect(function()
		panelObject.Enabled = observableValue:get()
	end)
	self:connectWindowsVisibility(observableValue)
	UIManager.getInstance():connectPanelVisibility(PanelType.MoreMenu, observableValue)
	self._originalShieldConfig = {}
	setFieldWithBackup(self._settingsHub.ClippingShield, self._originalShieldConfig, "Parent", panelObject) -- inferred equivalent call
	setFieldWithBackup(self._settingsHub.ClippingShield, self._originalShieldConfig, "Size", UDim2.new(1, 0, 1, 0)) -- inferred equivalent call
	setFieldWithBackup(self._settingsHub.ClippingShield, self._originalShieldConfig, "Position", UDim2.new(0, 0, 0, 0)) -- inferred equivalent call

	if self._settingsHub.DarkenBackground then
		self._backgroundUICorner = Create("UICorner")({
			CornerRadius = Theme.MenuContainerCornerRadius,
			Parent = self._settingsHub.DarkenBackground
		})
	end

	self._vrEnabled = true

	if self._topBarConnection == nil then
		local VrCommon = require(CorePackages.Workspace.Packages.VrCommon)
		local vrHub = VrCommon.VRHub
		local observableValue2 = Observable.ObservableValue.new(vrHub.ShowTopBar)
		self._topBarConnection = vrHub.ShowTopBarChanged.Event:connect(function()
			observableValue2:set(vrHub.ShowTopBar)
		end)
		UIManager.getInstance():connectTopBarVisibility(observableValue2)

		local chrome = RobloxGui.Modules.Chrome
		local Service = require(chrome.ChromeShared.Service)
		Service:onTriggerVRToggleButton():connect(function(p)
			vrHub:SetShowTopBar(p)
		end)
		Service:connectTopBarVisibility(observableValue2)
	end

	self:setVersionTextSize()
end

function SettingsUIDelegate:isInputEventNeededBySettings(p, p2, p3): boolean
	if not self._vrEnabled then
		return false
	end

	if self._userGui == nil then
		self._userGui = require(RobloxGui.Modules.VR.UserGui)
	end

	if self._userGui:isInputNeededForOpenVRMenu(p3) then
		if self._openVRMenuHandler == nil then
			self._openVRMenuHandler = self._userGui:getOpenVRMenuHandler()
		end

		self._openVRMenuHandler(p, p2, p3)
		return false
	elseif p3.KeyCode == Enum.KeyCode.Thumbstick2 then
		return true
	end

	return false
end

function SettingsUIDelegate:disableVR()
	if not self._vrEnabled then
		return
	end

	restoreFieldFromBackup(self._settingsHub.ClippingShield, self._originalShieldConfig, "Parent") -- inferred equivalent call
	restoreFieldFromBackup(self._settingsHub.ClippingShield, self._originalShieldConfig, "Size") -- inferred equivalent call
	restoreFieldFromBackup(self._settingsHub.ClippingShield, self._originalShieldConfig, "Position") -- inferred equivalent call
	self._originalShieldConfig = nil

	if self._backgroundUICorner then
		self._backgroundUICorner.Parent = nil
		self._backgroundUICorner = nil
	end

	if self._surfaceGuiEnabledConnection ~= nil then
		self._surfaceGuiEnabledConnection:disconnect()
	end

	self._openVRMenuHandler = nil
	self:disconnectWindowsVisibility()
	UIManager.getInstance():disconnectPanelVisibility(PanelType.MoreMenu)
	self:restoreVersionTextSize()
	self._vrEnabled = false
end

function SettingsUIDelegate:getAspectRatio()
	if not self._vrEnabled then
		return 4 / 3
	end

	local panelSizeInPixel = UIManager.getInstance():getPanelSizeInPixel(PanelType.MoreMenu)
	return panelSizeInPixel.X / panelSizeInPixel.Y
end

function SettingsUIDelegate:getHubBarSize()
	if not self._vrEnabled then
		return 800
	end

	local hubPadding = Theme.HubPadding()
	local total = 0

	if hubPadding and hubPadding.PaddingLeft then
		total += hubPadding.PaddingLeft.Offset
	end

	if hubPadding and hubPadding.PaddingRight then
		total += hubPadding.PaddingRight.Offset
	end

	return UIManager.getInstance():getPanelSizeInPixel(PanelType.MoreMenu).X - total
end

function SettingsUIDelegate:getMenuContainerPositionOverride()
	if self._vrEnabled then
		return {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X
		}
	end

	return nil
end

function SettingsUIDelegate:getFullScreenSize()
	if self._vrEnabled then
		return UIManager.getInstance():getPanelSizeInPixel(PanelType.MoreMenu).Y
	end

	return RobloxGui.AbsoluteSize.y
end

local function fn() -- 1 equivalent call inferred from this helper
	if v == nil then
		v = GetStyleTokens()
	end

	return v
end

function SettingsUIDelegate:getDarkBackgroundTheme()
	if not self._vrEnabled then
		return {
			Color = Theme.color("DarkenBackground"),
			Transparency = Theme.transparency("DarkenBackground")
		}
	end

	fn() -- inferred equivalent call
	return {
		Color = v.Color.OverMedia.OverMedia_100.Color3,
		Transparency = math.min(math.max(defineFastInt, 0), 100) / 100
	}
end

function SettingsUIDelegate:getBottomButtonSize(p)
	if self._vrEnabled then
		return (math.min(p, 233))
	end

	return p
end

function SettingsUIDelegate:updatePanelVisibility(object)
	for _, windowsVisibilityValue in self._windowsVisibilityValues do
		if windowsVisibilityValue then
			if InExperienceUIVRIXP:isMovePanelToCenter() and FFlagSpatialUIFixMenuPanelChatExclusive then
				ChatSelector:HideTemp(PanelType.MoreMenu, true)
			end

			object:set(true)
			return
		end
	end

	if InExperienceUIVRIXP:isMovePanelToCenter() and FFlagSpatialUIFixMenuPanelChatExclusive then
		ChatSelector:HideTemp(PanelType.MoreMenu, false)
	end

	object:set(false)
end

local function fn2(callback)
	local GameInvite = require(CorePackages.Workspace.Packages.GameInvite)
	local eventConnection = GameInvite.GameInviteModalManager.ToggleGameInviteModalEvent.Event:Connect(function(p)
		callback("GameInvite", p)

		if InExperienceUIVRIXP:isMovePanelToCenter() and defineFastFlag then
			if p then
				ChatSelector:HideTemp("SettingsMenu", true)
			else
				ChatSelector:HideTemp("SettingsMenu", false)
			end
		end
	end)

	return function()
		if eventConnection then
			eventConnection:Disconnect()
			eventConnection = nil
		end
	end
end

local function fn3(callback)
	local GuiService = game:GetService("GuiService")

	local inspectPlayerFromUserIdWithCtxRequestConnection = GuiService.InspectPlayerFromUserIdWithCtxRequest:Connect(function()
		callback("InspectAndBuy", true)
	end)
	local closeInspectMenuRequestConnection = GuiService.CloseInspectMenuRequest:Connect(function()
		callback("InspectAndBuy", false)
	end)
	local inspectMenuEnabledChangedSignalConnection = GuiService.InspectMenuEnabledChangedSignal:Connect(function(p)
		if not p then
			callback("InspectAndBuy", false)
		end
	end)

	return function()
		if inspectPlayerFromUserIdWithCtxRequestConnection then
			inspectPlayerFromUserIdWithCtxRequestConnection:Disconnect()
			inspectPlayerFromUserIdWithCtxRequestConnection = nil
		end

		if closeInspectMenuRequestConnection then
			closeInspectMenuRequestConnection:Disconnect()
			closeInspectMenuRequestConnection = nil
		end

		if inspectMenuEnabledChangedSignalConnection then
			inspectMenuEnabledChangedSignalConnection:Disconnect()
			inspectMenuEnabledChangedSignalConnection = nil
		end
	end
end

function SettingsUIDelegate:connectWindowsVisibility(p)
	local function fn4(p2: string, flag: boolean)
		self._windowsVisibilityValues[p2] = flag
		self:updatePanelVisibility(p)
	end

	for _, v2 in {
		function(callback)
			local settingsShowSignalConnection = self._settingsHub.SettingsShowSignal:connect(function(p2)
				callback("SettingsHub", p2)
			end)

			return function()
				if settingsShowSignalConnection then
					settingsShowSignalConnection:Disconnect()
					settingsShowSignalConnection = nil
				end
			end
		end,
		fn2,
		fn3
	} do
		local v3 = v2(fn4)
		table.insert(self._windowsDisconnectCallbacks, v3)
	end
end

function SettingsUIDelegate:disconnectWindowsVisibility()
	for _, windowsDisconnectCallback in self._windowsDisconnectCallbacks do
		windowsDisconnectCallback()
	end

	self._windowsDisconnectCallbacks = {}
	self._windowsVisibilityValues = {}
end

function SettingsUIDelegate:isOpenCloseAnimationAllowed(): boolean
	return not self._vrEnabled
end

function SettingsUIDelegate:getMenuContainerExtraSpace()
	if not self._vrEnabled then
		return 0
	end

	local menuContainerPadding = self._settingsHub.MenuContainerPadding
	return menuContainerPadding.PaddingTop.Offset + menuContainerPadding.PaddingBottom.Offset
end

local function refreshVersionTextLabelSize(label) -- 2 equivalent calls inferred from this helper
	local udim = UDim2.new(0.2, -6, 1, 0)

	if engineFeature then
		udim = UDim2.new(0, label.TextBounds.X + 6, 1, 0)
	end

	label.Size = udim
end

function SettingsUIDelegate:setVersionTextSize()
	local children = self._settingsHub.VersionContainer:GetChildren()

	for _, label in children do
		if not label:IsA("TextLabel") then
			continue
		end

		self._originalVersionTextSizes[label] = label.TextSize
		label.TextSize = Theme.textSize(defineFastInt2 / 100)
		refreshVersionTextLabelSize(label) -- inferred equivalent call
	end
end

function SettingsUIDelegate:restoreVersionTextSize()
	local children = self._settingsHub.VersionContainer:GetChildren()

	for _, label in children do
		if not (label:IsA("TextLabel") and self._originalVersionTextSizes[label]) then
			continue
		end

		label.TextSize = self._originalVersionTextSizes[label]
		refreshVersionTextLabelSize(label) -- inferred equivalent call
		self._originalVersionTextSizes[label] = nil
	end

	self._originalVersionTextSizes = {}
end

return SettingsUIDelegate
