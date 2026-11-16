local Markdown = script:FindFirstAncestor("Markdown")
local DefaultParserOptions = require(Markdown.Parsers.DefaultParserOptions)
local NodeType = require(Markdown.Enums.NodeType)
require(Markdown.Types)

local nodeConfiguration = DefaultParserOptions.nodeConfiguration

local frozen = table.freeze({ [NodeType.InlineSpan] = true, [NodeType.InlineLeaf] = true })

local frozen2 = table.freeze({ [NodeType.Root] = true, [NodeType.Block] = true })

local RendererNodes = {}

function RendererNodes.create(name: string)
	local v = nodeConfiguration[name]

	if v == nil then
		error(`{name} isn't a renderer node`)
	end

	return { name = name, type = v.type, children = {}, offset = 0 }
end

function RendererNodes.offsetAt(p, p2, p3: number): number
	if frozen[p2.type] or p.type == NodeType.Root and p3 == 1 then
		return 0
	end

	return 1
end

function RendererNodes.append(p, p2: string, attributes)
	local v = RendererNodes.create(p2)
	v.attributes = attributes
	local children = p.children
	local v2 = #children + 1
	children[v2] = v
	v.index = v2
	v.offset = RendererNodes.offsetAt(p, v, v2)
	return v
end

function RendererNodes.appendText(p, text: string)
	local v = RendererNodes.append(p, "TEXT")
	v.text = text
	return v
end

function RendererNodes.isInline(p): boolean
	return frozen[p.type] == true
end

function RendererNodes.holdsBlocks(p): boolean
	return frozen2[p.type] == true
end

return RendererNodes
