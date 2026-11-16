local Songbird = script:FindFirstAncestor("Songbird")

local constants = require(Songbird.constants)
local Cryo = require(Songbird.Parent.Cryo)
local React = require(Songbird.Parent.React)
local Foundation = require(Songbird.Parent.Foundation)

local v = { size = constants.ICON_SIZE }

local function LikeButton(p)
	local joined = Cryo.Dictionary.join(v, p)

	return React.createElement(Foundation.IconButton, {
		icon = joined.isFavorited and "icons/common/ratingFilled_medium" or "icons/common/rating_medium",
		size = Foundation.Enums.IconSize.Medium,
		onActivated = not joined.onFavorite and function() end or joined.onFavorite
	})
end

return LikeButton
