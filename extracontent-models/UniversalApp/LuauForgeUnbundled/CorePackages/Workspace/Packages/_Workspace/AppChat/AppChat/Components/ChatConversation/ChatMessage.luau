if not require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatRefactorChatMessage") then
	return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ChatMessageDeprecated")
end

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/MomentsTypes")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Style").GetTextSize
local PlainText = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/PlainText")

local AssetCard = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/AssetCard")
local HiddenMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/HiddenMessage")

local EnumMessageTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/EnumMessageTypes")

local ChatMessageContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ChatMessageContainer")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Logger")

local pruneConsecutiveNewLines = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/SocialLibraries").Utils.pruneConsecutiveNewLines
local getModeratedMaskText = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getModeratedMaskText")
local FFlagAppChatEnableAutotranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatEnableAutotranslation")
local MessageModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/MessageModel")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local view = Foundation.View
local image = Foundation.Image

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

local v7 = {
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
	visibility = nil,
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

return function(p2)
	local union = Cryo.Dictionary.union(v7, p2)

	local function getModeratedText(p3)
		return getModeratedMaskText(union.messageId or p3)
	end

	local function messageMaxWidth(p3, p4)
		local v8 = (TEXT_BUBBLE_X_PADDING + BUBBLE_PADDING) * 2

		if p3 then
			v8 += TEXT_BUBBLE_X_WIDE_ADDITIONAL_PADDING
		end

		return p4 - v8
	end

	local v8 = useTokens()
	local v9

	if FFlagAppChatEnableAutotranslation then
		v9 = React.useCallback(function(p3, p4, p5, p6, p7)
			if not p7 then
				return getTextSize(p4, p5, p6, Vector2.new(p3, 10000)).X + BUBBLE_PADDING * 2
			end

			local textSize = getTextSize(p4, v8.Typography.BodySmall.FontSize, p6, Vector2.new(p3, 10000))

			local textSize2 = getTextSize(p7, p5, p6, Vector2.new(p3, 10000))
			return math.max(textSize.X, textSize2.X) + BUBBLE_PADDING * 2
		end)
	else
		v9 = React.useCallback(function(p3, p4, p5, p6, p7)
			return getTextSize(p4, p5, p6, Vector2.new(p3, 10000)).X + BUBBLE_PADDING * 2
		end)
	end

	local v10

	if union and union.visibility == MessageModel.VisibilityTypes.Hidden then
		v10 = v6
	else
		v10 = v5[union.messageType]
	end

	local v11 = React.useMemo(function()
		local wideMode = union.wideMode
		local parentWidth = union.parentWidth
		local v12 = (TEXT_BUBBLE_X_PADDING + BUBBLE_PADDING) * 2

		if wideMode then
			v12 += TEXT_BUBBLE_X_WIDE_ADDITIONAL_PADDING
		end

		return parentWidth - v12
	end, { messageMaxWidth, union.wideMode, union.parentWidth })

	local v12 = pruneConsecutiveNewLines(union.content)
	v12 = union.moderated and getModeratedMaskText(union.messageId or v12) or v12

	local content2 = union.repliesTo and union.repliesTo.messageType and union.repliesTo.content

	local bodyLarge = v8.Typography.BodyLarge
	local fontSize = bodyLarge.FontSize

	local fontSize2 = v8.Typography.BodySmall.FontSize

	if v10 then
		return React.createElement(ChatMessageContainer, Cryo.Dictionary.union(union, {
			messageMaxWidth = v11,
			messageTypePaddingOffset = v10.paddingOffset,
			messageId = union.messageId,
			isPending = union.isSending or union.moderated or union.failed,
			visibility = union.visibility,
			renderMessage = function(options, props)
				local createElement = React.createElement

				local union2 = Cryo.Dictionary.union({
					tag = {
						["auto-xy gui-object-defaults col align-y-center"] = true,
						["align-x-left"] = union.isIncoming,
						["align-x-right"] = not union.isIncoming
					},
					layout = {
						FillDirection = Enum.FillDirection.Vertical,
						Padding = UDim.new(0, 10)
					}
				}, options or {})
				local v15

				if content2 then
					local createElement2 = React.createElement
					local repliesTo = union.repliesTo
					local v16

					if repliesTo and repliesTo.visibility == MessageModel.VisibilityTypes.Hidden then
						v16 = v6
					else
						v16 = v5[repliesTo.messageType]
					end

					v15 = createElement2(v16.component, {
						additionalProps = union.additionalProps,
						font = bodyLarge.Font,
						hasTail = false,
						innerPadding = BUBBLE_PADDING,
						isIncoming = union.isIncoming,
						isPending = false,
						isUnfiltered = union.isUnfiltered,
						isRepliedTo = true,
						isLastMessageInMessageGroup = union.isLastMessageInMessageGroup,
						maxWidth = v11,
						messageDefaultNoticeText = union.messageDefaultNoticeText,
						messageModeratedNoticeText = union.messageModeratedNoticeText,
						parentWidth = union.parentWidth,
						text = union.repliesTo.content,
						textSize = fontSize2,
						wideMode = union.wideMode,
						LayoutOrder = 1
					})
				end

				local createElement2 = React.createElement

				local v18 = if props then props.ref else nil

				local v20 = if props then props.Icons else nil
				local name = v10.name
				local createElement3 = React.createElement
				local component = v10.component
				local v21 = {
					additionalProps = union.additionalProps,
					font = bodyLarge.Font,
					hasTail = union.isNewSender == true,
					innerPadding = BUBBLE_PADDING,
					isIncoming = union.isIncoming,
					isPending = union.isSending or union.moderated or union.failed,
					isUnfiltered = union.isUnfiltered,
					isLastMessageInMessageGroup = union.isLastMessageInMessageGroup,
					isLastIncomingChatMessage = union.isLastIncomingChatMessage,
					isPressed = 0,
					bubbleRef = 0,
					maxWidth = 0,
					messageDefaultNoticeText = 0,
					messageModeratedNoticeText = 0,
					parentWidth = 0,
					text = 0,
					textSize = 0,
					wideMode = 0,
					LayoutOrder = 0,
					translatedText = 0
				}
				local v22 = if props then props.isPressed else nil
				v21.isPressed = v22
				local v23 = if props then props.bubbleRef else nil
				v21.bubbleRef = v23

				local v24 = if FFlagAppChatEnableAutotranslation then v9(v11, v12, fontSize, bodyLarge.Font, union.translatedText) else v9(v11, v12, fontSize, bodyLarge.Font)
				v21.maxWidth = v24

				v21.messageDefaultNoticeText = union.messageDefaultNoticeText
				v21.messageModeratedNoticeText = union.messageModeratedNoticeText
				v21.parentWidth = union.parentWidth
				v21.text = v12
				v21.textSize = fontSize
				v21.wideMode = union.wideMode
				v21.LayoutOrder = union.isIncoming and 1 or 2

				local v25 = if FFlagAppChatEnableAutotranslation then union.translatedText else nil
				v21.translatedText = v25
				return createElement(image, union2, {
					repliesTo = v15,
					mainMessage = createElement2(
						view,
						{
							tag = "row auto-xy align-y-center gap-xxsmall",
							LayoutOrder = 2,
							ref = v18
						},
						{ Icons = v20, [name] = createElement3(component, v21) }
					)
				})
			end
		}))
	end

	Logger:warning("ChatMessage doesn't support messageType: {}", union.messageType)
	return React.createElement(view, {})
end
