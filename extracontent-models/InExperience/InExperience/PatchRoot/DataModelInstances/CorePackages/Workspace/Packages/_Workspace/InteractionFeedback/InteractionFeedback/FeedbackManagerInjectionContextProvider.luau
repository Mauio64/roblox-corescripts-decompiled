local parent = script:FindFirstAncestor("InteractionFeedback").Parent
local UIBlox = require(parent.UIBlox)
local FeedbackManagerInjectionContext = UIBlox.Core.Control.FeedbackManagerInjectionContext
local React = require(parent.React)
local useTriggerFeedback = require(script.Parent.useTriggerFeedback)

local function FeedbackManagerInjectionContextProvider(p)
	local v = useTriggerFeedback()
	return React.createElement(FeedbackManagerInjectionContext.Provider, { value = v }, p.children)
end

return FeedbackManagerInjectionContextProvider
