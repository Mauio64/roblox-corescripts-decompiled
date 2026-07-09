local Parent = script:FindFirstAncestor("CancelSubscriptionApp").Parent
local React = require(Parent.React)
local CancelUserSubscriptionErrorPrompt = require(script.Parent.CancelUserSubscriptionErrorPrompt)
local useCancelUserSubscriptionErrorPromptProps = require(script.Parent.useCancelUserSubscriptionErrorPromptProps)

local function CancelUserSubscriptionErrorContainer() -- line: 8
	-- upvalues: useCancelUserSubscriptionErrorPromptProps (copy), React (copy), CancelUserSubscriptionErrorPrompt (copy)
	local v6 = useCancelUserSubscriptionErrorPromptProps()

	return React.createElement(CancelUserSubscriptionErrorPrompt, v6)
end

return CancelUserSubscriptionErrorContainer
