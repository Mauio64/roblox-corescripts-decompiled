local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")
local memoize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").memoize
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Style").GetTextSize
local PlainText = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/PlainText")
local withStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").Style.withStyle

local AssetCard = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/AssetCard")
local HiddenMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/HiddenMessage")

local EnumMessageTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/EnumMessageTypes")

local ChatMessageContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ChatMessageContainer")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Logger")

local pruneConsecutiveNewLines = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/SocialLibraries").Utils.pruneConsecutiveNewLines
local getModeratedMaskText = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getModeratedMaskText")
local FFlagAppChatEnableAutotranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatEnableAutotranslation")
local FFlagAppChatConsoleFocusFixes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatConsoleFocusFixes")
local MessageModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/MessageModel")
local ChatMessageContainerConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ChatMessageContainerConstants")

local BUBBLE_PADDING = ChatMessageContainerConstants.BUBBLE_PADDING
local TEXT_BUBBLE_X_PADDING = ChatMessageContainerConstants.TEXT_BUBBLE_X_PADDING
local TEXT_BUBBLE_X_WIDE_ADDITIONAL_PADDING = ChatMessageContainerConstants.TEXT_BUBBLE_X_WIDE_ADDITIONAL_PADDING
local v5 = {
	[EnumMessageTypes.PlainText] = { component = PlainText, name = "PlainText", paddingOffset = 0 },
	[EnumMessageTypes.Link] = { component = AssetCard, name = "AssetCard", paddingOffset = 0 }
}

local v6 = { component = HiddenMessage, name = "Hidden", paddingOffset = 0 }

local function getMessageComponent(p2)
	if p2 and p2.visibility == MessageModel.VisibilityTypes.Hidden then
		return v6
	end

	return v5[p2.messageType]
end

local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation").Hooks.useTokens

local extended = Roact.PureComponent:extend("ChatMessage")

extended.defaultProps = {
	additionalProps = {
		shareLink = nil,
		placeId = nil,
		universeId = nil,
		senderUserId = nil,
		onDetailsOpened = function() end,
		openGameDetailsPage = function() end
	},
	conversationId = nil,
	BackgroundColor3 = nil,
	content = "",
	debugElement = nil,
	displayName = nil,
	failed = false,
	filteredForReceivers = false,
	isIncoming = false,
	isNewSender = false,
	isSending = false,
	isUnfiltered = false,
	isLastMessageInMessageGroup = false,
	isLastIncomingChatMessage = false,
	messageType = nil,
	moderated = false,
	parentWidth = 0,
	senderUserId = nil,
	sent = nil,
	showDateTime = false,
	thumbnail = nil,
	Transparency = nil,
	wideMode = false,
	viewProfileOnAvatarPressed = true,
	closeKeyboard = function() end,
	inputBoxRef = nil,
	repliesTo = nil,
	translatedText = nil,
	autotranslationOriginalTextFontSize = 16,
	messageDefaultNoticeText = "PLACEHOLDER Not everyone in this chat can see your message.",
	messageModeratedNoticeText = "PLACEHOLDER Your message was moderated and not sent.",
	messageHiddenNoticeText = "PLACEHOLDER This message is not available",
	unknownUserText = "PLACEHOLDER unknown user"
}

function extended:init()
	function self.getModeratedText(p3)
		return getModeratedMaskText(self.props.messageId or p3)
	end

	function self.messageMaxWidth(p3, p4)
		local v7 = (TEXT_BUBBLE_X_PADDING + BUBBLE_PADDING) * 2

		if p3 then
			v7 += TEXT_BUBBLE_X_WIDE_ADDITIONAL_PADDING
		end

		return p4 - v7
	end

	if FFlagAppChatEnableAutotranslation then
		self.getBubbleMaxWidth = memoize(function(p3, p4, p5, p6, p7)
			if not p7 then
				return getTextSize(p4, p5, p6, Vector2.new(p3, 10000)).X + BUBBLE_PADDING * 2
			end

			local textSize = getTextSize(
				p4,
				self.props.autotranslationOriginalTextFontSize,
				p6,
				Vector2.new(p3, 10000)
			)

			local textSize2 = getTextSize(p7, p5, p6, Vector2.new(p3, 10000))
			return math.max(textSize.X, textSize2.X) + BUBBLE_PADDING * 2
		end)
	else
		self.getBubbleMaxWidth = memoize(function(p3, p4, p5, p6)
			return getTextSize(p4, p5, p6, Vector2.new(p3, 10000)).X + BUBBLE_PADDING * 2
		end)
	end
end

function extended.render(data)
	local props = data.props
	local v7

	if props and props.visibility == MessageModel.VisibilityTypes.Hidden then
		v7 = v6
	else
		v7 = v5[props.messageType]
	end

	local messageMaxWidth = data.messageMaxWidth(data.props.wideMode, data.props.parentWidth)

	if not v7 then
		Logger:warning("ChatMessage doesn't support messageType: {}", data.props.messageType)
		return nil
	end

	local v8 = pruneConsecutiveNewLines(data.props.content)

	v8 = data.props.moderated and data.getModeratedText(v8) or v8

	local content2 = data.props.repliesTo
		and data.props.repliesTo.messageType
		and data.props.repliesTo.content

	return withStyle(function(p2)
		local body = p2.Font.Body
		local v9 = p2.Font.BaseSize * body.RelativeSize

		local bodySmall = p2.Font.BodySmall
		local v10 = p2.Font.BaseSize * bodySmall.RelativeSize

		return Roact.createElement(ChatMessageContainer, Cryo.Dictionary.join(data.props, {
			messageMaxWidth = messageMaxWidth,
			messageTypePaddingOffset = v7.paddingOffset,
			messageId = data.props.messageId,
			isPending = data.props.isSending or data.props.moderated or data.props.failed,
			visibility = data.props.visibility,
			renderMessage = function(options, props2)
				local createElement = React.createElement

				local v14 = Cryo.Dictionary.join({
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1,
					Selectable = if FFlagAppChatConsoleFocusFixes then false else nil
				}, options or {})

				local createElement2 = React.createElement
				local v16 = {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = 0,
					Padding = 0
				}
				local v17 = if data.props.isIncoming then Enum.HorizontalAlignment.Left else Enum.HorizontalAlignment.Right
				v16.HorizontalAlignment = v17

				v16.Padding = UDim.new(0, 10)
				local children = {}
				children.UIListLayout = createElement2("UIListLayout", v16)
				local v18

				if content2 then
					local createElement3 = Roact.createElement
					local repliesTo = data.props.repliesTo
					v18 = createElement3(
						(if repliesTo and repliesTo.visibility == MessageModel.VisibilityTypes.Hidden then v6 else v5[repliesTo.messageType]).component,
						{
							additionalProps = data.props.additionalProps,
							font = p2.Tokens.Typography.BodyLarge.Font,
							hasTail = false,
							innerPadding = BUBBLE_PADDING,
							isIncoming = data.props.isIncoming,
							isPending = false,
							isUnfiltered = data.props.isUnfiltered,
							isRepliedTo = true,
							isLastMessageInMessageGroup = data.props.isLastMessageInMessageGroup,
							maxWidth = messageMaxWidth,
							messageDefaultNoticeText = data.props.messageDefaultNoticeText,
							messageModeratedNoticeText = data.props.messageModeratedNoticeText,
							parentWidth = data.props.parentWidth,
							text = data.props.repliesTo.content,
							textSize = v10,
							wideMode = data.props.wideMode,
							[Roact.Change.AbsoluteSize] = data.messageSizeChanged,
							LayoutOrder = 1
						}
					)
				end

				children.repliesTo = v18

				local createElement3 = React.createElement
				local messageSizeChangedsByAbsoluteSize = {
					["AutomaticSize"] = nil,
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1,
					[React.Change.AbsoluteSize] = data.messageSizeChanged,
					LayoutOrder = 2
				}

				local v20 = if props2 then props2.ref else nil
				messageSizeChangedsByAbsoluteSize.ref = v20
				local v21 = {
					["UIListLayout"] = nil,
					["UIListLayout"] = nil,
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, p2.Tokens.Size.Size_100)
					})
				}

				local v22 = if props2 then props2.Icons else nil
				v21.Icons = v22
				local name = v7.name
				local createElement4 = Roact.createElement
				local component = v7.component
				local messageSizeChangedsByAbsoluteSize2 = {}
				messageSizeChangedsByAbsoluteSize2.additionalProps = data.props.additionalProps
				messageSizeChangedsByAbsoluteSize2.font = p2.Tokens.Typography.BodyLarge.Font
				messageSizeChangedsByAbsoluteSize2.hasTail = data.props.isNewSender
				messageSizeChangedsByAbsoluteSize2.innerPadding = BUBBLE_PADDING
				messageSizeChangedsByAbsoluteSize2.isIncoming = data.props.isIncoming
				messageSizeChangedsByAbsoluteSize2.isPending = data.props.isSending
					or data.props.moderated
					or data.props.failed
				messageSizeChangedsByAbsoluteSize2.isUnfiltered = data.props.isUnfiltered
				messageSizeChangedsByAbsoluteSize2.isLastMessageInMessageGroup = data.props.isLastMessageInMessageGroup
				messageSizeChangedsByAbsoluteSize2.isLastIncomingChatMessage = data.props.isLastIncomingChatMessage
				local v23 = if props2 then props2.isPressed else nil
				messageSizeChangedsByAbsoluteSize2.isPressed = v23
				local v24 = if props2 then props2.bubbleRef else nil
				messageSizeChangedsByAbsoluteSize2.bubbleRef = v24

				local v25 = if FFlagAppChatEnableAutotranslation then data.getBubbleMaxWidth(
					messageMaxWidth,
					v8,
					v9,
					p2.Tokens.Typography.BodyLarge.Font,
					data.props.translatedText
				) else data.getBubbleMaxWidth(messageMaxWidth, v8, v9, p2.Tokens.Typography.BodyLarge.Font)
				messageSizeChangedsByAbsoluteSize2.maxWidth = v25

				messageSizeChangedsByAbsoluteSize2.messageDefaultNoticeText = data.props.messageDefaultNoticeText
				messageSizeChangedsByAbsoluteSize2.messageModeratedNoticeText = data.props.messageModeratedNoticeText
				messageSizeChangedsByAbsoluteSize2.parentWidth = data.props.parentWidth
				messageSizeChangedsByAbsoluteSize2.text = v8
				messageSizeChangedsByAbsoluteSize2.textSize = v9
				messageSizeChangedsByAbsoluteSize2.wideMode = data.props.wideMode
				messageSizeChangedsByAbsoluteSize2[Roact.Change.AbsoluteSize] = data.messageSizeChanged
				messageSizeChangedsByAbsoluteSize2.LayoutOrder = data.props.isIncoming and 1 or 2

				local v26 = if FFlagAppChatEnableAutotranslation then data.props.translatedText else nil
				messageSizeChangedsByAbsoluteSize2.translatedText = v26
				v21[name] = createElement4(component, messageSizeChangedsByAbsoluteSize2)
				children.mainMessage = createElement3("Frame", messageSizeChangedsByAbsoluteSize, v21)
				return createElement("ImageButton", v14, children)
			end
		}))
	end)
end

if FFlagAppChatEnableAutotranslation then
	return function(p2)
		local v7 = useTokens()
		return React.createElement(
			extended,
			Cryo.Dictionary.union(p2, {
				autotranslationOriginalTextFontSize = v7.Typography.BodySmall.FontSize
			})
		)
	end
end

return extended
