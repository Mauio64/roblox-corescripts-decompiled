local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Cryo = require(AppChatParent.Cryo)

require(AppChatParent.UIBlox)

local SocialLibraries = require(AppChat.SocialLibraries)
local useTokens = require(AppChatParent.Foundation).Hooks.useTokens
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local FFlagAppChatRemoveConversationListDivider = require(AppChat.Flags.FFlagAppChatRemoveConversationListDivider)
local PresenceBubbleCell = require(script.Parent.PresenceBubbleCell)
local TestStyle = SocialLibraries.Components.TestStyle
local t1 = {
	avatarCirclePresenceImage = nil,
	subTitleText = nil,
	subTitleIcon = nil,
	titleText = "TestUser",
	secondaryTitleText = nil,
	conversationId = nil,
	childWidth = 0,
	boldTitle = true,
	isLoading = false,
	hideLeftAvatarPadding = false,
	paddingLeft = 0,
	paddingRight = 0,
	Size = UDim2.new(1, 0, 1, 0),
	thumbnails = {},
	style = Cryo.Dictionary.join(TestStyle, {
		Tokens = {
			Color = {
				None = {}
			}
		}
	}),
	showDivider = not FFlagAppChatRemoveConversationListDivider
}

local function StyledCell(t2: {[any]: any}) -- line: 73
	-- upvalues: useTokens (copy), Cryo (copy), t1 (copy), React (copy), PresenceBubbleCell (copy), FFlagDebugAppChatEnableDomLocators (copy)
	local v14 = useTokens()
	local v15 = Cryo.Dictionary.join(t1, t2)
	local style = v15.style
	local Theme = style.Theme
	local styleFont = style.Font
	local v19 = type(v15.avatarCirclePresenceImage) == "table"

	return React.createElement(PresenceBubbleCell, {
		childWidth = v15.childWidth,
		titleText = v15.titleText,
		secondaryTitleText = v15.secondaryTitleText,
		subTitleText = v15.subTitleText,
		subTitleTimestamp = v15.subTitleTimestamp,
		subTitleIcon = v15.subTitleIcon,
		testId = if not FFlagDebugAppChatEnableDomLocators then nil else v15.testId,
		avatarCirclePresenceImage = v15.avatarCirclePresenceImage,
		thumbnails = v15.thumbnails,
		onActivated = v15.onActivated,
		onCircleActivated = v15.onCircleActivated,
		Size = v15.Size,
		isLoading = v15.isLoading,
		showNewPresenceImage = v19,
		conversationId = v15.conversationId,
		BackgroundColor3 = Theme.BackgroundDefault.Color,
		BackgroundTransparency = style.Tokens.Color.None.Transparency,
		onPressedBackgroundColor3 = Theme.BackgroundOnPress.Color,
		onPressedBackgroundTransparency = Theme.BackgroundOnPress.Transparency,
		avatarCircleBackgroundColor3 = Theme.PlaceHolder.Color,
		avatarCircleDividerColor3 = Theme.PlaceHolder.Color,
		avatarCirclePresenceImageColor3 = if not v19 then nil else Theme.OnlineStatus.Color,
		avatarCirclePresenceImageTransparency = if not v19 then nil else Theme.OnlineStatus.Transparency,
		subTitleTextFont = styleFont.CaptionBody.Font,
		subTitleTextTransparency = Theme.TextDefault.Transparency,
		subTitleTextColor3 = Theme.TextDefault.Color,
		subTitleTextSize = styleFont.CaptionBody.RelativeSize * styleFont.BaseSize,
		subTitleIconColor3 = style.Theme.IconDefault.Color,
		subTitleIconTransparency = style.Theme.IconDefault.Transparency,
		titleFont = styleFont.Header2.Font,
		titleTextTransparency = if v15.boldTitle then Theme.TextEmphasis.Transparency else Theme.TextDefault.Transparency,
		titleTextColor3 = if v15.boldTitle then Theme.TextEmphasis.Color else Theme.TextDefault.Color,
		titleTextSize = styleFont.Header2.RelativeSize * styleFont.BaseSize,
		secondaryTitleFont = styleFont.Header2.Font,
		secondaryTitleTextTransparency = Theme.TextMuted.Transparency,
		secondaryTitleTextColor3 = Theme.TextMuted.Color,
		secondaryTitleTextSize = styleFont.Header2.RelativeSize * styleFont.BaseSize,
		showDivider = v15.showDivider,
		dividerTransparency = Theme.Divider.Transparency,
		dividerColor3 = Theme.Divider.Color,
		avatarCircleSize = v14.Size.Size_1000,
		avatarCircleCellWidth = v14.Size.Size_1200,
		hideLeftAvatarPadding = v15.hideLeftAvatarPadding,
		paddingLeft = v15.paddingLeft,
		paddingRight = v15.paddingRight,
		isRobloxSubscriber = v15.isRobloxSubscriber
	}, v15.children or {})
end

return React.memo(StyledCell)
