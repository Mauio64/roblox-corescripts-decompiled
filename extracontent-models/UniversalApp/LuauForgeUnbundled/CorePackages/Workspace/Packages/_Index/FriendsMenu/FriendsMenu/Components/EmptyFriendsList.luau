local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/UIBlox")
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/Foundation").Utility.normalizeFontFace
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

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, -20),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Name = "EmptyFriendsList"
	}, {
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
		subtitle = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Text = localizedStrings.noFriendsText,
			TextColor3 = theme.TextDefault.Color,
			TextTransparency = theme.TextDefault.Transparency,
			TextSize = v6,
			TextWrapped = true,
			FontFace = normalizeFontFace(v5.Tokens.Typography.BodyLarge.Font),
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, v6),
			TextYAlignment = Enum.TextYAlignment.Top
		})
	})
end
