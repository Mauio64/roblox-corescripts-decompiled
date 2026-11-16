local AppChat = script:FindFirstAncestor("AppChat")
local FFlagAppChatRefactorChatMessage = require(AppChat.Flags.FFlagAppChatRefactorChatMessage)

if not FFlagAppChatRefactorChatMessage then
	return require(script.Parent.ChatMessageDeprecated)
end

local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
require(parent.MomentsTypes)
local React = require(parent.React)
local AppCommonLib = require(parent.AppCommonLib)
local Text = AppCommonLib.Text
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize
local PlainText = require(script.Parent.PlainText)

local AssetCard = require(script.Parent.AssetCard)
local HiddenMessage = require(script.Parent.HiddenMessage)

local EnumMessageTypes = require(AppChat.Components.ChatConversation.EnumMessageTypes)

local ChatMessageContainer = require(script.Parent.ChatMessageContainer)
local Logger = require(script.Parent.Logger)

local SocialLibraries = require(AppChat.SocialLibraries)
local pruneConsecutiveNewLines = SocialLibraries.Utils.pruneConsecutiveNewLines
local getModeratedMaskText = require(AppChat.Utils.getModeratedMaskText)
local FFlagAppChatEnableAutotranslation = require(AppChat.Flags.FFlagAppChatEnableAutotranslation)
local MessageModel = require(AppChat.Models.MessageModel)

local Foundation = require(parent.Foundation)
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local View = Foundation.View
local Image = Foundation.Image

local ChatMessageContainerConstants = require(script.Parent.ChatMessageContainerConstants)

local BUBBLE_PADDING = ChatMessageContainerConstants.BUBBLE_PADDING
local TEXT_BUBBLE_X_PADDING = ChatMessageContainerConstants.TEXT_BUBBLE_X_PADDING
local TEXT_BUBBLE_X_WIDE_ADDITIONAL_PADDING = ChatMessageContainerConstants.TEXT_BUBBLE_X_WIDE_ADDITIONAL_PADDING
local v = {
	[EnumMessageTypes.PlainText] = { component = PlainText, name = "PlainText", paddingOffset = 0 },
	[EnumMessageTypes.Link] = { component = AssetCard, name = "AssetCard", paddingOffset = 0 }
}

local v2 = { component = HiddenMessage, name = "Hidden", paddingOffset = 0 }

local function getMessageComponent(p) -- 2 equivalent calls inferred from this helper
	if p and p.visibility == MessageModel.VisibilityTypes.Hidden then
		return v2
	end

	return v[p.messageType]
end

local Foundation2 = require(parent.Foundation)
local useTokens = Foundation2.Hooks.useTokens

local v3 = {
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

return function(p)
	local union = Cryo.Dictionary.union(v3, p)

	local function getModeratedText(p2) -- 1 equivalent call inferred from this helper
		return getModeratedMaskText(union.messageId or p2)
	end

	local function messageMaxWidth(wideMode: boolean, parentWidth: number) -- 1 equivalent call inferred from this helper
		local v4 = (TEXT_BUBBLE_X_PADDING + BUBBLE_PADDING) * 2

		if wideMode then
			v4 += TEXT_BUBBLE_X_WIDE_ADDITIONAL_PADDING
		end

		return parentWidth - v4
	end

	local v4 = useTokens()
	local v5

	if FFlagAppChatEnableAutotranslation then
		v5 = React.useCallback(function(p2: number, p3: string, p4: number, p5, p6: string?)
			if p6 then
				local v6

				if FoundationFontFaceMigration then
					v6 = GetTextSize(p3, v4.Typography.BodySmall.FontSize, p5, Vector2.new(p2, 10000))
				else
					v6 = Text.GetTextBounds(p3, p5, v4.Typography.BodySmall.FontSize, Vector2.new(p2, 10000))
				end

				local v7

				if FoundationFontFaceMigration then
					v7 = GetTextSize(p6, p4, p5, Vector2.new(p2, 10000))
				else
					v7 = Text.GetTextBounds(p6, p5, p4, Vector2.new(p2, 10000))
				end

				return math.max(v6.X, v7.X) + BUBBLE_PADDING * 2
			else
				local v6

				if FoundationFontFaceMigration then
					v6 = GetTextSize(p3, p4, p5, Vector2.new(p2, 10000))
				else
					v6 = Text.GetTextBounds(p3, p5, p4, Vector2.new(p2, 10000))
				end

				return v6.X + BUBBLE_PADDING * 2
			end
		end)
	else
		v5 = React.useCallback(function(p2: number, p3: string, p4: number, p5, _: string?)
			local v6

			if FoundationFontFaceMigration then
				v6 = GetTextSize(p3, p4, p5, Vector2.new(p2, 10000))
			else
				v6 = Text.GetTextBounds(p3, p5, p4, Vector2.new(p2, 10000))
			end

			return v6.X + BUBBLE_PADDING * 2
		end)
	end

	local messageComponent = getMessageComponent(union) -- inferred equivalent call
	local v6 = React.useMemo(function()
		return messageMaxWidth(union.wideMode, union.parentWidth) -- inferred equivalent call
	end, { messageMaxWidth, union.wideMode, union.parentWidth })

	local text = pruneConsecutiveNewLines(union.content)

	text = union.moderated and getModeratedText(text) or text -- inferred equivalent call

	local content = union.repliesTo and union.repliesTo.messageType and union.repliesTo.content

	local bodyLarge = v4.Typography.BodyLarge
	local fontSize = bodyLarge.FontSize

	local fontSize2 = v4.Typography.BodySmall.FontSize

	if messageComponent then
		return React.createElement(ChatMessageContainer, Cryo.Dictionary.union(union, {
			messageMaxWidth = v6,
			messageTypePaddingOffset = messageComponent.paddingOffset,
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
				local repliesTo

				if content then
					repliesTo = React.createElement(getMessageComponent(union.repliesTo).component, { -- inferred equivalent call
						additionalProps = union.additionalProps,
						font = bodyLarge.Font,
						hasTail = false,
						innerPadding = BUBBLE_PADDING,
						isIncoming = union.isIncoming,
						isPending = false,
						isUnfiltered = union.isUnfiltered,
						isRepliedTo = true,
						isLastMessageInMessageGroup = union.isLastMessageInMessageGroup,
						maxWidth = v6,
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
				local ref

				if props then
					ref = props.ref
				end

				local icons

				if props then
					icons = props.Icons
				end

				local name = messageComponent.name
				local createElement3 = React.createElement
				local component = messageComponent.component
				local v7 = {
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
				local isPressed

				if props then
					isPressed = props.isPressed
				end

				v7.isPressed = isPressed
				local bubbleRef

				if props then
					bubbleRef = props.bubbleRef
				end

				v7.bubbleRef = bubbleRef
				local maxWidth

				if FFlagAppChatEnableAutotranslation then
					maxWidth = v5(v6, text, fontSize, bodyLarge.Font, union.translatedText)
				else
					maxWidth = v5(v6, text, fontSize, bodyLarge.Font)
				end

				v7.maxWidth = maxWidth

				v7.messageDefaultNoticeText = union.messageDefaultNoticeText
				v7.messageModeratedNoticeText = union.messageModeratedNoticeText
				v7.parentWidth = union.parentWidth
				v7.text = text
				v7.textSize = fontSize
				v7.wideMode = union.wideMode
				v7.LayoutOrder = union.isIncoming and 1 or 2
				local translatedText

				if FFlagAppChatEnableAutotranslation then
					translatedText = union.translatedText
				end

				v7.translatedText = translatedText
				return createElement(Image, union2, {
					repliesTo = repliesTo,
					mainMessage = createElement2(
						View,
						{
							tag = "row auto-xy align-y-center gap-xxsmall",
							LayoutOrder = 2,
							ref = ref
						},
						{ Icons = icons, [name] = createElement3(component, v7) }
					)
				})
			end
		}))
	end

	Logger:warning("ChatMessage doesn't support messageType: {}", union.messageType)
	return React.createElement(View, {})
end
