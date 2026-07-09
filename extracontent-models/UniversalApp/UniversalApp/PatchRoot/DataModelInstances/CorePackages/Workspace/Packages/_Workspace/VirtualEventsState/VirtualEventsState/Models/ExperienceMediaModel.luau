return {
	mock = function(n1: number?) -- line: 18
		return {
			assetTypeId = -1,
			assetType = "Image",
			videoHash = nil,
			videoTitle = nil,
			approved = true,
			altText = "Alt Text",
			imageId = n1 or 123456789
		}
	end
}
