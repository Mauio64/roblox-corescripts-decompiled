local CommonMark = script:FindFirstAncestor("CommonMark")
local Node = require(CommonMark.node.Node)

local function Text(literal: string?)
	local text = Node.new("Text", false)
	text.literal = literal
	return text
end

function Node.toStringAttributesByKind.Text(p)
	return "literal=" .. (p.literal == nil and "null" or p.literal)
end

return Text
