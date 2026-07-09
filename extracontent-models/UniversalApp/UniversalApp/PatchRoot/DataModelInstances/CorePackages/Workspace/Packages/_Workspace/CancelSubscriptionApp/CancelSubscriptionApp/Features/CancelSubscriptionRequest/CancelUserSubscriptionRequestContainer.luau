local Parent = script:FindFirstAncestor("CancelSubscriptionApp").Parent
local React = require(Parent.React)
local CancelUserSubscriptionRequestPrompt = require(script.Parent.CancelUserSubscriptionRequestPrompt)
local useCancelUserSubscriptionRequestPromptProps = require(script.Parent.useCancelUserSubscriptionRequestPromptProps)

local function CancelUserSubscriptionRequestContainer() -- line: 8
	-- upvalues: useCancelUserSubscriptionRequestPromptProps (copy), React (copy), CancelUserSubscriptionRequestPrompt (copy)
	local v6 = useCancelUserSubscriptionRequestPromptProps()

	return React.createElement(CancelUserSubscriptionRequestPrompt, v6)
end

return CancelUserSubscriptionRequestContainer
