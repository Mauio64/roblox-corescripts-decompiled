local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)

return {
	validate = t.strictInterface({
		thumbnailKeyframe = t.number,
		thumbnailTime = t.number,
		thumbnailZoom = t.number,
		thumbnailVerticalOffset = t.number,
		thumbnailHorizontalOffset = t.number,
		thumbnailCharacterRotation = t.number
	}),
	defaultParameters = {
		thumbnailKeyframe = 1,
		thumbnailTime = 0,
		thumbnailZoom = 1,
		thumbnailVerticalOffset = 0,
		thumbnailHorizontalOffset = 0,
		thumbnailCharacterRotation = 0
	},
	encodeAsATable = function(t1: {[any]: any}) -- line: 41
		return {
			ThumbnailBundleId = 515,
			ThumbnailCharacterRotation = t1.thumbnailCharacterRotation,
			ThumbnailHorizontalOffset = t1.thumbnailHorizontalOffset,
			ThumbnailVerticalOffset = t1.thumbnailVerticalOffset,
			ThumbnailZoom = t1.thumbnailZoom,
			ThumbnailKeyframe = t1.thumbnailKeyframe,
			ThumbnailTime = t1.thumbnailTime
		}
	end
}
