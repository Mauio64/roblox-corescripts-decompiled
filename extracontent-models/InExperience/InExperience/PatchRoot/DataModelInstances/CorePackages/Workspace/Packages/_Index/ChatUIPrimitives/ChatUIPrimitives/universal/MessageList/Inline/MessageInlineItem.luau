local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.Signals)
local ReactUtils = require(parent.ReactUtils)
local createNextOrder = ReactUtils.createNextOrder

require(script.Parent.Parent.groupMessages)

local IdentityInline = require(script.Parent.Parent.Parent.Identity.IdentityInline)
local ReplyQuote = require(script.Parent.Parent.Reply.ReplyQuote)
local useMessageInlineViewModel = require(script.Parent.useMessageInlineViewModel)
local useFinishMessageRenderIntervals = require(script.Parent.Parent.useFinishMessageRenderIntervals)
local FFlagExpChatMessageListScrollParity = require(ChatUIPrimitives.Flags.FFlagExpChatMessageListScrollParity)
local withMessageContent = require(script.Parent.Parent.Parent.ContentKinds.withMessageContent)
local PlainTextContentModel = require(script.Parent.Parent.Parent.ContentKinds.PlainText.PlainTextContentModel)
local PlainTextInline = require(script.Parent.Parent.Parent.ContentKinds.PlainText.PlainTextInline)
local PresetContentModel = require(script.Parent.Parent.Parent.ContentKinds.Preset.PresetContentModel)
local PresetInline = require(script.Parent.Parent.Parent.ContentKinds.Preset.PresetInline)
local EmojiContentModel = require(script.Parent.Parent.Parent.ContentKinds.Emoji.EmojiContentModel)
local EmojiInline = require(script.Parent.Parent.Parent.ContentKinds.Emoji.EmojiInline)

local v = {
	plainText = withMessageContent(PlainTextInline, PlainTextContentModel.getDetail),
	preset = withMessageContent(PresetInline, PresetContentModel.getDetail),
	emoji = withMessageContent(EmojiInline, EmojiContentModel.getDetail)
}

local function MessageInlineItem(p)
	local v2 = useMessageInlineViewModel(p.itemSignal)

	if FFlagExpChatMessageListScrollParity then
		useFinishMessageRenderIntervals(p.itemSignal)
	end

	local nextOrder = createNextOrder()

	local children = {}

	for k, content in v2.contents do
		local v3 = v[content.kind]

		if v3 then
			children["content" .. k] = React.createElement(v3, {
				getContent = content.getContent,
				LayoutOrder = k
			})
		end
	end

	local children2 = {}

	if v2.hasIdentity then
		children2.Identity = React.createElement(IdentityInline, {
			getIdentity = v2.getIdentity,
			LayoutOrder = nextOrder()
		})
	end

	children2.Message = React.createElement(
		Foundation.View,
		{ tag = "col grow size-0 auto-y", LayoutOrder = nextOrder() },
		children
	)

	local createElement = React.createElement
	local view = Foundation.View
	local reply

	if v2.replyText ~= nil then
		reply = React.createElement(ReplyQuote.Inline, { text = v2.replyText, LayoutOrder = 1 })
	end

	return createElement(view, { tag = "col size-full-0 auto-y" }, {
		Reply = reply,
		Row = React.createElement(
			Foundation.View,
			{ tag = "row align-x-left gap-xsmall size-full-0 auto-y", LayoutOrder = 2 },
			children2
		)
	})
end

return MessageInlineItem
