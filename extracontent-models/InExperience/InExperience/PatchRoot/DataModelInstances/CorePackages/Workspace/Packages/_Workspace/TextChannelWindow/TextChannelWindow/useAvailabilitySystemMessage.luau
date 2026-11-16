local parent = script.Parent.Parent

local React = require(parent.React)
local useRobloxSystemMessage = require(script.Parent.useRobloxSystemMessage)
require(script.Parent.ChatAvailabilityContext)
local FFlagExpChatMemoizeSystemMessage = require(script.Parent.Flags.FFlagExpChatMemoizeSystemMessage)

local function useAvailabilitySystemMessage(p, p2)
	local v = useRobloxSystemMessage()

	local useEffect = React.useEffect
	local function fn()
		if p.messageKey then
			v.displayRobloxSystemMessage(p.messageKey, p.messageFallback or "")
		end

		return v.clearAvailabilityMessage
	end

	local v2

	if FFlagExpChatMemoizeSystemMessage then
		v2 = { v, p.messageKey, p.messageFallback, p2 }
	else
		v2 = { v, p.messageKey, p.messageFallback }
	end

	useEffect(fn, v2)
end

return useAvailabilitySystemMessage
