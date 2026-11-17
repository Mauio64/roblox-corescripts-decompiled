local parent = script:FindFirstAncestor("FriendsMenu").Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local NotificationsCommon = require(parent.NotificationsCommon)
local LocalizationHelper = NotificationsCommon.LocalizationHelper

local useStyle = UIBlox.Core.Style.useStyle
local getLocalizedStrings = LocalizationHelper.getLocalizedStrings

return function(p)
	local v = useStyle()
	local theme = v.Theme
	local font = v.Font

	local textSize = font.BaseSize * font.Body.RelativeSize
	local localizedStrings = getLocalizedStrings({
		errorFriendsList = "Feature.SettingsHub.Label.FriendsListLoadErrorMessage",
		noResultFriendsList = "Feature.SettingsHub.Label.InviteSearchNoResults"
	})

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Name = p.msgType
	}, {
		subtitle = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Text = localizedStrings[p.msgType],
			TextColor3 = theme.TextDefault.Color,
			TextTransparency = theme.TextDefault.Transparency,
			TextSize = textSize,
			TextWrapped = true,
			FontFace = normalizeFontFace(v.Tokens.Typography.BodyLarge.Font),
			Size = UDim2.new(1, 0, 0, textSize),
			Position = UDim2.new(0, 0, 0.4, 0),
			TextYAlignment = Enum.TextYAlignment.Top
		})
	})
end
