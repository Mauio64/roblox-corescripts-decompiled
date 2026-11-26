local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")

local buildConversationMessageFromApi = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/Ingestion/buildConversationMessageFromApi")

local function buildValidMessages(p2, p3)
	return Cryo.List.filterMap(p3, function(p4)
		if p4 and p4.id then
			return buildConversationMessageFromApi(p4, p2)
		end

		return nil
	end)
end

return buildValidMessages
