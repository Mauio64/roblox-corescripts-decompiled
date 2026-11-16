local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local t = require(parent.t)

local interface = t.interface({ text = t.string, locale = t.optional(t.string) })

return {
	isValid = t.interface({
		fallbackText = t.string,
		displayText = interface,
		translatedText = t.optional(interface),
		originalText = t.optional(interface),
		wasRewritten = t.boolean
	}),
	isValidDraft = t.strictInterface({ text = t.string })
}
