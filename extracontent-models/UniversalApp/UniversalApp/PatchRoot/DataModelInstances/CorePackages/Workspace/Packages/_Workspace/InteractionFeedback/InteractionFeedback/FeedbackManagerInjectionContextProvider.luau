local Parent = script:FindFirstAncestor("InteractionFeedback").Parent
local FeedbackManagerInjectionContext = require(Parent.UIBlox).Core.Control.FeedbackManagerInjectionContext
local React = require(Parent.React)
local useTriggerFeedback = require(script.Parent.useTriggerFeedback)

local function FeedbackManagerInjectionContextProvider(p1) -- line: 7
	-- upvalues: useTriggerFeedback (copy), React (copy), FeedbackManagerInjectionContext (copy)
	local v7 = useTriggerFeedback()

	return React.createElement(FeedbackManagerInjectionContext.Provider, {
		value = v7
	}, p1.children)
end

return FeedbackManagerInjectionContextProvider
