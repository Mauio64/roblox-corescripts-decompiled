local ParentParent = script.Parent.Parent
local API_URL = require(ParentParent.API_URL)

return function(t1: {[any]: any}) -- line: 13
	-- upvalues: API_URL (copy)
	return t1.roduxNetworking.GET({
		Name = "GetPostsByUserId"
	}, function(p1, t2: {[any]: any}) -- line: 16
		-- upvalues: API_URL (copy)
		return p1(API_URL):path("posts-api"):path("v1"):path("content-posts"):path("findByUser"):queryArgs({
			limit = t2.limit,
			userId = t2.userId
		})
	end)
end
