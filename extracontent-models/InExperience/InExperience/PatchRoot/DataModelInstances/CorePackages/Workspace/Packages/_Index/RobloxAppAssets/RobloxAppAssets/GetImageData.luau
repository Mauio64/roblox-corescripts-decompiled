local GetImageSetData = require(script.Parent.GetImageSetData)
local GetImageSetPathPattern = require(script.Parent.GetImageSetPathPattern)
local FoundationImages = require(script.Parent.Parent.FoundationImages)
local Images = FoundationImages.Images

require(script.Parent.types)

local function GetImageData(p: string, p2: number?)
	local v = GetImageSetData(p2 or Images.ImagesResolutionScale)[p]

	if v == nil then
		return nil
	end

	return {
		Image = GetImageSetPathPattern(v.ImageSet),
		ImageRectSize = v.ImageRectSize,
		ImageRectOffset = v.ImageRectOffset
	}
end

return GetImageData
