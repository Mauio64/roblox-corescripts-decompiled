local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local isSpatial = AppCommonLib.isSpatial
local VrCommon = require(CorePackages.Workspace.Packages.VrCommon)
local VRHub = VrCommon.VRHub
local AppCommonLib2 = require(CorePackages.Workspace.Packages.AppCommonLib)
local Signal = AppCommonLib2.Signal
local Service = require(Chrome.Service)
local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local CommonIcon = require(Chrome.Integrations.CommonIcon)
local MappedSignal = ChromeUtils.MappedSignal
local initialAvailability

if isSpatial() then
	initialAvailability = Service.AvailabilitySignal.Available
else
	initialAvailability = Service.AvailabilitySignal.Unavailable
end

local v = Signal.new()
local isActivated = MappedSignal.new(v, function()
	return VRHub.SafetyBubble and VRHub.SafetyBubble.enabled
end)

if VRHub.SafetyBubble then
	VRHub.SafetyBubble.Toggled.Event:Connect(function()
		v:fire()
	end)
end

return (Service:register({
	initialAvailability = initialAvailability,
	id = "vr_safety_bubble",
	label = "CoreScripts.VRFTUX.Heading.SafetyBubble.Title",
	isActivated = isActivated,
	activated = function()
		VRHub:ToggleSafetyBubble()
		RbxAnalyticsService:ReportCounter("VR-BottomBar-Safety")
	end,
	components = {
		Icon = function()
			return CommonIcon(
				"rbxasset://textures/ui/MenuBar/icon_safety_off.png",
				"rbxasset://textures/ui/MenuBar/icon_safety_on.png",
				isActivated
			)
		end
	}
}))
