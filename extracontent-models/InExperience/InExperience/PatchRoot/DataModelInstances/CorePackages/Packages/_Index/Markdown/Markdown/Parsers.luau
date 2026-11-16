local lazyMembers = require(script.Parent.lazyMembers)

local Parsers = {
	CommonMark = nil,
	CommonMarkComplianceParser = require(script.CommonMarkComplianceParser),
	RobloxMarkdown = nil,
	WikiMarkdownParser = require(script.WikiMarkdownParser)
}
lazyMembers(Parsers, {
	CommonMark = function()
		return require(script.CommonMark.RendererParser)
	end,
	RobloxMarkdown = function()
		return require(script.RobloxMarkdown.RendererParser)
	end
})

return Parsers
