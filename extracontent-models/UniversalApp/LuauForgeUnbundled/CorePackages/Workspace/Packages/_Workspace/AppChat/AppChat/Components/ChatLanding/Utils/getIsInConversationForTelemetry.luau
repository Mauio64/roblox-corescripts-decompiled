local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local getCurrentRoute = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/Utils/getCurrentRoute")

local function getIsInConversationForTelemetry(p2)
	while true do
		local v5 = p2 and p2._dangerouslyGetParent and p2._dangerouslyGetParent()

		if not v5 then
			break
		end

		p2 = v5
	end

	local v5 = if p2 then getCurrentRoute(p2.state) else nil
	local isInConversationForTelemetry = not (v5 == nil) and v5.routeName == EnumScreens.ChatConversation
	return isInConversationForTelemetry
end

return getIsInConversationForTelemetry
