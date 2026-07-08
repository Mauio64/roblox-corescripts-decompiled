local CrossExperience = require(script.dependencies).CrossExperience

require(script.Common.Types)

return {
	Analytics = require(script.Analytics),
	Common = require(script.Common),
	Component = require(script.Component),
	CrossExperienceVoiceAnalytics = require(script.CrossExperienceVoiceAnalytics),
	CrossExperienceVoiceManager = require(script.CrossExperienceVoiceManager),
	Hooks = require(script.Hooks),
	installReducer = CrossExperience.installReducer,
	Utils = require(script.Utils),
	IXPManager = require(script.IXPManager)
}
