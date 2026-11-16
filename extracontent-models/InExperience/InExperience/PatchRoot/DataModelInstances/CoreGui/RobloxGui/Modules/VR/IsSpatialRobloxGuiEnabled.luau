local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local CorePackages = game:GetService("CorePackages")

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)

if SharedExperimentDefinition.isInExperienceUIVREnabled then
	return true
end

local FFlagEnableSpatialRobloxGui = require(RobloxGui.Modules.Flags.FFlagEnableSpatialRobloxGui)

if not FFlagEnableSpatialRobloxGui then
	return false
end

local IxpServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper)
local IXPServiceWrapper = IxpServiceWrapper.IXPServiceWrapper
local FStringSpatialRobloxUIIXPLayerName = require(RobloxGui.Modules.Flags.FStringSpatialRobloxUIIXPLayerName)

local FStringSpatialRobloxUIIXPUITypeVariableName = require(RobloxGui.Modules.Flags.FStringSpatialRobloxUIIXPUITypeVariableName)

local FStringSpatialRobloxUIIXPSpatialUIVariantValue = require(RobloxGui.Modules.Flags.FStringSpatialRobloxUIIXPSpatialUIVariantValue)

return IXPServiceWrapper:GetLayerData(FStringSpatialRobloxUIIXPLayerName)[FStringSpatialRobloxUIIXPUITypeVariableName] == FStringSpatialRobloxUIIXPSpatialUIVariantValue
