local module = require("@game/CorePackages/Workspace/Packages/_Workspace/InteractionFeedback/InteractionFeedback/InteractionFeedbackContext")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/InteractionFeedback/InteractionFeedback/useTriggerFeedback")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/InteractionFeedback/InteractionFeedback/FeedbackManagerInjectionContextProvider")
return {
	InteractionFeedbackContext = module,
	useTriggerFeedback = module2,
	withTriggerFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/InteractionFeedback/InteractionFeedback/withTriggerFeedback"),
	FeedbackManagerInjectionContextProvider = module3
}
