local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local Roact = require(parent.Roact)
local AppCommonLib = require(parent.AppCommonLib)
local Text = AppCommonLib.Text
local AppCommonLib2 = require(parent.AppCommonLib)
local memoize = AppCommonLib2.memoize
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize
local PlainText = require(script.Parent.PlainText)
local UIBlox = require(parent.UIBlox)

local withStyle = UIBlox.Style.withStyle

local AssetCard = require(script.Parent.AssetCard)
local HiddenMessage = require(script.Parent.HiddenMessage)

local EnumMessageTypes = require(AppChat.Components.ChatConversation.EnumMessageTypes)

local ChatMessageContainer = require(script.Parent.ChatMessageContainer)
local Logger = require(script.Parent.Logger)

local SocialLibraries = require(AppChat.SocialLibraries)
local pruneConsecutiveNewLines = SocialLibraries.Utils.pruneConsecutiveNewLines
local getModeratedMaskText = require(AppChat.Utils.getModeratedMaskText)
local FFlagAppChatEnableAutotranslation = require(AppChat.Flags.FFlagAppChatEnableAutotranslation)
local FFlagAppChatConsoleFocusFixes = require(AppChat.Flags.FFlagAppChatConsoleFocusFixes)
local Foundation = require(parent.Foundation)
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local MessageModel = require(AppChat.Models.MessageModel)
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
	function self.getModeratedText(p)
		return getModeratedMaskText(self.props.messageId or p)
	end

	function self.messageMaxWidth(flag: boolean, p: number)
		local v3 = (TEXT_BUBBLE_X_PADDING + BUBBLE_PADDING) * 2

		if flag then
			v3 += TEXT_BUBBLE_X_WIDE_ADDITIONAL_PADDING
		end

		return p - v3
	end

	if FFlagAppChatEnableAutotranslation then
		self.getBubbleMaxWidth = memoize(function(p, p2, p3, p4, p5)
			if p5 then
				local v3

				if FoundationFontFaceMigration then
					v3 = GetTextSize(p2, self.props.autotranslationOriginalTextFontSize, p4, Vector2.new(p, 10000))
				else
					v3 = Text.GetTextBounds(
						p2,
						p4,
						self.props.autotranslationOriginalTextFontSize,
						Vector2.new(p, 10000)
					)
				end

				local v4

				if FoundationFontFaceMigration then
					v4 = GetTextSize(p5, p3, p4, Vector2.new(p, 10000))
				else
					v4 = Text.GetTextBounds(p5, p4, p3, Vector2.new(p, 10000))
				end

				return math.max(v3.X, v4.X) + BUBBLE_PADDING * 2
			else
				local v3

				if FoundationFontFaceMigration then
					v3 = GetTextSize(p2, p3, p4, Vector2.new(p, 10000))
				else
					v3 = Text.GetTextBounds(p2, p4, p3, Vector2.new(p, 10000))
				end

				return v3.X + BUBBLE_PADDING * 2
			end
		end)
	else
		self.getBubbleMaxWidth = memoize(function(p, p2, p3, p4)
			local v3

			if FoundationFontFaceMigration then
				v3 = GetTextSize(p2, p3, p4, Vector2.new(p, 10000))
			else
				v3 = Text.GetTextBounds(p2, p4, p3, Vector2.new(p, 10000))
			end

			return v3.X + BUBBLE_PADDING * 2
		end)
	end
end

function extended.render(data)
	local messageComponent = getMessageComponent(data.props) -- inferred equivalent call
	local messageMaxWidth = data.messageMaxWidth(data.props.wideMode, data.props.parentWidth)

	if not messageComponent then
		Logger:warning("ChatMessage doesn't support messageType: {}", data.props.messageType)
		return nil
	end

	local text = pruneConsecutiveNewLines(data.props.content)

	text = data.props.moderated and data.getModeratedText(text) or text

	local content = data.props.repliesTo and data.props.repliesTo.messageType and data.props.repliesTo.content

	return withStyle(function(p)
		local body = p.Font.Body
		local textSize = p.Font.BaseSize * body.RelativeSize

		local bodySmall = p.Font.BodySmall
		local textSize2 = p.Font.BaseSize * bodySmall.RelativeSize

		return Roact.createElement(ChatMessageContainer, Cryo.Dictionary.join(data.props, {
			messageMaxWidth = messageMaxWidth,
			messageTypePaddingOffset = messageComponent.paddingOffset,
			messageId = data.props.messageId,
			isPending = data.props.isSending or data.props.moderated or data.props.failed,
			visibility = data.props.visibility,
			renderMessage = function(options, props)
				local createElement = React.createElement

				local v3 = Cryo.Dictionary.join({
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1,
					Selectable = not FFlagAppChatConsoleFocusFixes and nil
				}, options or {})

				local createElement2 = React.createElement
				local v4 = {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = 0,
					Padding = 0
				}
				local horizontalAlignment

				if data.props.isIncoming then
					horizontalAlignment = Enum.HorizontalAlignment.Left
				else
					horizontalAlignment = Enum.HorizontalAlignment.Right
				end

				v4.HorizontalAlignment = horizontalAlignment

				v4.Padding = UDim.new(0, 10)
				local children = {}
				children.UIListLayout = createElement2("UIListLayout", v4)
				local repliesTo

				if content then
					local createElement3 = Roact.createElement
					local component = getMessageComponent(data.props.repliesTo).component -- inferred equivalent call
					local messageSizeChangedsByAbsoluteSize = {}
					messageSizeChangedsByAbsoluteSize.additionalProps = data.props.additionalProps
					local font

					if FoundationFontFaceMigration then
						font = p.Tokens.Typography.BodyLarge.Font
					else
						font = body.Font
					end

					messageSizeChangedsByAbsoluteSize.font = font

					messageSizeChangedsByAbsoluteSize.hasTail = false
					messageSizeChangedsByAbsoluteSize.innerPadding = BUBBLE_PADDING
					messageSizeChangedsByAbsoluteSize.isIncoming = data.props.isIncoming
					messageSizeChangedsByAbsoluteSize.isPending = false
					messageSizeChangedsByAbsoluteSize.isUnfiltered = data.props.isUnfiltered
					messageSizeChangedsByAbsoluteSize.isRepliedTo = true
					messageSizeChangedsByAbsoluteSize.isLastMessageInMessageGroup = data.props.isLastMessageInMessageGroup
					messageSizeChangedsByAbsoluteSize.maxWidth = messageMaxWidth
					messageSizeChangedsByAbsoluteSize.messageDefaultNoticeText = data.props.messageDefaultNoticeText
					messageSizeChangedsByAbsoluteSize.messageModeratedNoticeText = data.props.messageModeratedNoticeText
					messageSizeChangedsByAbsoluteSize.parentWidth = data.props.parentWidth
					messageSizeChangedsByAbsoluteSize.text = data.props.repliesTo.content
					messageSizeChangedsByAbsoluteSize.textSize = textSize2
					messageSizeChangedsByAbsoluteSize.wideMode = data.props.wideMode
					messageSizeChangedsByAbsoluteSize[Roact.Change.AbsoluteSize] = data.messageSizeChanged
					messageSizeChangedsByAbsoluteSize.LayoutOrder = 1
					repliesTo = createElement3(component, messageSizeChangedsByAbsoluteSize)
				end

				children.repliesTo = repliesTo

				local createElement3 = React.createElement
				local messageSizeChangedsByAbsoluteSize = {
					["AutomaticSize"] = nil,
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1,
					[React.Change.AbsoluteSize] = data.messageSizeChanged,
					LayoutOrder = 2
				}
				local ref

				if props then
					ref = props.ref
				end

				messageSizeChangedsByAbsoluteSize.ref = ref
				local v5 = {
					["UIListLayout"] = nil,
					["UIListLayout"] = nil,
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, p.Tokens.Size.Size_100)
					})
				}
				local icons

				if props then
					icons = props.Icons
				end

				v5.Icons = icons
				local name = messageComponent.name
				local createElement4 = Roact.createElement
				local component = messageComponent.component
				local messageSizeChangedsByAbsoluteSize2 = {}
				messageSizeChangedsByAbsoluteSize2.additionalProps = data.props.additionalProps
				local font

				if FoundationFontFaceMigration then
					font = p.Tokens.Typography.BodyLarge.Font
				else
					font = body.Font
				end

				messageSizeChangedsByAbsoluteSize2.font = font

				messageSizeChangedsByAbsoluteSize2.hasTail = data.props.isNewSender
				messageSizeChangedsByAbsoluteSize2.innerPadding = BUBBLE_PADDING
				messageSizeChangedsByAbsoluteSize2.isIncoming = data.props.isIncoming
				messageSizeChangedsByAbsoluteSize2.isPending = data.props.isSending
					or data.props.moderated
					or data.props.failed
				messageSizeChangedsByAbsoluteSize2.isUnfiltered = data.props.isUnfiltered
				messageSizeChangedsByAbsoluteSize2.isLastMessageInMessageGroup = data.props.isLastMessageInMessageGroup
				messageSizeChangedsByAbsoluteSize2.isLastIncomingChatMessage = data.props.isLastIncomingChatMessage
				local isPressed

				if props then
					isPressed = props.isPressed
				end

				messageSizeChangedsByAbsoluteSize2.isPressed = isPressed
				local bubbleRef

				if props then
					bubbleRef = props.bubbleRef
				end

				messageSizeChangedsByAbsoluteSize2.bubbleRef = bubbleRef
				local maxWidth

				if FFlagAppChatEnableAutotranslation then
					local getBubbleMaxWidth = data.getBubbleMaxWidth
					local v6

					if FoundationFontFaceMigration then
						v6 = p.Tokens.Typography.BodyLarge.Font
					else
						v6 = body.Font
					end

					maxWidth = getBubbleMaxWidth(messageMaxWidth, text, textSize, v6, data.props.translatedText)
				else
					local getBubbleMaxWidth = data.getBubbleMaxWidth
					local v6

					if FoundationFontFaceMigration then
						v6 = p.Tokens.Typography.BodyLarge.Font
					else
						v6 = body.Font
					end

					maxWidth = getBubbleMaxWidth(messageMaxWidth, text, textSize, v6)
				end

				messageSizeChangedsByAbsoluteSize2.maxWidth = maxWidth

				messageSizeChangedsByAbsoluteSize2.messageDefaultNoticeText = data.props.messageDefaultNoticeText
				messageSizeChangedsByAbsoluteSize2.messageModeratedNoticeText = data.props.messageModeratedNoticeText
				messageSizeChangedsByAbsoluteSize2.parentWidth = data.props.parentWidth
				messageSizeChangedsByAbsoluteSize2.text = text
				messageSizeChangedsByAbsoluteSize2.textSize = textSize
				messageSizeChangedsByAbsoluteSize2.wideMode = data.props.wideMode
				messageSizeChangedsByAbsoluteSize2[Roact.Change.AbsoluteSize] = data.messageSizeChanged
				messageSizeChangedsByAbsoluteSize2.LayoutOrder = data.props.isIncoming and 1 or 2
				local translatedText

				if FFlagAppChatEnableAutotranslation then
					translatedText = data.props.translatedText
				end

				messageSizeChangedsByAbsoluteSize2.translatedText = translatedText
				v5[name] = createElement4(component, messageSizeChangedsByAbsoluteSize2)
				children.mainMessage = createElement3("Frame", messageSizeChangedsByAbsoluteSize, v5)
				return createElement("ImageButton", v3, children)
			end
		}))
	end)
end

if FFlagAppChatEnableAutotranslation then
	return function(p)
		local v3 = useTokens()
		return React.createElement(
			extended,
			Cryo.Dictionary.union(p, {
				autotranslationOriginalTextFontSize = v3.Typography.BodySmall.FontSize
			})
		)
	end
end

return extended
