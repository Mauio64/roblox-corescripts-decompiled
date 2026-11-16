local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.Signals)
local ReactUtils = require(parent.ReactUtils)
local createNextOrder = ReactUtils.createNextOrder

require(script.Parent.Parent.groupMessages)

local FFlagExpChatMessageAvatarAdornment = require(ChatUIPrimitives.Flags.FFlagExpChatMessageAvatarAdornment)
local MessageAvatar = require(script.Parent.Parent.Parent.Adornments.MessageAvatar)
local BubbleAvatar = require(script.Parent.BubbleAvatar)
local Sizing = require(script.Parent.Parent.Parent.Sizing)
local BubbleStyleContext = require(script.Parent.BubbleStyleContext)
local BubbleUsername = require(script.Parent.BubbleUsername)
local BubbleView = require(script.Parent.BubbleView)
local ReplyQuote = require(script.Parent.Parent.Reply.ReplyQuote)
local getBubbleTone = require(script.Parent.getBubbleTone)
local useMessageBubbleViewModel = require(script.Parent.useMessageBubbleViewModel)
local useFinishMessageRenderIntervals = require(script.Parent.Parent.useFinishMessageRenderIntervals)
local FFlagExpChatMessageListScrollParity = require(ChatUIPrimitives.Flags.FFlagExpChatMessageListScrollParity)
local withMessageContent = require(script.Parent.Parent.Parent.ContentKinds.withMessageContent)
local PlainTextContentModel = require(script.Parent.Parent.Parent.ContentKinds.PlainText.PlainTextContentModel)
local PlainTextBubble = require(script.Parent.Parent.Parent.ContentKinds.PlainText.PlainTextBubble)
local PresetContentModel = require(script.Parent.Parent.Parent.ContentKinds.Preset.PresetContentModel)
local PresetBubble = require(script.Parent.Parent.Parent.ContentKinds.Preset.PresetBubble)
local EmojiContentModel = require(script.Parent.Parent.Parent.ContentKinds.Emoji.EmojiContentModel)
local EmojiBubble = require(script.Parent.Parent.Parent.ContentKinds.Emoji.EmojiBubble)

local v = {
	plainText = withMessageContent(PlainTextBubble, PlainTextContentModel.getDetail),
	preset = withMessageContent(PresetBubble, PresetContentModel.getDetail),
	emoji = withMessageContent(EmojiBubble, EmojiContentModel.getDetail)
}

local function MessageBubbleItem(p)
	local v2 = useMessageBubbleViewModel(p.itemSignal)

	if FFlagExpChatMessageListScrollParity then
		useFinishMessageRenderIntervals(p.itemSignal)
	end

	local v3 = Foundation.Hooks.useTokens()
	local v4 = Sizing.useSizing()
	local v5 = v4.density == "compact"
	local nextOrder = createNextOrder()
	local v6 = v2.deliveryState == "sending"
	local v7 = React.useMemo(function()
		local bubbleTone = getBubbleTone(v2.isObservingUser, v3, v6)
		return {
			backgroundStyle = bubbleTone.backgroundStyle,
			style = { textStyle = bubbleTone.textStyle }
		}
	end, { v2.isObservingUser, v3, v6 })

	local children = {}

	for k, content in v2.contents do
		local v8 = v[content.kind]

		if v8 then
			children["content" .. k] = React.createElement(v8, {
				getContent = content.getContent,
				LayoutOrder = k
			})
		end
	end

	local v8 = v2.alignment == "right"
	local isFirst = v2.groupPosition.isFirst
	local nextOrder2 = createNextOrder()
	local children2 = {}

	if v2.replyText ~= nil then
		children2.Reply = React.createElement(ReplyQuote.Bubble, {
			text = v2.replyText,
			label = v2.replyLabel,
			isObservingUser = v2.isObservingUser,
			LayoutOrder = nextOrder2()
		})
	end

	if v2.showUsername then
		children2.Username = React.createElement(BubbleUsername, {
			getIdentity = v2.getIdentity,
			LayoutOrder = nextOrder2(),
			testId = "bubble-username"
		})
	end

	children2.Bubble = React.createElement(
		BubbleView,
		{
			backgroundStyle = v7.backgroundStyle,
			cornerRadii = v2.cornerRadii,
			LayoutOrder = nextOrder2(),
			testId = "message-bubble"
		},
		children
	)

	local children3 = {}

	if not v2.isObservingUser then
		if FFlagExpChatMessageAvatarAdornment then
			children3.Avatar = React.createElement(MessageAvatar, {
				getIdentity = v2.getIdentity,
				visible = v2.showAvatar,
				sizeTag = v4.avatar.tag,
				LayoutOrder = nextOrder(),
				testId = "bubble-avatar"
			})
		else
			children3.Avatar = React.createElement(BubbleAvatar, {
				getIdentity = v2.getIdentity,
				visible = v2.showAvatar,
				LayoutOrder = nextOrder(),
				testId = "bubble-avatar"
			})
		end
	end

	children3.Stack = React.createElement(Foundation.View, {
		tag = {
			["col align-x-right gap-xxsmall auto-xy"] = v8,
			["col align-x-left gap-xxsmall auto-xy"] = not v8
		},
		LayoutOrder = nextOrder()
	}, children2)

	return React.createElement(BubbleStyleContext.Context.Provider, { value = v7.style }, {
		Row = React.createElement(Foundation.View, {
			tag = {
				["size-full-0 auto-y"] = true,
				["col align-x-right"] = v8,
				["row align-x-left align-y-bottom"] = not v8,
				["gap-xsmall"] = not (v8 or v5),
				["gap-xxsmall"] = not v8 and v5,
				["padding-top-small"] = isFirst,
				["padding-top-xxsmall"] = not isFirst
			},
			testId = "message-bubble-row"
		}, children3)
	})
end

return MessageBubbleItem
