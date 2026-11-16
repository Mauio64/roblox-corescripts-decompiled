local parent = script.Parent.Parent
local API_URL = require(parent.API_URL)

return function(p)
	return p.roduxNetworking.GET("CheckMomentsEligibility", function(callback, p2)
		return callback(API_URL):path("content-captures-api"):path("v1"):path("check-moments-eligibility"):queryArgs({
			contentType = p2.contentType,
			experienceId = p2.experienceId
		})
	end)
end
