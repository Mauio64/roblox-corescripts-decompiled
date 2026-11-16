local parent = script:FindFirstAncestor("AppBlox").Parent
local UIBlox = require(parent.UIBlox)
local ImageSet = UIBlox.App.ImageSet
local IconSize = ImageSet.Enum.IconSize
local iconSize = ImageSet.getIconSize(IconSize.Medium)

function calcMediaGallerySizesFromWidth(p: number, p2: number, flag: boolean?)
	local v

	if flag then
		v = p
	else
		v = p - iconSize * 2
	end

	local v2 = math.floor(v / (16 / 9))
	local v3

	if flag then
		v3 = math.floor((p - (p2 - 1) * 12) / p2)
	else
		v3 = math.floor((p - (p2 - 1) * 12 - iconSize * 2) / p2)
	end

	local v4

	if flag then
		v4 = p + iconSize * 2
	else
		v4 = p
	end

	local v5 = math.floor(v3 / (16 / 9))
	local v6 = v2 + v5 + 24

	return {
		contentSize = UDim2.fromOffset(p, v6),
		previewSize = UDim2.fromOffset(v, v2),
		paginationSize = UDim2.fromOffset(v4, v5),
		thumbnailSize = UDim2.fromOffset(v3, v5)
	}
end

return calcMediaGallerySizesFromWidth
