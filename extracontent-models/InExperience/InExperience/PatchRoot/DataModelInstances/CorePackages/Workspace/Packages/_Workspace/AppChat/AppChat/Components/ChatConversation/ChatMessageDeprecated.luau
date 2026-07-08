local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local Roact = require(AppChatParent.Roact)
local Text = require(AppChatParent.AppCommonLib).Text
local memoize = require(AppChatParent.AppCommonLib).memoize
local PlainTextAutomaticSize = require(script.Parent.PlainTextAutomaticSize)
local withStyle = require(AppChatParent.UIBlox).Style.withStyle
local AssetCardTempAutomaticSize = require(script.Parent.AssetCardTempAutomaticSize)
local HiddenMessage = require(script.Parent.HiddenMessage)
local EnumMessageTypes = require(AppChat.Components.ChatConversation.EnumMessageTypes)
local ChatMessageContainerAutomaticSize = require(script.Parent.ChatMessageContainerAutomaticSize)
local Logger = require(script.Parent.Logger)
local pruneConsecutiveNewLines = require(AppChat.SocialLibraries).Utils.pruneConsecutiveNewLines
local FFlagAppChatEnableAutotranslation = require(AppChat.Flags.FFlagAppChatEnableAutotranslation)
local MessageModel = require(AppChat.Models.MessageModel)
local t1 = {
	[EnumMessageTypes.PlainText] = {
		name = "PlainText",
		paddingOffset = 0,
		component = PlainTextAutomaticSize
	},
	[EnumMessageTypes.Link] = {
		name = "AssetCard",
		paddingOffset = 0,
		component = AssetCardTempAutomaticSize
	}
}
local t2 = {
	name = "Hidden",
	paddingOffset = 0,
	component = HiddenMessage
}

local function getMessageComponent(p1) -- line: 47
	-- upvalues: MessageModel (copy), t2 (copy), t1 (copy)
	if p1 and p1.visibility == MessageModel.VisibilityTypes.Hidden then
		return t2
	end

	return t1[p1.messageType]
end

local useTokens = require(AppChatParent.Foundation).Hooks.useTokens
local v22 = Roact.PureComponent:extend("ChatMessage")

v22.defaultProps = {
	additionalProps = {
		shareLink = nil,
		placeId = nil,
		universeId = nil,
		senderUserId = nil,
		onDetailsOpened = function() -- line: 65
		end,
		openGameDetailsPage = function() -- line: 66
		end
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
	closeKeyboard = function() -- line: 91
	end,
	inputBoxRef = nil,
	repliesTo = nil,
	translatedText = nil,
	autotranslationOriginalTextFontSize = 16,
	messageDefaultNoticeText = "PLACEHOLDER Not everyone in this chat can see your message.",
	messageModeratedNoticeText = "PLACEHOLDER Your message was moderated and not sent.",
	messageHiddenNoticeText = "PLACEHOLDER This message is not available",
	unknownUserText = "PLACEHOLDER unknown user"
}

function v22.init(p2) -- line: 103
	-- upvalues: FFlagAppChatEnableAutotranslation (copy), memoize (copy), Text (copy)
	function p2.getModeratedText(p3) -- line: 104
		return string.gsub(p3, "[^%s]", "#")
	end
	function p2.messageMaxWidth(b1: boolean, n1: number) -- line: 108
		local n2 = 128

		if b1 then
			n2 += 112
		end

		return n1 - n2
	end

	if FFlagAppChatEnableAutotranslation then
		p2.getBubbleMaxWidth = memoize(function(p4, p5, p6, p7, p8) -- line: 119
			-- upvalues: Text (copy), p2 (copy)
			if p8 then
				local v44 = Text.GetTextBounds(p5, p7, p2.props.autotranslationOriginalTextFontSize, Vector2.new(p4, 10000))
				local v45 = Text.GetTextBounds(p8, p7, p6, Vector2.new(p4, 10000))

				return math.max(v44.X, v45.X) + 20
			end

			return Text.GetTextBounds(p5, p7, p6, Vector2.new(p4, 10000)).X + 20
		end)

		return
	end

	p2.getBubbleMaxWidth = memoize(function(p9, p10, p11, p12) -- line: 136
		-- upvalues: Text (copy)
		return Text.GetTextBounds(p10, p12, p11, Vector2.new(p9, 10000)).X + 20
	end)
end
function v22.render(p13) -- line: 143
	-- upvalues: MessageModel (copy), t2 (copy), t1 (copy), Logger (copy), pruneConsecutiveNewLines (copy), withStyle (copy), Roact (copy), ChatMessageContainerAutomaticSize (copy), Cryo (copy), React (copy), FFlagAppChatEnableAutotranslation (copy)
	local props = p13.props
	local v27 = if not props or props.visibility ~= MessageModel.VisibilityTypes.Hidden then t1[props.messageType] else t2
	local v28 = p13.messageMaxWidth(p13.props.wideMode, p13.props.parentWidth)

	if not v27 then
		Logger:warning("ChatMessage doesn't support messageType: {}", p13.props.messageType)

		return nil
	end

	local content = p13.props.content
	local v30 = pruneConsecutiveNewLines(content)
	local v31 = p13.props.moderated and p13.getModeratedText(v30) or v30
	local v32 = p13.props.repliesTo and (p13.props.repliesTo.messageType and p13.props.repliesTo.content)

	return withStyle(function(p14) -- line: 162
		-- upvalues: Roact (copy), ChatMessageContainerAutomaticSize (copy), Cryo (copy), p13 (copy), v28 (copy), v27 (copy), React (copy), v32 (copy), MessageModel (copy), t2 (copy), t1 (copy), FFlagAppChatEnableAutotranslation (copy), v31 (copy)
		local Body = p14.Font.Body
		local v52 = p14.Font.BaseSize * Body.RelativeSize
		local BodySmall = p14.Font.BodySmall
		local v54 = p14.Font.BaseSize * BodySmall.RelativeSize

		return Roact.createElement(ChatMessageContainerAutomaticSize, Cryo.Dictionary.join(p13.props, {
			messageMaxWidth = v28,
			messageTypePaddingOffset = v27.paddingOffset,
			messageId = p13.props.messageId,
			isPending = p13.props.isSending or (p13.props.moderated or p13.props.failed),
			visibility = p13.props.visibility,
			renderMessage = function(p15, p16) -- line: 182
				-- upvalues: React (copy), Cryo (copy), p13 (copy), v32 (copy), Roact (copy), MessageModel (copy), t2 (copy), t1 (copy), Body (copy), v28 (copy), v54 (copy), p14 (copy), v27 (copy), FFlagAppChatEnableAutotranslation (copy), v31 (copy), v52 (copy)
				local createElement = React.createElement
				local v58 = Cryo.Dictionary.join({
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY
				}, p15 or {})
				local t3 = {
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = if not p13.props.isIncoming then Enum.HorizontalAlignment.Right else Enum.HorizontalAlignment.Left,
						Padding = UDim.new(0, 10)
					})
				}
				local v62

				if v32 then
					local createElement2 = Roact.createElement
					local repliesTo = p13.props.repliesTo

					v62 = createElement2(((if not repliesTo or repliesTo.visibility ~= MessageModel.VisibilityTypes.Hidden then t1[repliesTo.messageType] else t2)).component, {
						additionalProps = p13.props.additionalProps,
						font = Body.Font,
						hasTail = false,
						innerPadding = 10,
						isIncoming = p13.props.isIncoming,
						isPending = false,
						isUnfiltered = p13.props.isUnfiltered,
						isRepliedTo = true,
						isLastMessageInMessageGroup = p13.props.isLastMessageInMessageGroup,
						maxWidth = v28,
						messageDefaultNoticeText = p13.props.messageDefaultNoticeText,
						messageModeratedNoticeText = p13.props.messageModeratedNoticeText,
						parentWidth = p13.props.parentWidth,
						text = p13.props.repliesTo.content,
						textSize = v54,
						wideMode = p13.props.wideMode,
						[Roact.Change.AbsoluteSize] = p13.messageSizeChanged,
						LayoutOrder = 1
					})
				else
					v62 = nil
				end

				t3.repliesTo = v62
				t3.mainMessage = React.createElement("Frame", {
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1,
					[React.Change.AbsoluteSize] = p13.messageSizeChanged,
					LayoutOrder = 2,
					ref = if not p16 then nil else p16.ref
				}, {
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, p14.Tokens.Size.Size_100)
					}),
					Icons = if not p16 then nil else p16.Icons,
					[v27.name] = Roact.createElement(v27.component, {
						additionalProps = p13.props.additionalProps,
						font = Body.Font,
						hasTail = p13.props.isNewSender,
						innerPadding = 10,
						isIncoming = p13.props.isIncoming,
						isPending = p13.props.isSending or (p13.props.moderated or p13.props.failed),
						isUnfiltered = p13.props.isUnfiltered,
						isLastMessageInMessageGroup = p13.props.isLastMessageInMessageGroup,
						isLastIncomingChatMessage = p13.props.isLastIncomingChatMessage,
						isPressed = if not p16 then nil else p16.isPressed,
						maxWidth = if not FFlagAppChatEnableAutotranslation then p13.getBubbleMaxWidth(v28, v31, v52, Body.Font) else p13.getBubbleMaxWidth(v28, v31, v52, Body.Font, p13.props.translatedText),
						messageDefaultNoticeText = p13.props.messageDefaultNoticeText,
						messageModeratedNoticeText = p13.props.messageModeratedNoticeText,
						parentWidth = p13.props.parentWidth,
						text = v31,
						textSize = v52,
						wideMode = p13.props.wideMode,
						[Roact.Change.AbsoluteSize] = p13.messageSizeChanged,
						LayoutOrder = not p13.props.isIncoming and 2 or 1,
						translatedText = if not FFlagAppChatEnableAutotranslation then nil else p13.props.translatedText
					})
				})

				return createElement("ImageButton", v58, t3)
			end
		}))
	end)
end

if FFlagAppChatEnableAutotranslation then
	return function(p17) -- line: 284
		-- upvalues: useTokens (copy), React (copy), v22 (copy), Cryo (copy)
		local v34 = useTokens()

		return React.createElement(v22, Cryo.Dictionary.union(p17, {
			autotranslationOriginalTextFontSize = v34.Typography.BodySmall.FontSize
		}))
	end
end

return v22
