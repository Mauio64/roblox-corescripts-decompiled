local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/constants")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Foundation")

local v5 = { size = constants.ICON_SIZE }

local function LikeButton(p2)
	local joined = Cryo.Dictionary.join(v5, p2)

	return React.createElement(Foundation.IconButton, {
		icon = joined.isFavorited and "icons/common/ratingFilled_medium" or "icons/common/rating_medium",
		size = Foundation.Enums.IconSize.Medium,
		onActivated = not joined.onFavorite and function() end or joined.onFavorite
	})
end

return LikeButton
