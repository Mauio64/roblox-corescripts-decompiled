local parent = script:FindFirstAncestor("CancelSubscriptionApp").Parent
local React = require(parent.React)

local CancelUserSubscriptionSuccessPrompt = require(script.Parent.CancelUserSubscriptionSuccessPrompt)
local useCancelUserSubscriptionSuccessPromptProps = require(script.Parent.useCancelUserSubscriptionSuccessPromptProps)

local function CancelUserSubscriptionSuccessContainer()
	local v = useCancelUserSubscriptionSuccessPromptProps()
	return React.createElement(CancelUserSubscriptionSuccessPrompt, v)
end

return CancelUserSubscriptionSuccessContainer
