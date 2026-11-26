local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQlShared/Promise")

return {
	SuccessfulRequest = function(p2)
		return function(p3, p4, p5, p6, p7)
			return Promise.resolve({
				responseCode = 200,
				responseTimeMs = 480,
				isJSONValid = true,
				p2,
				responseBody = p2
			})
		end
	end
}
