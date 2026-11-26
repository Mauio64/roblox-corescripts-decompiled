local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("seedConversationTopModalFromRequest")

local seedConversationTopModalSduiPayload = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Sdui/seedConversationTopModalSduiPayload")

local function seedConversationTopModalFromRequest(object, p2)
	return object:andThen(function(p3)
		local responseBody = p3 and p3.responseBody

		local success, result = pcall(seedConversationTopModalSduiPayload, responseBody and responseBody.sdui, p2)

		if not success then
			v5:warning(`Error seeding conversationTopModal SDUI payload: {tostring(result)}`)
		end

		return p3
	end)
end

return seedConversationTopModalFromRequest
