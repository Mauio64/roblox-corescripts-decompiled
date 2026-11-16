local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.Signals)
local ReactUtils = require(parent.ReactUtils)
local createNextOrder = ReactUtils.createNextOrder

require(script.Parent.Parent.groupMessages)

local Sizing = require(script.Parent.Parent.Parent.Sizing)
local MessageAvatar = require(script.Parent.Parent.Parent.Adornments.MessageAvatar)
local DiscussionTopLine = require(script.Parent.DiscussionTopLine)
local useMessageDiscussionViewModel = require(script.Parent.useMessageDiscussionViewModel)
local withMessageContent = require(script.Parent.Parent.Parent.ContentKinds.withMessageContent)
local PlainTextContentModel = require(script.Parent.Parent.Parent.ContentKinds.PlainText.PlainTextContentModel)
local PlainTextInline = require(script.Parent.Parent.Parent.ContentKinds.PlainText.PlainTextInline)
local EmojiContentModel = require(script.Parent.Parent.Parent.ContentKinds.Emoji.EmojiContentModel)
local EmojiInline = require(script.Parent.Parent.Parent.ContentKinds.Emoji.EmojiInline)

local v = {
	plainText = withMessageContent(PlainTextInline, PlainTextContentModel.getDetail),
	emoji = withMessageContent(EmojiInline, EmojiContentModel.getDetail)
}

local function MessageDiscussionItem(p)
	local v2 = useMessageDiscussionViewModel(p.itemSignal)
	local discussion = Sizing.useSizing().discussion
	local nextOrder = createNextOrder()
	local nextOrder2 = createNextOrder()

	local children = {}

	if v2.showIdentity then
		children.TopLine = React.createElement(DiscussionTopLine, {
			getIdentity = v2.getIdentity,
			getSentAtUnixMilliseconds = v2.getSentAtUnixMilliseconds,
			tag = discussion.topLineTag,
			nameTag = discussion.nameTag,
			timestampTag = discussion.timestampTag,
			LayoutOrder = nextOrder2(),
			testId = "discussion-top-line"
		})
	end

	for k, content in v2.contents do
		local v3 = v[content.kind]

		if v3 then
			children["content" .. k] = React.createElement(v3, {
				getContent = content.getContent,
				LayoutOrder = nextOrder2()
			})
		end
	end

	local createElement = React.createElement
	local view = Foundation.View
	local tag

	if v2.showIdentity then
		tag = discussion.headRowTag
	else
		tag = discussion.continuationRowTag
	end

	return createElement(view, { tag = tag, testId = "message-discussion-row" }, {
		Avatar = React.createElement(MessageAvatar, {
			getIdentity = v2.getIdentity,
			visible = v2.showIdentity,
			sizeTag = discussion.avatarTag,
			gutterTag = discussion.gutterTag,
			LayoutOrder = nextOrder(),
			testId = "discussion-avatar"
		}),
		Column = React.createElement(
			Foundation.View,
			{ tag = discussion.columnTag, LayoutOrder = nextOrder() },
			children
		)
	})
end

return MessageDiscussionItem
