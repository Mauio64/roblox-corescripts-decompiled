local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local t = require(parent.t)

return {
	isValid = t.interface({
		fallbackText = t.string,
		presetId = t.string,
		presetVersion = t.optional(t.string),
		displayText = t.string
	}),
	isValidDraft = t.strictInterface({ presetId = t.string, displayText = t.string })
}
