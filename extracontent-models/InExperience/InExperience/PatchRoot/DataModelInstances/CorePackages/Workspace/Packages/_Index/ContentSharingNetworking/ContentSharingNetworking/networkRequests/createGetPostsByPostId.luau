local ParentParent = script.Parent.Parent
local API_URL = require(ParentParent.API_URL)

return function(t1: {[any]: any}) -- line: 14
	-- upvalues: API_URL (copy)
	return t1.roduxNetworking.GET({
		Name = "GetPostsByPostId"
	}, function(p1, t2: {[any]: any}) -- line: 17
		-- upvalues: API_URL (copy)
		return p1(API_URL):path("posts-api"):path("v1"):path("content-posts"):path("findByUser"):queryArgs({
			limit = t2.limit,
			postId = t2.postId,
			userId = t2.userId
		})
	end)
end
