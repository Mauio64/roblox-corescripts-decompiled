local InteractionFeedbackContext = require(script.InteractionFeedbackContext)
local useTriggerFeedback = require(script.useTriggerFeedback)
local FeedbackManagerInjectionContextProvider = require(script.FeedbackManagerInjectionContextProvider)
return {
	InteractionFeedbackContext = InteractionFeedbackContext,
	useTriggerFeedback = useTriggerFeedback,
	withTriggerFeedback = require(script.withTriggerFeedback),
	FeedbackManagerInjectionContextProvider = FeedbackManagerInjectionContextProvider,
	["jest.config"] = script["jest.config"]
}
