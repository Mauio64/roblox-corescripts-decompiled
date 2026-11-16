local parent = script:FindFirstAncestor("AppBlox").Parent
local UIBlox = require(parent.UIBlox)
local ImageSet = UIBlox.App.ImageSet
local IconSize = ImageSet.Enum.IconSize
local getIconSize = ImageSet.getIconSize

local calcMediaGallerySizesFromWidth = require(script.Parent.calcMediaGallerySizesFromWidth)

local iconSize = getIconSize(IconSize.Medium)

function calcMediaGallerySizesFromHeight(p: number, p2: number, flag: boolean?)
	return calcMediaGallerySizesFromWidth(
		math.floor((math.floor((p - 24) * (16 / 9) * p2) + (p2 - 1) * 12 + iconSize * 2 + iconSize * 2 * p2) / (p2 + 1)),
		p2,
		flag
	)
end

return calcMediaGallerySizesFromHeight
