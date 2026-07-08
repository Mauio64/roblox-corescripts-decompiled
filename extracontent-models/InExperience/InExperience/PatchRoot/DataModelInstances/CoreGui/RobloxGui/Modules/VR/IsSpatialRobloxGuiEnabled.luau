local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local CorePackages = game:GetService("CorePackages")

if require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled then
	return true
end

if not require(RobloxGui.Modules.Flags.FFlagEnableSpatialRobloxGui) then
	return false
end

local IXPServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper).IXPServiceWrapper
local FStringSpatialRobloxUIIXPLayerName = require(RobloxGui.Modules.Flags.FStringSpatialRobloxUIIXPLayerName)
local FStringSpatialRobloxUIIXPUITypeVariableName = require(RobloxGui.Modules.Flags.FStringSpatialRobloxUIIXPUITypeVariableName)

return require(RobloxGui.Modules.Flags.FStringSpatialRobloxUIIXPSpatialUIVariantValue) == IXPServiceWrapper:GetLayerData(FStringSpatialRobloxUIIXPLayerName)[FStringSpatialRobloxUIIXPUITypeVariableName]
