local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local localizationHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/NotificationsCommon").LocalizationHelper

local useStyle = UIBlox.Core.Style.useStyle
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local images = UIBlox.App.ImageSet.Images
local getLocalizedStrings = localizationHelper.getLocalizedStrings

local iconsmenufriends_large = images["icons/menu/friends_large"]

return function()
	local v5 = useStyle()
	local theme = v5.Theme
	local font = v5.Font

	local localizedStrings = getLocalizedStrings({
		noFriendsText = "Feature.SettingsHub.Label.NoFriendsPageMessage"
	})

	local v6 = font.BaseSize * font.Body.RelativeSize

	local createElement = React.createElement
	local v8 = {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, -20),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Name = "EmptyFriendsList"
	}

	local v9 = {
		listLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 12)
		}),
		friendsIcon = React.createElement(imageSetLabel, {
			Image = iconsmenufriends_large,
			Size = UDim2.new(0, 48, 0, 48),
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}),
		subtitle = 0
	}

	local createElement2 = React.createElement
	local v11 = {
		BackgroundTransparency = 1,
		Text = localizedStrings.noFriendsText,
		TextColor3 = theme.TextDefault.Color,
		TextTransparency = theme.TextDefault.Transparency,
		TextSize = v6,
		TextWrapped = true,
		Font = 0,
		FontFace = 0,
		LayoutOrder = 2,
		Size = 0,
		TextYAlignment = 0
	}

	local v12 = if not foundationFontFaceMigration then font.Body.Font else nil
	v11.Font = v12

	local v13 = if foundationFontFaceMigration then normalizeFontFace(v5.Tokens.Typography.BodyLarge.Font) else nil
	v11.FontFace = v13

	v11.Size = UDim2.new(1, 0, 0, v6)
	v11.TextYAlignment = Enum.TextYAlignment.Top
	v9.subtitle = createElement2("TextLabel", v11)
	return createElement("Frame", v8, v9)
end
