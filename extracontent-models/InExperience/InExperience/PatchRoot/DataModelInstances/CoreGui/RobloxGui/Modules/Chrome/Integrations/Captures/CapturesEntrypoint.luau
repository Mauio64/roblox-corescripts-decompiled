local Chrome = script:FindFirstAncestor("Chrome")

local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local StarterGui = game:GetService("StarterGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local CapturesApp = require(RobloxGui.Modules.Captures.CapturesApp)
local CapturesInExperience = require(CorePackages.Workspace.Packages.CapturesInExperience)
local CapturesPolicy = CapturesInExperience.CapturesPolicy
local Service = require(Chrome.Service)
local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local CommonIcon = require(Chrome.Integrations.CommonIcon)
local MappedSignal = ChromeUtils.MappedSignal
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls

local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local SideSheetPlacement = Chrome2.Enums.SideSheetPlacement

local Available = Service.AvailabilitySignal.Available
local initialAvailability

if StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.All) or StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Captures) then
	initialAvailability = Service.AvailabilitySignal.Available
else
	initialAvailability = Service.AvailabilitySignal.Unavailable
end

local isActivated = MappedSignal.new(CapturesApp.onIsActiveChanged, function()
	return CapturesApp.getIsActive()
end)

local v = Service:register({
	initialAvailability = initialAvailability,
	id = "camera_entrypoint",
	label = "Feature.SettingsHub.Label.Captures",
	sideSheetPlacement = SideSheetPlacement.BelowFold,
	activated = function(_)
		CapturesApp.onToggleActivationFromChrome()
	end,
	isActivated = isActivated,
	components = {
		Icon = function(_)
			return CommonIcon("icons/controls/cameraOff", "icons/controls/cameraOn", isActivated)
		end
	}
})

ChromeUtils.setCoreGuiAvailability(v, Enum.CoreGuiType.Captures)

if not FFlagEnableConsoleExpControls then
	return v
end

local v2 = CapturesPolicy.PolicyImplementation.read()
local v3

if v2 then
	v3 = CapturesPolicy.Mapper(v2).eligibleForCapturesFeature()
else
	v3 = false
end

if not v3 then
	v.availability:forceUnavailable()
end

return v
