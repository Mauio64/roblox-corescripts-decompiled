local CommonMark = script:FindFirstAncestor("CommonMark")
require(CommonMark.node.Node)
require(CommonMark.parser.beta.Position)

local ParsedInline = {}
ParsedInline.__index = ParsedInline

function ParsedInline.none(): nil
	return nil
end

function ParsedInline.of(node, position)
	return (setmetatable({ _node = node, _position = position }, ParsedInline))
end

function ParsedInline:getNode()
	return self._node
end

function ParsedInline:getPosition()
	return self._position
end

return ParsedInline
