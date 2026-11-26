local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local SocialLibraries = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/SocialLibraries")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation").Hooks.useTokens
local FFlagDebugAppChatEnableDomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAppChatEnableDomLocators")
local FFlagAppChatRemoveConversationListDivider = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatRemoveConversationListDivider")

local PresenceBubbleCell = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Cells/PresenceBubbleCell")
local testStyle = SocialLibraries.Components.TestStyle

local v5 = {
	Size = UDim2.new(1, 0, 1, 0),
	avatarCirclePresenceImage = nil,
	subTitleText = nil,
	subTitleIcon = nil,
	titleText = "TestUser",
	secondaryTitleText = nil,
	thumbnails = {},
	conversationId = nil,
	childWidth = 0,
	style = Cryo.Dictionary.join(testStyle, {
		Tokens = {
			Color = { None = {} }
		}
	}),
	showDivider = not FFlagAppChatRemoveConversationListDivider,
	boldTitle = true,
	isLoading = false,
	hideLeftAvatarPadding = false,
	paddingLeft = 0,
	paddingRight = 0
}

local function StyledCell(p2)
	local v6 = useTokens()
	local joined = Cryo.Dictionary.join(v5, p2)
	local style = joined.style
	local theme = style.Theme
	local font = style.Font

	local v7 = type(joined.avatarCirclePresenceImage) == "table"

	local createElement = React.createElement
	local v9 = {}
	v9.childWidth = joined.childWidth
	v9.titleText = joined.titleText
	v9.secondaryTitleText = joined.secondaryTitleText
	v9.subTitleText = joined.subTitleText
	v9.subTitleTimestamp = joined.subTitleTimestamp
	v9.subTitleIcon = joined.subTitleIcon
	local v10 = if FFlagDebugAppChatEnableDomLocators then joined.testId else nil
	v9.testId = v10
	v9.avatarCirclePresenceImage = joined.avatarCirclePresenceImage
	v9.thumbnails = joined.thumbnails
	v9.onActivated = joined.onActivated
	v9.onCircleActivated = joined.onCircleActivated
	v9.Size = joined.Size
	v9.isLoading = joined.isLoading
	v9.showNewPresenceImage = v7
	v9.conversationId = joined.conversationId
	v9.participants = joined.participants

	v9.BackgroundColor3 = theme.BackgroundDefault.Color
	v9.BackgroundTransparency = style.Tokens.Color.None.Transparency
	v9.onPressedBackgroundColor3 = theme.BackgroundOnPress.Color
	v9.onPressedBackgroundTransparency = theme.BackgroundOnPress.Transparency

	v9.avatarCircleBackgroundColor3 = theme.PlaceHolder.Color
	v9.avatarCircleDividerColor3 = theme.PlaceHolder.Color

	local v11 = if v7 then theme.OnlineStatus.Color else nil
	v9.avatarCirclePresenceImageColor3 = v11
	local v12 = if v7 then theme.OnlineStatus.Transparency else nil
	v9.avatarCirclePresenceImageTransparency = v12

	v9.subTitleTextFont = v6.Typography.BodySmall.Font
	v9.subTitleTextTransparency = theme.TextDefault.Transparency
	v9.subTitleTextColor3 = theme.TextDefault.Color
	v9.subTitleTextSize = font.CaptionBody.RelativeSize * font.BaseSize

	v9.subTitleIconColor3 = style.Theme.IconDefault.Color
	v9.subTitleIconTransparency = style.Theme.IconDefault.Transparency

	v9.titleFont = v6.Typography.TitleLarge.Font
	local v13 = if joined.boldTitle then theme.TextEmphasis.Transparency else theme.TextDefault.Transparency
	v9.titleTextTransparency = v13

	local v14 = if joined.boldTitle then theme.TextEmphasis.Color else theme.TextDefault.Color
	v9.titleTextColor3 = v14
	v9.titleTextSize = font.Header2.RelativeSize * font.BaseSize

	v9.secondaryTitleFont = v6.Typography.TitleLarge.Font
	v9.secondaryTitleTextTransparency = theme.TextMuted.Transparency
	v9.secondaryTitleTextColor3 = theme.TextMuted.Color
	v9.secondaryTitleTextSize = font.Header2.RelativeSize * font.BaseSize

	v9.showDivider = joined.showDivider
	v9.dividerTransparency = theme.Divider.Transparency
	v9.dividerColor3 = theme.Divider.Color

	v9.avatarCircleSize = v6.Size.Size_1000
	v9.avatarCircleCellWidth = v6.Size.Size_1200
	v9.hideLeftAvatarPadding = joined.hideLeftAvatarPadding
	v9.paddingLeft = joined.paddingLeft
	v9.paddingRight = joined.paddingRight
	v9.isRobloxSubscriber = joined.isRobloxSubscriber
	return createElement(PresenceBubbleCell, v9, joined.children or {})
end

return React.memo(StyledCell)
