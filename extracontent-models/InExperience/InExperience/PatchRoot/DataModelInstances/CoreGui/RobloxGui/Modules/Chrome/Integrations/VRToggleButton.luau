local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CoreGui = game:GetService("CoreGui")
local isSpatial = require(CorePackages.Workspace.Packages.AppCommonLib).isSpatial
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local VRHub = require(CorePackages.Workspace.Packages.VrCommon).VRHub
local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local Service = require(Chrome.Service)
local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local CommonIcon = require(Chrome.Integrations.CommonIcon)
local MappedSignal = ChromeUtils.MappedSignal
local FFlagChromeActivatedMappedSignal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagChromeActivatedMappedSignal
local UIManager = require(CorePackages.Workspace.Packages.VrSpatialUi).UIManager
local v16 = if not isSpatial() then Service.AvailabilitySignal.Unavailable else Service.AvailabilitySignal.Available
local v17 = Signal.new()
local v18 = MappedSignal.new(v17, function() -- line: 31
	-- upvalues: VRHub (copy)
	return VRHub.ShowTopBar
end)

VRHub.ShowTopBarChanged.Event:Connect(function() -- line: 35
	-- upvalues: v17 (copy)
	v17:fire()
end)

return (Service:register({
	id = "vr_toggle_button",
	label = "Feature.Catalog.Label.Filter.Hide",
	initialAvailability = v16,
	isActivated = not FFlagChromeActivatedMappedSignal and function() -- line: 45
		-- upvalues: v18 (copy)
		return v18:get()
	end or v18,
	activated = function() -- line: 48
		-- upvalues: VRHub (copy), UIManager (copy), SettingsHub (copy), RbxAnalyticsService (copy)
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
		Icon = function() -- line: 62
			-- upvalues: CommonIcon (copy), v18 (copy)
			return CommonIcon("rbxasset://textures/ui/MenuBar/icon_maximize.png", "rbxasset://textures/ui/MenuBar/icon_minimize.png", v18)
		end
	}
}))
