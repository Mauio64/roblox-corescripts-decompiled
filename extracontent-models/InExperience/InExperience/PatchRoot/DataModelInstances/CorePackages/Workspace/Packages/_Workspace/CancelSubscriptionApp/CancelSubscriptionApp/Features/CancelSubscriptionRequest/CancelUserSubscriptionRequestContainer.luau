local parent = script:FindFirstAncestor("CancelSubscriptionApp").Parent
local React = require(parent.React)

local CancelUserSubscriptionRequestPrompt = require(script.Parent.CancelUserSubscriptionRequestPrompt)
local useCancelUserSubscriptionRequestPromptProps = require(script.Parent.useCancelUserSubscriptionRequestPromptProps)

local function CancelUserSubscriptionRequestContainer()
	local v = useCancelUserSubscriptionRequestPromptProps()
	return React.createElement(CancelUserSubscriptionRequestPrompt, v)
end

return CancelUserSubscriptionRequestContainer
