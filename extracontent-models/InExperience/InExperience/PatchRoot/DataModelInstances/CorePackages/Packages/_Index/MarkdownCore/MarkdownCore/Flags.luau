local parent = script:FindFirstAncestor("MarkdownCore").Parent

local SafeFlags = require(parent.SafeFlags)

return {
	FFlagMarkdownAssistantParity = SafeFlags.createGetFFlag("MarkdownAssistantParity")(),
	FFlagMarkdownTables = SafeFlags.createGetFFlag("MarkdownTables")(),
	FFlagMarkdownTagFallbacks = SafeFlags.createGetFFlag("MarkdownTagFallbacks")()
}
