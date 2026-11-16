local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local t = require(parent.t)

return {
	isValid = t.interface({
		emojiId = t.string,
		unicode = t.optional(t.string),
		name = t.optional(t.string),
		fallbackText = t.optional(t.string)
	}),
	isValidDraft = t.strictInterface({ emojiId = t.string, unicode = t.string })
}
