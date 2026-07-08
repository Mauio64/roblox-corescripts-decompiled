local ParentParent = script.Parent.Parent
local API_URL = require(ParentParent.API_URL)

return function(t1: {[any]: any}) -- line: 13
	-- upvalues: API_URL (copy)
	return t1.roduxNetworking.GET({
		Name = "GetSelfSocialLinks"
	}, function(p1, t2: {[any]: any}) -- line: 16
		-- upvalues: API_URL (copy)
		return p1(API_URL):path("v1"):path("promotion-channels"):queryArgs({
			alwaysReturnUrls = t2.alwaysReturnUrls,
			filterLink = t2.filterLink
		})
	end)
end
