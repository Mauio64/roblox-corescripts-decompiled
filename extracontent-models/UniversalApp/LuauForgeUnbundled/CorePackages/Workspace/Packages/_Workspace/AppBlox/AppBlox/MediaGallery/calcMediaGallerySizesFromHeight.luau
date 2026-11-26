local imageSet = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/UIBlox").App.ImageSet
local iconSize = imageSet.Enum.IconSize
local getIconSize = imageSet.getIconSize

local calcMediaGallerySizesFromWidth = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/MediaGallery/calcMediaGallerySizesFromWidth")

local iconSize2 = getIconSize(iconSize.Medium)

function LUAUFORGE_MODULE_GLOBALS_aoY_calcMediaGallerySizesFromHeight(p2, p3, p4)
	return calcMediaGallerySizesFromWidth(
		math.floor((math.floor((p2 - 24) * (16 / 9) * p3) + 12 * (p3 - 1) + iconSize2 * 2 + iconSize2 * 2 * p3) / (p3 + 1)),
		p3,
		p4
	)
end

return LUAUFORGE_MODULE_GLOBALS_aoY_calcMediaGallerySizesFromHeight
