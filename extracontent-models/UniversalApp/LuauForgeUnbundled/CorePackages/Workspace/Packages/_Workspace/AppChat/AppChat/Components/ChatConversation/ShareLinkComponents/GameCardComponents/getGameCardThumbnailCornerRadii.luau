local RoundedVariant = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Enums/RoundedVariant")
local getCornerRadii = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/getCornerRadii")

local v5 = {
	[RoundedVariant.Top] = { topLeft = true, topRight = true },
	[RoundedVariant.TopLeft] = { topLeft = true },
	[RoundedVariant.TopRight] = { topRight = true }
}

local function getGameCardThumbnailCornerRadii(p2, p3)
	return getCornerRadii(v5[p2 or RoundedVariant.Top] or v5[RoundedVariant.Top], p3)
end

return getGameCardThumbnailCornerRadii
