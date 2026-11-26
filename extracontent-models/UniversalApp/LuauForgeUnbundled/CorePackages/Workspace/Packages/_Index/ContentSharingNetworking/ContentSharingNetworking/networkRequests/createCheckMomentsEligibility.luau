local API_URL = require("@game/CorePackages/Workspace/Packages/_Index/ContentSharingNetworking/ContentSharingNetworking/API_URL")

return function(p2)
	return p2.roduxNetworking.GET("CheckMomentsEligibility", function(callback, p3)
		return callback(API_URL):path("content-captures-api"):path("v1"):path("check-moments-eligibility"):queryArgs({
			contentType = p3.contentType,
			experienceId = p3.experienceId
		})
	end)
end
