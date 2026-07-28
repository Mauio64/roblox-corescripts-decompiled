local Parent = script:FindFirstAncestor("AppChat").Parent
local AppChatNetworking = require(Parent.AppChatNetworking)
local Constants = require(script.Parent.Constants)

require(script.Parent.Types)

local function fetchSmartSuggestions(s1: string) -- line: 11
	-- upvalues: AppChatNetworking (copy), Constants (copy)
	return AppChatNetworking.http.GetSuggestions(nil, s1, Constants.SUGGESTION_TYPES, Constants.MAX_SUGGESTIONS):andThen(function(p1) -- line: 14
		local v7 = p1 and p1.responseBody
		local suggestions

		if v7 then
			suggestions = v7.suggestions

			if not suggestions then
				return {}
			end
		else
			suggestions = {}
		end

		return suggestions
	end)
end

return fetchSmartSuggestions
