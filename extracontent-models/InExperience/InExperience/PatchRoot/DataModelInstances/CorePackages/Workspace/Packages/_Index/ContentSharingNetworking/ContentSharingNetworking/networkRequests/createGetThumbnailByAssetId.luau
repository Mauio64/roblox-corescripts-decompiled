local ParentParent = script.Parent.Parent.Parent
local THUMBNAILS_URL = require(ParentParent.Http).Url.THUMBNAILS_URL

return function(t1: {[any]: any}) -- line: 15
	-- upvalues: THUMBNAILS_URL (copy)
	return t1.roduxNetworking.POST({
		Name = "GetThumbnailByAssetId"
	}, function(p1, t2: {[any]: any}) -- line: 18
		-- upvalues: THUMBNAILS_URL (copy)
		return p1(THUMBNAILS_URL):path("v1"):path("batch"):body({{
			targetId = t2.assetId,
			type = t2.assetType,
			size = t2.size
		}})
	end)
end
