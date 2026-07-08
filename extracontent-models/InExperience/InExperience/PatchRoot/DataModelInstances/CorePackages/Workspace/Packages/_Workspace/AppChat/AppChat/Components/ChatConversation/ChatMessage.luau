local AppChat = script:FindFirstAncestor("AppChat")

if not require(AppChat.Flags.FFlagAppChatRefactorChatMessage) then
	return require(script.Parent.ChatMessageDeprecated)
end

local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local Text = require(AppChatParent.AppCommonLib).Text
local PlainTextAutomaticSize = require(script.Parent.PlainTextAutomaticSize)
local AssetCardTempAutomaticSize = require(script.Parent.AssetCardTempAutomaticSize)
local HiddenMessage = require(script.Parent.HiddenMessage)
local EnumMessageTypes = require(AppChat.Components.ChatConversation.EnumMessageTypes)
local ChatMessageContainerAutomaticSize = require(script.Parent.ChatMessageContainerAutomaticSize)
local Logger = require(script.Parent.Logger)
local pruneConsecutiveNewLines = require(AppChat.SocialLibraries).Utils.pruneConsecutiveNewLines
local FFlagAppChatEnableAutotranslation = require(AppChat.Flags.FFlagAppChatEnableAutotranslation)
local MessageModel = require(AppChat.Models.MessageModel)
local Foundation = require(AppChatParent.Foundation)
local View = Foundation.View
local FoundationImage = Foundation.Image
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

local function getMessageComponent(p1) -- line: 51
	-- upvalues: MessageModel (copy), t2 (copy), t1 (copy)
	if p1 and p1.visibility == MessageModel.VisibilityTypes.Hidden then
		return t2
	end

	return t1[p1.messageType]
end

local useTokens = require(AppChatParent.Foundation).Hooks.useTokens
local t3 = {
	additionalProps = {
		shareLink = nil,
		placeId = nil,
		universeId = nil,
		senderUserId = nil,
		onDetailsOpened = function() -- line: 114
		end,
		openGameDetailsPage = function() -- line: 115
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
	closeKeyboard = function() -- line: 141
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

return function(t4: {[any]: any}) -- line: 153
	-- upvalues: Cryo (copy), t3 (copy), useTokens (copy), FFlagAppChatEnableAutotranslation (copy), React (copy), Text (copy), MessageModel (copy), t2 (copy), t1 (copy), pruneConsecutiveNewLines (copy), Logger (copy), View (copy), ChatMessageContainerAutomaticSize (copy), FoundationImage (copy)
	local v25 = Cryo.Dictionary.union(t3, t4)

	local function getModeratedText(p2) -- line: 158
		return string.gsub(p2, "[^%s]", "#")
	end
	local function messageMaxWidth(b1: boolean, n1: number) -- line: 162
		local n2 = 128

		if b1 then
			n2 += 112
		end

		return n1 - n2
	end

	local v28 = useTokens()
	local u29 = if not FFlagAppChatEnableAutotranslation then React.useCallback(function(p3, p4, p5, p6) -- line: 193
		-- upvalues: Text (copy)
		return Text.GetTextBounds(p4, p6, p5, Vector2.new(p3, 10000)).X + 20
	end) else React.useCallback(function(p7, p8, p9, p10, p11) -- line: 176
		-- upvalues: Text (copy), v28 (copy)
		if p11 then
			local v48 = Text.GetTextBounds(p8, p10, v28.Typography.BodySmall.FontSize, Vector2.new(p7, 10000))
			local v49 = Text.GetTextBounds(p11, p10, p9, Vector2.new(p7, 10000))

			return math.max(v48.X, v49.X) + 20
		end

		return Text.GetTextBounds(p8, p10, p9, Vector2.new(p7, 10000)).X + 20
	end)
	local v30 = if not v25 or v25.visibility ~= MessageModel.VisibilityTypes.Hidden then t1[v25.messageType] else t2
	local v31 = React.useMemo(function() -- line: 200
		-- upvalues: v25 (copy)
		local wideMode = v25.wideMode
		local parentWidth = v25.parentWidth
		local n3 = 128

		if wideMode then
			n3 += 112
		end

		return parentWidth - n3
	end, {
		messageMaxWidth,
		v25.wideMode,
		v25.parentWidth
	})
	local content = v25.content
	local v33 = pruneConsecutiveNewLines(content)
	local v34 = v25.moderated and string.gsub(v33, "[^%s]", "#") or v33
	local v35 = v25.repliesTo and (v25.repliesTo.messageType and v25.repliesTo.content)
	local BodyLarge = v28.Typography.BodyLarge
	local FontSize = BodyLarge.FontSize
	local FontSize2 = v28.Typography.BodySmall.FontSize

	if not v30 then
		Logger:warning("ChatMessage doesn't support messageType: {}", v25.messageType)

		return React.createElement(View, {})
	end

	return React.createElement(ChatMessageContainerAutomaticSize, Cryo.Dictionary.union(v25, {
		messageMaxWidth = v31,
		messageTypePaddingOffset = v30.paddingOffset,
		messageId = v25.messageId,
		isPending = v25.isSending or (v25.moderated or v25.failed),
		visibility = v25.visibility,
		renderMessage = function(p12, p13) -- line: 236
			-- upvalues: React (copy), FoundationImage (copy), Cryo (copy), v25 (copy), v35 (copy), MessageModel (copy), t2 (copy), t1 (copy), BodyLarge (copy), v31 (copy), FontSize2 (copy), View (copy), v30 (copy), FFlagAppChatEnableAutotranslation (copy), u29 (ref), v34 (copy), FontSize (copy)
			local createElement = React.createElement
			local v60 = FoundationImage
			local v61 = Cryo.Dictionary.union({
				tag = {
					["auto-xy gui-object-defaults col align-y-center"] = true,
					["align-x-left"] = v25.isIncoming,
					["align-x-right"] = not v25.isIncoming
				},
				layout = {
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, 10)
				}
			}, p12 or {})
			local t5 = {}
			local v65

			if v35 then
				local createElement2 = React.createElement
				local repliesTo = v25.repliesTo

				v65 = createElement2(((if not repliesTo or repliesTo.visibility ~= MessageModel.VisibilityTypes.Hidden then t1[repliesTo.messageType] else t2)).component, {
					hasTail = false,
					innerPadding = 10,
					isPending = false,
					isRepliedTo = true,
					LayoutOrder = 1,
					additionalProps = v25.additionalProps,
					font = BodyLarge.Font,
					isIncoming = v25.isIncoming,
					isUnfiltered = v25.isUnfiltered,
					isLastMessageInMessageGroup = v25.isLastMessageInMessageGroup,
					maxWidth = v31,
					messageDefaultNoticeText = v25.messageDefaultNoticeText,
					messageModeratedNoticeText = v25.messageModeratedNoticeText,
					parentWidth = v25.parentWidth,
					text = v25.repliesTo.content,
					textSize = FontSize2,
					wideMode = v25.wideMode
				})
			else
				v65 = nil
			end

			t5.repliesTo = v65
			t5.mainMessage = React.createElement(View, {
				tag = "row auto-xy align-y-center gap-xxsmall",
				LayoutOrder = 2,
				ref = if not p13 then nil else p13.ref
			}, {
				Icons = if not p13 then nil else p13.Icons,
				[v30.name] = React.createElement(v30.component, {
					innerPadding = 10,
					additionalProps = v25.additionalProps,
					font = BodyLarge.Font,
					hasTail = v25.isNewSender == true,
					isIncoming = v25.isIncoming,
					isPending = v25.isSending or (v25.moderated or v25.failed),
					isUnfiltered = v25.isUnfiltered,
					isLastMessageInMessageGroup = v25.isLastMessageInMessageGroup,
					isLastIncomingChatMessage = v25.isLastIncomingChatMessage,
					isPressed = if not p13 then nil else p13.isPressed,
					maxWidth = if not FFlagAppChatEnableAutotranslation then u29(v31, v34, FontSize, BodyLarge.Font) else u29(v31, v34, FontSize, BodyLarge.Font, v25.translatedText),
					messageDefaultNoticeText = v25.messageDefaultNoticeText,
					messageModeratedNoticeText = v25.messageModeratedNoticeText,
					parentWidth = v25.parentWidth,
					text = v34,
					textSize = FontSize,
					wideMode = v25.wideMode,
					LayoutOrder = not v25.isIncoming and 2 or 1,
					translatedText = if not FFlagAppChatEnableAutotranslation then nil else v25.translatedText
				})
			})

			return createElement(v60, v61, t5)
		end
	}))
end
