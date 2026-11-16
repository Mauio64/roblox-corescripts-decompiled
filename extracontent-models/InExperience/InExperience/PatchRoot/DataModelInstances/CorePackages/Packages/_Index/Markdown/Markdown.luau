local Flags = require(script.Flags)
require(script.Components.MarkdownViewer)
require(script.Enums.NodeType)
require(script.Types)
local lazyMembers = require(script.lazyMembers)

local function profile() -- 4 equivalent calls inferred from this helper
	return require(script.Parsers.RobloxMarkdown)
end

local Markdown = {
	Components = require(script.Components),
	Enums = require(script.Enums),
	Parsers = require(script.Parsers),
	Utils = require(script.Utils),
	parse = nil,
	safeParse = nil,
	toRendererAst = function(p)
		return (profile().toRendererAst(p)) -- inferred equivalent call
	end,
	parseOptions = nil,
	createParser = nil,
	Adapter = nil,
	Flags = Flags
}
lazyMembers(Markdown, {
	parse = function()
		return profile().parse -- inferred equivalent call
	end,
	safeParse = function()
		return profile().safeParse -- inferred equivalent call
	end,
	parseOptions = function()
		return profile().parseOptions -- inferred equivalent call
	end,
	createParser = function()
		return require(script.Adapter.createParser)
	end,
	Adapter = function()
		local Adapter = require(script.Adapter)
		return table.freeze({ Rules = Adapter.Rules })
	end
})

return Markdown
