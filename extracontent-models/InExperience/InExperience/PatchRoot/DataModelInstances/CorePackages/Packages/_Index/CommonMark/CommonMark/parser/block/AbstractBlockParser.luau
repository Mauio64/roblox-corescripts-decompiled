local CommonMark = script:FindFirstAncestor("CommonMark")
require(CommonMark.parser.block.BlockParser)
require(CommonMark.node.DefinitionMap)
require(CommonMark.parser.InlineParser)
require(CommonMark.node.Node)
require(CommonMark.parser.SourceLine)
require(CommonMark.node.SourceSpan)

local frozen = table.freeze({})
local AbstractBlockParser = {}

function AbstractBlockParser.isContainer(_): boolean
	return false
end

function AbstractBlockParser.canHaveLazyContinuationLines(_): boolean
	return false
end

function AbstractBlockParser.canContain(_, _): boolean
	return false
end

function AbstractBlockParser.addLine(_, _) end

function AbstractBlockParser:addSourceSpan(p)
	self:getBlock():addSourceSpan(p)
end

function AbstractBlockParser.getDefinitions(_)
	return frozen
end

function AbstractBlockParser.closeBlock(_) end

function AbstractBlockParser.parseInlines(_, _) end

return AbstractBlockParser
