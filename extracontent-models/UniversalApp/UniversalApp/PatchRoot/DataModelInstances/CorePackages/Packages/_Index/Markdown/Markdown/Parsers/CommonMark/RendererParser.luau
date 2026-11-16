local Markdown = script:FindFirstAncestor("Markdown")
require(Markdown.Adapter)
local parentModule = require(script.Parent)
require(Markdown.Types)

local RendererParser = {}

function RendererParser.parse(p: string, p2)
	return (parentModule.toRendererAst(parentModule.parse(p), p2))
end

function RendererParser.safeParse(p: string, p2)
	if p2 == nil then
		return pcall(RendererParser.parse, p)
	end

	return pcall(RendererParser.parse, p, p2)
end

return RendererParser
