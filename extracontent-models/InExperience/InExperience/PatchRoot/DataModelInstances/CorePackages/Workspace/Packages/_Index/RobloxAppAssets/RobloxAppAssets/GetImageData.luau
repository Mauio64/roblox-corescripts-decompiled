local GetImageSetData = require(script.Parent.GetImageSetData)
local GetImageSetPathPattern = require(script.Parent.GetImageSetPathPattern)
local Images = require(script.Parent.Parent.FoundationImages).Images

require(script.Parent.types)

local function GetImageData(s1: string, n1: number?) -- line: 9
	-- upvalues: GetImageSetData (copy), Images (copy), GetImageSetPathPattern (copy)
	local v7 = GetImageSetData(n1 or Images.ImagesResolutionScale)[s1]

	if v7 == nil then
		return nil
	end

	return {
		Image = GetImageSetPathPattern(v7.ImageSet),
		ImageRectSize = v7.ImageRectSize,
		ImageRectOffset = v7.ImageRectOffset
	}
end

return GetImageData
