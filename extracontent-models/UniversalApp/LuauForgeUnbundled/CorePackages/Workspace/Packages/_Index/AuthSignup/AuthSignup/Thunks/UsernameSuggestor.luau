local PostUsernameSuggestions = require("@game/CorePackages/Workspace/Packages/_Index/AuthSignup/AuthSignup/Requests/PostUsernameSuggestions")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Promise")

local statusCodes = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Http").StatusCodes

return {
	suggestUsernames = function(p2, p3, p4, p5)
		return PostUsernameSuggestions(p2, p3, p4):andThen(function(p6)
			if p6 == nil or p6.responseBody == nil then
				return Promise.reject()
			end

			local didGenerateNewUsername = p6.responseBody.didGenerateNewUsername
			local suggestedUsernames = p6.responseBody.suggestedUsernames
			return Promise.resolve({
				shouldUpdateState = true,
				didGenerate = didGenerateNewUsername,
				suggestions = suggestedUsernames
			})
		end, function(p6)
			local statusCode = p6.StatusCode

			return Promise.resolve({
				shouldUpdateState = statusCode ~= statusCodes.TOO_MANY_REQUESTS,
				didGenerate = false,
				suggestions = {}
			})
		end)
	end
}
