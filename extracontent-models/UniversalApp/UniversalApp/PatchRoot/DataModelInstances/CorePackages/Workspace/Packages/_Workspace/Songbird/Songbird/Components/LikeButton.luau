local Songbird = script:FindFirstAncestor("Songbird")
local constants = require(Songbird.constants)
local Cryo = require(Songbird.Parent.Cryo)
local React = require(Songbird.Parent.React)
local Foundation = require(Songbird.Parent.Foundation)
local t1 = {
	size = constants.ICON_SIZE
}

local function LikeButton(t2: {[any]: any}) -- line: 20
	-- upvalues: Cryo (copy), t1 (copy), React (copy), Foundation (copy)
	local v9 = Cryo.Dictionary.join(t1, t2)

	return React.createElement(Foundation.IconButton, {
		icon = not v9.isFavorited and "icons/common/rating_medium" or "icons/common/ratingFilled_medium",
		size = Foundation.Enums.IconSize.Medium,
		onActivated = not v9.onFavorite and function() -- line: 26
		end or v9.onFavorite
	})
end

return LikeButton
