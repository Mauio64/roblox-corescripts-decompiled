local parent = script:FindFirstAncestor("GraphQlShared").Parent
local Promise = require(parent.Promise)

return {
	SuccessfulRequest = function(responseBody)
		return function(_, _, _, _, _)
			return Promise.resolve({
				responseCode = 200,
				responseTimeMs = 480,
				isJSONValid = true,
				responseBody,
				responseBody = responseBody
			})
		end
	end
}
