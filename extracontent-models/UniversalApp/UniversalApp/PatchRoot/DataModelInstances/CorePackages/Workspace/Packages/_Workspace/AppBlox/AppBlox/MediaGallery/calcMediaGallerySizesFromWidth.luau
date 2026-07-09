local Parent = script:FindFirstAncestor("AppBlox").Parent
local ImageSet = require(Parent.UIBlox).App.ImageSet
local IconSize = ImageSet.Enum.IconSize
local v4 = ImageSet.getIconSize(IconSize.Medium)

function calcMediaGallerySizesFromWidth(n1: number, n2: number, b1: boolean?) -- line: 15
	-- upvalues: v4 (copy)
	local v8 = if not b1 then n1 - v4 * 2 else n1
	local v9 = math.floor(v8 / 1.7777777777777777)
	local v10 = if not b1 then math.floor((n1 - (n2 - 1) * 12 - v4 * 2) / n2) else math.floor((n1 - (n2 - 1) * 12) / n2)
	local v11 = if not b1 then n1 else n1 + v4 * 2
	local v12 = math.floor(v10 / 1.7777777777777777)
	local v13 = v9 + v12 + 24

	return {
		contentSize = UDim2.fromOffset(n1, v13),
		previewSize = UDim2.fromOffset(v8, v9),
		paginationSize = UDim2.fromOffset(v11, v12),
		thumbnailSize = UDim2.fromOffset(v10, v12)
	}
end

return calcMediaGallerySizesFromWidth
