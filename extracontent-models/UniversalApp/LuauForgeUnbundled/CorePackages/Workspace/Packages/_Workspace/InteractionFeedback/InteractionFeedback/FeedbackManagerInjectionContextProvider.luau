local feedbackManagerInjectionContext = require("@game/CorePackages/Workspace/Packages/_Workspace/InteractionFeedback/UIBlox").Core.Control.FeedbackManagerInjectionContext
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InteractionFeedback/React")
local useTriggerFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/InteractionFeedback/InteractionFeedback/useTriggerFeedback")

local function FeedbackManagerInjectionContextProvider(p2)
	local v5 = useTriggerFeedback()
	return React.createElement(feedbackManagerInjectionContext.Provider, { value = v5 }, p2.children)
end

return FeedbackManagerInjectionContextProvider
