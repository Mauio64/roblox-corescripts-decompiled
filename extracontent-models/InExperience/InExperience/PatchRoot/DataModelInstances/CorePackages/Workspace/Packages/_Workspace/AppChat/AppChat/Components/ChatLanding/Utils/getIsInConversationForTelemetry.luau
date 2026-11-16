local AppChat = script:FindFirstAncestor("AppChat")

local EnumScreens = require(AppChat.EnumScreens)
local getCurrentRoute = require(script.Parent.getCurrentRoute)

local function getIsInConversationForTelemetry(p)
	while true do
		local v = p and p._dangerouslyGetParent and p._dangerouslyGetParent()

		if not v then
			break
		end

		p = v
	end

	local v

	if p then
		v = getCurrentRoute(p.state)
	end

	local isInConversationForTelemetry

	if v == nil then
		isInConversationForTelemetry = false
	else
		isInConversationForTelemetry = v.routeName == EnumScreens.ChatConversation
	end

	return isInConversationForTelemetry
end

return getIsInConversationForTelemetry
