local EmojiContentModel = require(script.Parent.Parent.ContentKinds.Emoji.EmojiContentModel)

return {
	fromEmoji = function(p: string, p2: string?, p3: string?)
		return EmojiContentModel.fromEmoji(p, p2, p3)
	end
}
