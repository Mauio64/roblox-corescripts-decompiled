local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CoreGui = game:GetService("CoreGui")

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local isSpatial = AppCommonLib.isSpatial
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local VrCommon = require(CorePackages.Workspace.Packages.VrCommon)
local VRHub = VrCommon.VRHub
local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)
local AppCommonLib2 = require(CorePackages.Workspace.Packages.AppCommonLib)
local Signal = AppCommonLib2.Signal
local Service = require(Chrome.Service)
local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local CommonIcon = require(Chrome.Integrations.CommonIcon)
local MappedSignal = ChromeUtils.MappedSignal

local VrSpatialUi = require(CorePackages.Workspace.Packages.VrSpatialUi)
local UIManager = VrSpatialUi.UIManager
local initialAvailability

if isSpatial() then
	initialAvailability = Service.AvailabilitySignal.Available
else
	initialAvailability = Service.AvailabilitySignal.Unavailable
end

local v = Signal.new()
local isActivated = MappedSignal.new(v, function()
	return VRHub.ShowTopBar
end)

VRHub.ShowTopBarChanged.Event:Connect(function()
	v:fire()
end)

return (Service:register({
	initialAvailability = initialAvailability,
	id = "vr_toggle_button",
	label = "Feature.Catalog.Label.Filter.Hide",
	isActivated = isActivated,
	activated = function()
		if VRHub.ShowTopBar then
			UIManager.getInstance():prepareGuiToggleAnimationState()
			VRHub:SetShowTopBar(false)

			if SettingsHub:GetVisibility() then
				SettingsHub:ToggleVisibility()
			end
		else
			VRHub:SetShowTopBar(true)
		end

		RbxAnalyticsService:ReportCounter("VR-BottomBar-ToggleGui")
	end,
	components = {
		Icon = function()
			return CommonIcon(
				"rbxasset://textures/ui/MenuBar/icon_maximize.png",
				"rbxasset://textures/ui/MenuBar/icon_minimize.png",
				isActivated
			)
		end
	}
}))
