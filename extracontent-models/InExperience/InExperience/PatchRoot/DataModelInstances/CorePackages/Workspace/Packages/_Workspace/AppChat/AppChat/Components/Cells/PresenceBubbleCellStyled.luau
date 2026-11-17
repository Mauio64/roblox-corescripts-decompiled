local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
require(parent.UIBlox)
local SocialLibraries = require(AppChat.SocialLibraries)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local FFlagAppChatRemoveConversationListDivider = require(AppChat.Flags.FFlagAppChatRemoveConversationListDivider)

local PresenceBubbleCell = require(script.Parent.PresenceBubbleCell)
local TestStyle = SocialLibraries.Components.TestStyle

local v = {
	Size = UDim2.new(1, 0, 1, 0),
	avatarCirclePresenceImage = nil,
	subTitleText = nil,
	subTitleIcon = nil,
	titleText = "TestUser",
	secondaryTitleText = nil,
	thumbnails = {},
	conversationId = nil,
	childWidth = 0,
	style = Cryo.Dictionary.join(TestStyle, {
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

local function StyledCell(p)
	local v2 = useTokens()
	local joined = Cryo.Dictionary.join(v, p)
	local style = joined.style
	local theme = style.Theme
	local font = style.Font

	local showNewPresenceImage = type(joined.avatarCirclePresenceImage) == "table"

	local createElement = React.createElement
	local v3 = {}
	v3.childWidth = joined.childWidth
	v3.titleText = joined.titleText
	v3.secondaryTitleText = joined.secondaryTitleText
	v3.subTitleText = joined.subTitleText
	v3.subTitleTimestamp = joined.subTitleTimestamp
	v3.subTitleIcon = joined.subTitleIcon
	local testId

	if FFlagDebugAppChatEnableDomLocators then
		testId = joined.testId
	end

	v3.testId = testId
	v3.avatarCirclePresenceImage = joined.avatarCirclePresenceImage
	v3.thumbnails = joined.thumbnails
	v3.onActivated = joined.onActivated
	v3.onCircleActivated = joined.onCircleActivated
	v3.Size = joined.Size
	v3.isLoading = joined.isLoading
	v3.showNewPresenceImage = showNewPresenceImage
	v3.conversationId = joined.conversationId
	v3.participants = joined.participants

	v3.BackgroundColor3 = theme.BackgroundDefault.Color
	v3.BackgroundTransparency = style.Tokens.Color.None.Transparency
	v3.onPressedBackgroundColor3 = theme.BackgroundOnPress.Color
	v3.onPressedBackgroundTransparency = theme.BackgroundOnPress.Transparency

	v3.avatarCircleBackgroundColor3 = theme.PlaceHolder.Color
	v3.avatarCircleDividerColor3 = theme.PlaceHolder.Color
	local avatarCirclePresenceImageColor

	if showNewPresenceImage then
		avatarCirclePresenceImageColor = theme.OnlineStatus.Color
	end

	v3.avatarCirclePresenceImageColor3 = avatarCirclePresenceImageColor
	local avatarCirclePresenceImageTransparency

	if showNewPresenceImage then
		avatarCirclePresenceImageTransparency = theme.OnlineStatus.Transparency
	end

	v3.avatarCirclePresenceImageTransparency = avatarCirclePresenceImageTransparency

	v3.subTitleTextFont = v2.Typography.BodySmall.Font
	v3.subTitleTextTransparency = theme.TextDefault.Transparency
	v3.subTitleTextColor3 = theme.TextDefault.Color
	v3.subTitleTextSize = font.CaptionBody.RelativeSize * font.BaseSize

	v3.subTitleIconColor3 = style.Theme.IconDefault.Color
	v3.subTitleIconTransparency = style.Theme.IconDefault.Transparency

	v3.titleFont = v2.Typography.TitleLarge.Font
	local titleTextTransparency

	if joined.boldTitle then
		titleTextTransparency = theme.TextEmphasis.Transparency
	else
		titleTextTransparency = theme.TextDefault.Transparency
	end

	v3.titleTextTransparency = titleTextTransparency
	local titleTextColor

	if joined.boldTitle then
		titleTextColor = theme.TextEmphasis.Color
	else
		titleTextColor = theme.TextDefault.Color
	end

	v3.titleTextColor3 = titleTextColor
	v3.titleTextSize = font.Header2.RelativeSize * font.BaseSize

	v3.secondaryTitleFont = v2.Typography.TitleLarge.Font
	v3.secondaryTitleTextTransparency = theme.TextMuted.Transparency
	v3.secondaryTitleTextColor3 = theme.TextMuted.Color
	v3.secondaryTitleTextSize = font.Header2.RelativeSize * font.BaseSize

	v3.showDivider = joined.showDivider
	v3.dividerTransparency = theme.Divider.Transparency
	v3.dividerColor3 = theme.Divider.Color

	v3.avatarCircleSize = v2.Size.Size_1000
	v3.avatarCircleCellWidth = v2.Size.Size_1200
	v3.hideLeftAvatarPadding = joined.hideLeftAvatarPadding
	v3.paddingLeft = joined.paddingLeft
	v3.paddingRight = joined.paddingRight
	v3.isRobloxSubscriber = joined.isRobloxSubscriber
	return createElement(PresenceBubbleCell, v3, joined.children or {})
end

return React.memo(StyledCell)
