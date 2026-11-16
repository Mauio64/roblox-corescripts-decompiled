local imageSet = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/UIBlox").App.ImageSet
local iconSize = imageSet.Enum.IconSize
local iconSize2 = imageSet.getIconSize(iconSize.Medium)

function LUAUFORGE_MODULE_GLOBALS_anU_calcMediaGallerySizesFromWidth(p2, p3, p4)
	local v5 = if p4 then p2 else p2 - iconSize2 * 2
	local v6 = math.floor(v5 / (16 / 9))
	local v7

	if p4 then
		v7 = math.floor((p2 - 12 * (p3 - 1)) / p3)
	else
		v7 = math.floor((p2 - 12 * (p3 - 1) - iconSize2 * 2) / p3)
	end

	local v8 = if p4 then p2 + iconSize2 * 2 else p2
	local v9 = math.floor(v7 / (16 / 9))
	local v10 = v6 + v9 + 24

	return {
		contentSize = UDim2.fromOffset(p2, v10),
		previewSize = UDim2.fromOffset(v5, v6),
		paginationSize = UDim2.fromOffset(v8, v9),
		thumbnailSize = UDim2.fromOffset(v7, v9)
	}
end

return LUAUFORGE_MODULE_GLOBALS_anU_calcMediaGallerySizesFromWidth
