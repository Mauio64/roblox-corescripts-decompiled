local Markdown = script:FindFirstAncestor("Markdown")
local parent = Markdown.Parent
local parentModule = require(script.Parent)
local CommonMark = require(parent.CommonMark)
require(Markdown.Types)

local function createParser(p)
	local v = (p == nil or p.extensions == nil) and {} or p.extensions
	local parseOptions = (p == nil or p.parserOptions == nil) and {} or table.clone(p.parserOptions)
	local extensions

	if parseOptions.extensions == nil then
		extensions = v
	else
		extensions = table.clone(parseOptions.extensions)
		table.move(v, 1, #v, #extensions + 1, extensions)
		table.freeze(extensions)
	end

	parseOptions.extensions = extensions

	table.freeze(parseOptions)
	local v2 = parentModule.build(extensions)

	local parser = {}
	parser.parseOptions = parseOptions
	function parser.parseDocument(p2: string)
		return CommonMark.parse(p2, parseOptions)
	end

	function parser.toRendererAst(p2, p3)
		return v2.toRendererAst(p2, p3)
	end

	function parser.parse(p2: string, p3)
		return (parser.toRendererAst(parser.parseDocument(p2), p3))
	end

	function parser.safeParse(p2: string, p3)
		if p3 == nil then
			return pcall(parser.parse, p2)
		end

		return pcall(parser.parse, p2, p3)
	end

	return parser
end

return createParser
