local parent = script:FindFirstAncestor("Markdown").Parent

local SafeFlags = require(parent.SafeFlags)

return {
	FFlagMarkdownUseRobloxProfileParser = SafeFlags.createGetFFlag("MarkdownUseRobloxProfileParser")(),
	FFlagMarkdownDefaultRobloxProfile = SafeFlags.createGetFFlag("MarkdownDefaultRobloxProfile")(),
	FFlagMarkdownFormattingTags = SafeFlags.createGetFFlag("MarkdownFormattingTags")()
}
