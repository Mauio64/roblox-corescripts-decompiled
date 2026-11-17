local parent = script:FindFirstAncestor("FriendsMenu").Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local NotificationsCommon = require(parent.NotificationsCommon)
local LocalizationHelper = NotificationsCommon.LocalizationHelper

local useStyle = UIBlox.Core.Style.useStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local getLocalizedStrings = LocalizationHelper.getLocalizedStrings

local iconsmenufriends_large = Images["icons/menu/friends_large"]

return function()
	local v = useStyle()
	local theme = v.Theme
	local font = v.Font

	local localizedStrings = getLocalizedStrings({
		noFriendsText = "Feature.SettingsHub.Label.NoFriendsPageMessage"
	})

	local textSize = font.BaseSize * font.Body.RelativeSize

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
		friendsIcon = React.createElement(ImageSetLabel, {
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
			TextSize = textSize,
			TextWrapped = true,
			FontFace = normalizeFontFace(v.Tokens.Typography.BodyLarge.Font),
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, textSize),
			TextYAlignment = Enum.TextYAlignment.Top
		})
	})
end
