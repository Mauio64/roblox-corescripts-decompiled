local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheet/Foundation")
local getRbxThumb = Foundation.Utility.getRbxThumb
local thumbnailSize = Foundation.Enums.ThumbnailSize
local thumbnailType = Foundation.Enums.ThumbnailType

local function getSchoolRewardThumbnail(p2)
	return getRbxThumb(thumbnailType.Asset, p2, thumbnailSize.Large)
end

return getSchoolRewardThumbnail
