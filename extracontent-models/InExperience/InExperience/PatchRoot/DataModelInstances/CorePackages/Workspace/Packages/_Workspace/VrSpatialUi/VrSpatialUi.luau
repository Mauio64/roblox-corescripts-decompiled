local Constants = require(script.Constants)
local isInExperienceUIVREnabled = require(script.Parent.SharedExperimentDefinition).isInExperienceUIVREnabled

return {
	UIManager = require(script.UIManager),
	Constants = Constants,
	registerRoactPanel = require(script.registerRoactPanel),
	Panel3DInSpatialUI = if not isInExperienceUIVREnabled then nil else require(script.Panel3DInSpatialUI),
	VrEnvironmentScene = require(script.VrEnvironmentScene),
	["jest.config"] = script["jest.config"]
}
