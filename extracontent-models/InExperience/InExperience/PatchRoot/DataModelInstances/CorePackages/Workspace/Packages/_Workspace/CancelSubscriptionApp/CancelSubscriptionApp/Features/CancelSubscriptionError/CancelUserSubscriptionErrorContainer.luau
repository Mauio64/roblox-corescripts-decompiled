local parent = script:FindFirstAncestor("CancelSubscriptionApp").Parent
local React = require(parent.React)
local CancelUserSubscriptionErrorPrompt = require(script.Parent.CancelUserSubscriptionErrorPrompt)

local useCancelUserSubscriptionErrorPromptProps = require(script.Parent.useCancelUserSubscriptionErrorPromptProps)

local function CancelUserSubscriptionErrorContainer()
	local v = useCancelUserSubscriptionErrorPromptProps()
	return React.createElement(CancelUserSubscriptionErrorPrompt, v)
end

return CancelUserSubscriptionErrorContainer
