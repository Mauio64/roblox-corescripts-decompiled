local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/SmartSuggestions/Constants")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/SmartSuggestions/Types")

local function fetchSmartSuggestions(p2)
	return AppChatNetworking.http.GetSuggestions(nil, p2, Constants.SUGGESTION_TYPES, Constants.MAX_SUGGESTIONS):andThen(function(p3)
		local responseBody = p3 and p3.responseBody
		local v5

		if not responseBody then
			v5 = {}
			return v5
		end

		v5 = responseBody.suggestions

		if v5 then
			return v5
		end

		return {}
	end)
end

return fetchSmartSuggestions
