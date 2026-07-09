local AuthSignup = script:FindFirstAncestor("AuthSignup")
local AuthSignupParent = AuthSignup.Parent
local PostUsernameSuggestions = require(AuthSignup.Requests.PostUsernameSuggestions)
local Promise = require(AuthSignupParent.Promise)
local StatusCodes = require(AuthSignupParent.Http).StatusCodes

return {
	suggestUsernames = function(p1, p2, p3, _) -- line: 10
		-- upvalues: PostUsernameSuggestions (copy), Promise (copy), StatusCodes (copy)
		return PostUsernameSuggestions(p1, p2, p3):andThen(function(p5) -- line: 11
			-- upvalues: Promise (copy)
			if p5 == nil or p5.responseBody == nil then
				return Promise.reject()
			end

			local didGenerateNewUsername = p5.responseBody.didGenerateNewUsername
			local suggestedUsernames = p5.responseBody.suggestedUsernames

			return Promise.resolve({
				shouldUpdateState = true,
				didGenerate = didGenerateNewUsername,
				suggestions = suggestedUsernames
			})
		end, function(p6) -- line: 22
			-- upvalues: Promise (copy), StatusCodes (copy)
			local StatusCode = p6.StatusCode

			return Promise.resolve({
				didGenerate = false,
				shouldUpdateState = StatusCode ~= StatusCodes.TOO_MANY_REQUESTS,
				suggestions = {}
			})
		end)
	end
}
