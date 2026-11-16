local parent = script:FindFirstAncestor("AppChat").Parent

local AppChatNetworking = require(parent.AppChatNetworking)

local Constants = require(script.Parent.Constants)
require(script.Parent.Types)

local function fetchSmartSuggestions(p: string)
	return AppChatNetworking.http.GetSuggestions(nil, p, Constants.SUGGESTION_TYPES, Constants.MAX_SUGGESTIONS):andThen(function(p2)
		local responseBody = p2 and p2.responseBody
		local v

		if not responseBody then
			return {}
		end

		v = responseBody.suggestions
		return v or {}
	end)
end

return fetchSmartSuggestions
