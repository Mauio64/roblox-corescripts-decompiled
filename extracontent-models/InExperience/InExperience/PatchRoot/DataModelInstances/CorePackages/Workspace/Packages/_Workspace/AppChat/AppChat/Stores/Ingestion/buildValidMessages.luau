local Parent = script:FindFirstAncestor("AppChat").Parent
local Cryo = require(Parent.Cryo)

require(Parent.AppChatNetworking)

local buildConversationMessageFromApi = require(script.Parent.buildConversationMessageFromApi)

local function buildValidMessages(s1: string, t1: {[any]: any}) -- line: 17
	-- upvalues: Cryo (copy), buildConversationMessageFromApi (copy)
	return Cryo.List.filterMap(t1, function(p1) -- line: 18
		-- upvalues: buildConversationMessageFromApi (copy), s1 (copy)
		if p1 and p1.id then
			return buildConversationMessageFromApi(p1, s1)
		end

		return nil
	end)
end

return buildValidMessages
