local Constants = require(script.Constants)
local SharedExperimentDefinition = require(script.Parent.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled

local VrSpatialUi = {}

VrSpatialUi.UIManager = require(script.UIManager)
VrSpatialUi.Constants = Constants
VrSpatialUi.registerRoactPanel = require(script.registerRoactPanel)
local panel3DInSpatialUI

if isInExperienceUIVREnabled then
	panel3DInSpatialUI = require(script.Panel3DInSpatialUI)
end

VrSpatialUi.Panel3DInSpatialUI = panel3DInSpatialUI
VrSpatialUi.VrEnvironmentScene = require(script.VrEnvironmentScene)
VrSpatialUi["jest.config"] = script["jest.config"]
return VrSpatialUi
