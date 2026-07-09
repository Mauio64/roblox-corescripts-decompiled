local Parent = script:FindFirstAncestor("AvatarExperienceFavoritesManager").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)

local function onBackActivated() -- line: 18
end
local function onSearchActivated() -- line: 22
end
local function FavoritesNavBar() -- line: 24
	-- upvalues: React (copy), Foundation (copy), onBackActivated (copy), onSearchActivated (copy)
	return React.createElement(Foundation.View, {
		tag = "row items-center gap-medium size-full-0 auto-y padding-x-xlarge padding-y-medium bg-surface-0",
		testId = "FavoritesNavBar"
	}, {
		BackButton = React.createElement(Foundation.IconButton, {
			icon = "chevron-large-left",
			tag = "content-emphasis",
			testId = "FavoritesNavBarBackButton",
			onActivated = onBackActivated,
			size = Foundation.Enums.InputSize.Medium
		}),
		Title = React.createElement(Foundation.Text, {
			Text = "Favorites",
			tag = "grow auto-y text-title-large text-align-x-center content-emphasis",
			TextTruncate = Enum.TextTruncate.AtEnd
		}),
		SearchButton = React.createElement(Foundation.IconButton, {
			tag = "content-emphasis",
			testId = "FavoritesNavBarSearchButton",
			onActivated = onSearchActivated,
			size = Foundation.Enums.InputSize.Medium,
			icon = Foundation.Enums.IconName.MagnifyingGlass
		})
	})
end

return React.memo(FavoritesNavBar)
