local GetImageSetData = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppAssets/RobloxAppAssets/GetImageSetData")
local GetImageSetPathPattern = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppAssets/RobloxAppAssets/GetImageSetPathPattern")
local images = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppAssets/FoundationImages").Images

require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppAssets/RobloxAppAssets/types")

local function GetImageData(p2, p3)
	local v5 = GetImageSetData(p3 or images.ImagesResolutionScale)[p2]

	if v5 == nil then
		return nil
	end

	return {
		Image = GetImageSetPathPattern(v5.ImageSet),
		ImageRectSize = v5.ImageRectSize,
		ImageRectOffset = v5.ImageRectOffset
	}
end

return GetImageData
