local Parent = script:FindFirstAncestor("CancelSubscriptionApp").Parent
local React = require(Parent.React)
local CancelUserSubscriptionSuccessPrompt = require(script.Parent.CancelUserSubscriptionSuccessPrompt)
local useCancelUserSubscriptionSuccessPromptProps = require(script.Parent.useCancelUserSubscriptionSuccessPromptProps)

local function CancelUserSubscriptionSuccessContainer() -- line: 8
	-- upvalues: useCancelUserSubscriptionSuccessPromptProps (copy), React (copy), CancelUserSubscriptionSuccessPrompt (copy)
	local v6 = useCancelUserSubscriptionSuccessPromptProps()

	return React.createElement(CancelUserSubscriptionSuccessPrompt, v6)
end

return CancelUserSubscriptionSuccessContainer
