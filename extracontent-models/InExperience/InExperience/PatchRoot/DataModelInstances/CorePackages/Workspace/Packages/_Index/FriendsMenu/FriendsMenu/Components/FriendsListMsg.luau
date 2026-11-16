local parent = script:FindFirstAncestor("FriendsMenu").Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
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

	local createElement = React.createElement
	local v2 = {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Name = p.msgType
	}

	local createElement2 = React.createElement
	local v3 = {
		BackgroundTransparency = 1,
		Text = localizedStrings[p.msgType],
		TextColor3 = theme.TextDefault.Color,
		TextTransparency = theme.TextDefault.Transparency,
		TextSize = textSize,
		TextWrapped = true,
		Font = 0,
		FontFace = 0,
		Size = 0,
		Position = 0,
		TextYAlignment = 0
	}
	local font2

	if not FoundationFontFaceMigration then
		font2 = font.Body.Font
	end

	v3.Font = font2
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(v.Tokens.Typography.BodyLarge.Font)
	end

	v3.FontFace = fontFace

	v3.Size = UDim2.new(1, 0, 0, textSize)
	v3.Position = UDim2.new(0, 0, 0.4, 0)
	v3.TextYAlignment = Enum.TextYAlignment.Top
	return createElement("Frame", v2, {
		subtitle = createElement2("TextLabel", v3)
	})
end
