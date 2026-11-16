local CommonMark = script:FindFirstAncestor("CommonMark")
require(CommonMark.node.Node)
require(CommonMark.parser.beta.Position)

local LinkResult = {}
LinkResult.__index = LinkResult

LinkResult.Type = table.freeze({ WRAP = "WRAP", REPLACE = "REPLACE" })

local function new(p: string, node, position) -- 2 equivalent calls inferred from this helper
	return (setmetatable({ _type = p, _node = node, _position = position, _includeMarker = false }, LinkResult))
end

function LinkResult.none(): nil
	return nil
end

function LinkResult.wrapTextIn(node, position)
	return new(LinkResult.Type.WRAP, node, position) -- inferred equivalent call
end

function LinkResult.replaceWith(node, position)
	return new(LinkResult.Type.REPLACE, node, position) -- inferred equivalent call
end

function LinkResult:includeMarker()
	self._includeMarker = true
	return self
end

function LinkResult:getType()
	return self._type
end

function LinkResult:getNode()
	return self._node
end

function LinkResult:getPosition()
	return self._position
end

function LinkResult:isIncludeMarker()
	return self._includeMarker
end

return LinkResult
