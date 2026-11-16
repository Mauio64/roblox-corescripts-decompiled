return {
	mock = function(value: number?)
		return {
			assetTypeId = -1,
			assetType = "Image",
			imageId = value or 123456789,
			videoHash = nil,
			videoTitle = nil,
			approved = true,
			altText = "Alt Text"
		}
	end
}
