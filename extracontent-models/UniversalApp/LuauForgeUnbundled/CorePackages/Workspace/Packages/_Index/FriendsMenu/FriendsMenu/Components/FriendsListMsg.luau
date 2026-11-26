local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/UIBlox")
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/Foundation").Utility.normalizeFontFace
local localizationHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/NotificationsCommon").LocalizationHelper

local useStyle = UIBlox.Core.Style.useStyle
local getLocalizedStrings = localizationHelper.getLocalizedStrings

return function(p2)
	local v5 = useStyle()
	local theme = v5.Theme
	local font = v5.Font

	local v6 = font.BaseSize * font.Body.RelativeSize
	local localizedStrings = getLocalizedStrings({
		errorFriendsList = "Feature.SettingsHub.Label.FriendsListLoadErrorMessage",
		noResultFriendsList = "Feature.SettingsHub.Label.InviteSearchNoResults"
	})

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Name = p2.msgType
	}, {
		subtitle = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Text = localizedStrings[p2.msgType],
			TextColor3 = theme.TextDefault.Color,
			TextTransparency = theme.TextDefault.Transparency,
			TextSize = v6,
			TextWrapped = true,
			FontFace = normalizeFontFace(v5.Tokens.Typography.BodyLarge.Font),
			Size = UDim2.new(1, 0, 0, v6),
			Position = UDim2.new(0, 0, 0.4, 0),
			TextYAlignment = Enum.TextYAlignment.Top
		})
	})
end
