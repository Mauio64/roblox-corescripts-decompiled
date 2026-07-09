local ParentParent = script.Parent.Parent
local API_URL = require(ParentParent.API_URL)

return function(t1: {[any]: any}) -- line: 13
	-- upvalues: API_URL (copy)
	return t1.roduxNetworking.GET({
		Name = "CheckMomentsEligibility"
	}, function(p1, t2: {[any]: any}) -- line: 16
		-- upvalues: API_URL (copy)
		return p1(API_URL):path("content-captures-api"):path("v1"):path("check-moments-eligibility"):queryArgs({
			contentType = t2.contentType,
			experienceId = t2.experienceId
		})
	end)
end
