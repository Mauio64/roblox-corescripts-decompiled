local parent = script.Parent.Parent.Parent
local Http = require(parent.Http)
local THUMBNAILS_URL = Http.Url.THUMBNAILS_URL

return function(p)
	return p.roduxNetworking.POST("GetThumbnailByAssetId", function(callback, data)
		return callback(THUMBNAILS_URL):path("v1"):path("batch"):body({
			{ targetId = data.assetId, type = data.assetType, size = data.size }
		})
	end)
end
