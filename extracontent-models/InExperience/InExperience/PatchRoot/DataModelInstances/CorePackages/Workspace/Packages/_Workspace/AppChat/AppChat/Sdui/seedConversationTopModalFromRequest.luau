local AppChat = script:FindFirstAncestor("AppChat")

local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)

local seedConversationTopModalSduiPayload = require(script.Parent.seedConversationTopModalSduiPayload)

local function seedConversationTopModalFromRequest(object, p: string)
	return object:andThen(function(p2)
		local responseBody = p2 and p2.responseBody

		local success, result = pcall(seedConversationTopModalSduiPayload, responseBody and responseBody.sdui, p)

		if not success then
			v:warning(`Error seeding conversationTopModal SDUI payload: {tostring(result)}`)
		end

		return p2
	end)
end

return seedConversationTopModalFromRequest
