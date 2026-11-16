local parent = script:FindFirstAncestor("AppChat").Parent

local Cryo = require(parent.Cryo)
require(parent.AppChatNetworking)

local buildConversationMessageFromApi = require(script.Parent.buildConversationMessageFromApi)

local function buildValidMessages(p: string, p2)
	return Cryo.List.filterMap(p2, function(p3)
		if p3 and p3.id then
			return buildConversationMessageFromApi(p3, p)
		end

		return nil
	end)
end

return buildValidMessages
