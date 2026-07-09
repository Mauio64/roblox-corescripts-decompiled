local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Cryo = require(AppChatParent.Cryo)

require(AppChatParent.UIBlox)

local SocialLibraries = require(AppChat.SocialLibraries)
local PresenceBubbleCell = require(script.Parent.PresenceBubbleCell)
local TestStyle = SocialLibraries.Components.TestStyle
local t1 = {
	avatarCirclePresenceImage = nil,
	subTitleText = nil,
	subTitleIcon = nil,
	titleText = "TestUser",
	secondaryTitleText = nil,
	childWidth = 0,
	showDivider = true,
	boldTitle = true,
	shouldMuteTitleColor = false,
	isLoading = false,
	hideLeftAvatarPadding = false,
	Size = UDim2.new(1, 0, 1, 0),
	thumbnails = {},
	style = TestStyle
}

local function StyledCell(t2: {[any]: any}) -- line: 62
	-- upvalues: Cryo (copy), t1 (copy), React (copy), PresenceBubbleCell (copy)
	local v11 = Cryo.Dictionary.join(t1, t2)
	local style = v11.style
	local Theme = style.Theme
	local styleFont = style.Font
	local FontSize_350 = style.Tokens.FontSize.FontSize_350
	local FontSize_400 = style.Tokens.FontSize.FontSize_400
	local v17 = type(v11.avatarCirclePresenceImage) == "table"

	return React.createElement(PresenceBubbleCell, {
		childWidth = v11.childWidth,
		titleText = v11.titleText,
		secondaryTitleText = v11.secondaryTitleText,
		subTitleText = v11.subTitleText,
		subTitleIcon = v11.subTitleIcon,
		avatarCirclePresenceImage = v11.avatarCirclePresenceImage,
		thumbnails = v11.thumbnails,
		onActivated = v11.onActivated,
		onCircleActivated = v11.onCircleActivated,
		Size = v11.Size,
		isLoading = v11.isLoading,
		showNewPresenceImage = v17,
		pillText = v11.pillText,
		BackgroundColor3 = Theme.BackgroundDefault.Color,
		BackgroundTransparency = Theme.BackgroundDefault.Transparency,
		onPressedBackgroundColor3 = Theme.BackgroundOnPress.Color,
		onPressedBackgroundTransparency = Theme.BackgroundOnPress.Transparency,
		avatarCircleBackgroundColor3 = Theme.PlaceHolder.Color,
		avatarCircleDividerColor3 = Theme.PlaceHolder.Color,
		avatarCircleCellWidth = 72,
		avatarCircleSize = 48,
		avatarCirclePresenceImageColor3 = if not v17 then nil else Theme.OnlineStatus.Color,
		avatarCirclePresenceImageTransparency = if not v17 then nil else Theme.OnlineStatus.Transparency,
		subTitleTextFont = styleFont.CaptionBody.Font,
		subTitleTextTransparency = Theme.TextDefault.Transparency,
		subTitleTextColor3 = Theme.TextDefault.Color,
		subTitleTextSize = FontSize_400,
		titleFont = styleFont.Header2.Font,
		titleTextTransparency = if not v11.shouldMuteTitleColor and v11.boldTitle then Theme.TextEmphasis.Transparency else Theme.TextDefault.Transparency,
		titleTextColor3 = if not v11.shouldMuteTitleColor and v11.boldTitle then Theme.TextEmphasis.Color else Theme.TextDefault.Color,
		titleTextSize = FontSize_350,
		secondaryTitleFont = styleFont.Header2.Font,
		secondaryTitleTextTransparency = Theme.TextMuted.Transparency,
		secondaryTitleTextColor3 = Theme.TextMuted.Color,
		secondaryTitleTextSize = FontSize_350,
		showDivider = v11.showDivider,
		dividerTransparency = Theme.Divider.Transparency,
		dividerColor3 = Theme.Divider.Color,
		hideLeftAvatarPadding = v11.hideLeftAvatarPadding
	}, v11.children or {})
end

return React.memo(StyledCell)
