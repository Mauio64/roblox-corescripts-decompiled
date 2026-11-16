local module = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/Constants")
local isInExperienceUIVREnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/SharedExperimentDefinition").isInExperienceUIVREnabled

local v5 = {
	UIManager = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/UIManager"),
	Constants = module,
	registerRoactPanel = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/registerRoactPanel"),
	Panel3DInSpatialUI = 0,
	VrEnvironmentScene = 0
}
local v6 = if isInExperienceUIVREnabled then require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/Panel3DInSpatialUI") else nil
v5.Panel3DInSpatialUI = v6
v5.VrEnvironmentScene = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/VrEnvironmentScene")
return v5
