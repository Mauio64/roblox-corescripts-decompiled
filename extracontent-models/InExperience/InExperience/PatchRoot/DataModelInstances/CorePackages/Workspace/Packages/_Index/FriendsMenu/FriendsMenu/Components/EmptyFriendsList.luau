local parent = script:FindFirstAncestor("FriendsMenu").Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
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

	local createElement = React.createElement
	local v2 = {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, -20),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Name = "EmptyFriendsList"
	}

	local v3 = {
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
		subtitle = 0
	}

	local createElement2 = React.createElement
	local v4 = {
		BackgroundTransparency = 1,
		Text = localizedStrings.noFriendsText,
		TextColor3 = theme.TextDefault.Color,
		TextTransparency = theme.TextDefault.Transparency,
		TextSize = textSize,
		TextWrapped = true,
		Font = 0,
		FontFace = 0,
		LayoutOrder = 2,
		Size = 0,
		TextYAlignment = 0
	}
	local font2

	if not FoundationFontFaceMigration then
		font2 = font.Body.Font
	end

	v4.Font = font2
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(v.Tokens.Typography.BodyLarge.Font)
	end

	v4.FontFace = fontFace

	v4.Size = UDim2.new(1, 0, 0, textSize)
	v4.TextYAlignment = Enum.TextYAlignment.Top
	v3.subtitle = createElement2("TextLabel", v4)
	return createElement("Frame", v2, v3)
end
