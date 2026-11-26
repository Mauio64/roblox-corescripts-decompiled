local THUMBNAILS_URL = require("@game/CorePackages/Workspace/Packages/_Workspace/ContentSharingNetworking/Http").Url.THUMBNAILS_URL

return function(p2)
	return p2.roduxNetworking.POST("GetThumbnailByAssetId", function(callback, data)
		return callback(THUMBNAILS_URL):path("v1"):path("batch"):body({
			{ targetId = data.assetId, type = data.assetType, size = data.size }
		})
	end)
end
