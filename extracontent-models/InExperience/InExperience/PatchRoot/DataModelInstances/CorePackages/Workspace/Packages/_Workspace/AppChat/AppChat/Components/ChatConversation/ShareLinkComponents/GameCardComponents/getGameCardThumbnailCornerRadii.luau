local AppChat = script:FindFirstAncestor("AppChat")

local RoundedVariant = require(AppChat.Enums.RoundedVariant)
local getCornerRadii = require(script.Parent.Parent.getCornerRadii)

local v = {
	[RoundedVariant.Top] = { topLeft = true, topRight = true },
	[RoundedVariant.TopLeft] = { topLeft = true },
	[RoundedVariant.TopRight] = { topRight = true }
}

local function getGameCardThumbnailCornerRadii(p, p2: number)
	return getCornerRadii(v[p or RoundedVariant.Top] or v[RoundedVariant.Top], p2)
end

return getGameCardThumbnailCornerRadii
