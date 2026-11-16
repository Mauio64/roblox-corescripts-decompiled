local AuthSignup = script:FindFirstAncestor("AuthSignup")
local parent = AuthSignup.Parent

local PostUsernameSuggestions = require(AuthSignup.Requests.PostUsernameSuggestions)

local Promise = require(parent.Promise)

local Http = require(parent.Http)
local StatusCodes = Http.StatusCodes

return {
	suggestUsernames = function(p, p2, p3, _)
		return PostUsernameSuggestions(p, p2, p3):andThen(function(p4)
			if p4 == nil or p4.responseBody == nil then
				return Promise.reject()
			end

			local didGenerateNewUsername = p4.responseBody.didGenerateNewUsername
			local suggestedUsernames = p4.responseBody.suggestedUsernames
			return Promise.resolve({
				shouldUpdateState = true,
				didGenerate = didGenerateNewUsername,
				suggestions = suggestedUsernames
			})
		end, function(p4)
			local statusCode = p4.StatusCode

			return Promise.resolve({
				shouldUpdateState = statusCode ~= StatusCodes.TOO_MANY_REQUESTS,
				didGenerate = false,
				suggestions = {}
			})
		end)
	end
}
