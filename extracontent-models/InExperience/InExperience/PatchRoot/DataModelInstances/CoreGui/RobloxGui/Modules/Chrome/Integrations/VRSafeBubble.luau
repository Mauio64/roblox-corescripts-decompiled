local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local isSpatial = require(CorePackages.Workspace.Packages.AppCommonLib).isSpatial
local VRHub = require(CorePackages.Workspace.Packages.VrCommon).VRHub
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local Service = require(Chrome.Service)
local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local CommonIcon = require(Chrome.Integrations.CommonIcon)
local MappedSignal = ChromeUtils.MappedSignal
local FFlagChromeActivatedMappedSignal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagChromeActivatedMappedSignal
local v12 = if not isSpatial() then Service.AvailabilitySignal.Unavailable else Service.AvailabilitySignal.Available
local v13 = Signal.new()
local v14 = MappedSignal.new(v13, function() -- line: 25
	-- upvalues: VRHub (copy)
	return VRHub.SafetyBubble and VRHub.SafetyBubble.enabled
end)

if VRHub.SafetyBubble then
	VRHub.SafetyBubble.Toggled.Event:Connect(function() -- line: 30
		-- upvalues: v13 (copy)
		v13:fire()
	end)
end

return (Service:register({
	id = "vr_safety_bubble",
	label = "CoreScripts.VRFTUX.Heading.SafetyBubble.Title",
	initialAvailability = v12,
	isActivated = not FFlagChromeActivatedMappedSignal and function() -- line: 41
		-- upvalues: v14 (copy)
		return v14:get()
	end or v14,
	activated = function() -- line: 44
		-- upvalues: VRHub (copy), RbxAnalyticsService (copy)
		VRHub:ToggleSafetyBubble()
		RbxAnalyticsService:ReportCounter("VR-BottomBar-Safety")
	end,
	components = {
		Icon = function() -- line: 49
			-- upvalues: CommonIcon (copy), v14 (copy)
			return CommonIcon("rbxasset://textures/ui/MenuBar/icon_safety_off.png", "rbxasset://textures/ui/MenuBar/icon_safety_on.png", v14)
		end
	}
}))
