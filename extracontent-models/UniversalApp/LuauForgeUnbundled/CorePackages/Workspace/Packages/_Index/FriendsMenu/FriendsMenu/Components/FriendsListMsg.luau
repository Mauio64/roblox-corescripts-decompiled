local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
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

	local createElement = React.createElement
	local v8 = {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Name = p2.msgType
	}

	local createElement2 = React.createElement
	local v11 = {
		BackgroundTransparency = 1,
		Text = localizedStrings[p2.msgType],
		TextColor3 = theme.TextDefault.Color,
		TextTransparency = theme.TextDefault.Transparency,
		TextSize = v6,
		TextWrapped = true,
		Font = 0,
		FontFace = 0,
		Size = 0,
		Position = 0,
		TextYAlignment = 0
	}

	local v12 = if not foundationFontFaceMigration then font.Body.Font else nil
	v11.Font = v12

	local v13 = if foundationFontFaceMigration then normalizeFontFace(v5.Tokens.Typography.BodyLarge.Font) else nil
	v11.FontFace = v13

	v11.Size = UDim2.new(1, 0, 0, v6)
	v11.Position = UDim2.new(0, 0, 0.4, 0)
	v11.TextYAlignment = Enum.TextYAlignment.Top
	return createElement("Frame", v8, {
		subtitle = createElement2("TextLabel", v11)
	})
end
