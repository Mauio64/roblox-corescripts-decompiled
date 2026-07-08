local ParentParent = script.Parent.Parent
local API_URL = require(ParentParent.API_URL)

return function(t1: {[any]: any}) -- line: 14
	-- upvalues: API_URL (copy)
	return t1.roduxNetworking.GET({
		Name = "GetSocialLinks"
	}, function(p1, t2: {[any]: any}) -- line: 17
		-- upvalues: API_URL (copy)
		return p1(API_URL):path("v1"):path("users"):id(t2.userId):path("promotion-channels"):queryArgs({
			alwaysReturnUrls = t2.alwaysReturnUrls,
			filterLink = t2.filterLink
		})
	end)
end
