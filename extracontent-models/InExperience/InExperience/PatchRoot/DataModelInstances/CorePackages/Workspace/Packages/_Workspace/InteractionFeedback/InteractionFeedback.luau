local InteractionFeedbackContext = require(script.InteractionFeedbackContext)
local useTriggerFeedback = require(script.useTriggerFeedback)
local FeedbackManagerInjectionContextProvider = require(script.FeedbackManagerInjectionContextProvider)
local withTriggerFeedback = require(script.withTriggerFeedback)

return {
	InteractionFeedbackContext = InteractionFeedbackContext,
	useTriggerFeedback = useTriggerFeedback,
	withTriggerFeedback = withTriggerFeedback,
	FeedbackManagerInjectionContextProvider = FeedbackManagerInjectionContextProvider,
	["jest.config"] = script["jest.config"]
}
