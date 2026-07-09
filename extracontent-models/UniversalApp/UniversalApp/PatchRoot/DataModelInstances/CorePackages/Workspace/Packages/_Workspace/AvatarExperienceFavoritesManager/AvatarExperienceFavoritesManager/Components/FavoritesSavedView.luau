local Parent = script:FindFirstAncestor("AvatarExperienceFavoritesManager").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)

local function FavoritesSavedView() -- line: 16
	-- upvalues: React (copy), Foundation (copy)
	return React.createElement(Foundation.View, {
		tag = "size-full bg-surface-0",
		testId = "FavoritesSavedView"
	})
end

return React.memo(FavoritesSavedView)
