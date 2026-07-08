local Parent = script:FindFirstAncestor("AppBlox").Parent
local ImageSet = require(Parent.UIBlox).App.ImageSet
local IconSize = ImageSet.Enum.IconSize
local getIconSize = ImageSet.getIconSize
local calcMediaGallerySizesFromWidth = require(script.Parent.calcMediaGallerySizesFromWidth)
local v6 = getIconSize(IconSize.Medium)

function calcMediaGallerySizesFromHeight(n1: number, n2: number, b1: boolean?) -- line: 17
	-- upvalues: v6 (copy), calcMediaGallerySizesFromWidth (copy)
	local v10 = math.floor((math.floor((n1 - 24) * 1.7777777777777777 * n2) + (n2 - 1) * 12 + v6 * 2 + v6 * 2 * n2) / (n2 + 1))

	return calcMediaGallerySizesFromWidth(v10, n2, b1)
end

return calcMediaGallerySizesFromHeight
