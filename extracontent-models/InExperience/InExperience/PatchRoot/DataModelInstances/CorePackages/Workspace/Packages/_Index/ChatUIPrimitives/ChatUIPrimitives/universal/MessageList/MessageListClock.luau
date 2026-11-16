local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)

local MessageClockContext = require(script.Parent.Parent.Adornments.MessageClockContext)
local useMessageClock = require(script.Parent.Parent.Adornments.useMessageClock)

local function MessageListClock(p)
	local v = React.useContext(MessageClockContext)
	local enabled = p.enabled and v == nil
	local v2 = useMessageClock({ enabled = enabled })
	local createElement = React.createElement
	local provider = MessageClockContext.Provider

	if v == nil then
		if not enabled then
			v2 = nil
		end
	else
		v2 = v
	end

	return createElement(provider, { value = v2 }, p.children)
end

return MessageListClock
