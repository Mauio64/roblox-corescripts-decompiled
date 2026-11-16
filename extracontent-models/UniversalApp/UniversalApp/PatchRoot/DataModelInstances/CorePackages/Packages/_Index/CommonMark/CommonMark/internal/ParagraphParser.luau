local CommonMark = script:FindFirstAncestor("CommonMark")
local AbstractBlockParser = require(CommonMark.parser.block.AbstractBlockParser)
local BlockContinue = require(CommonMark.parser.block.BlockContinue)
local DefinitionMap = require(CommonMark.node.DefinitionMap)
require(CommonMark.parser.InlineParser)
local LinkReferenceDefinitionParser = require(CommonMark.internal.LinkReferenceDefinitionParser)
require(CommonMark.node.Node)
local Nodes = require(CommonMark.node.Nodes)
require(CommonMark.parser.block.ParserState)
require(CommonMark.parser.SourceLine)
require(CommonMark.parser.SourceLines)
require(CommonMark.node.SourceSpan)

local object = setmetatable({}, { __index = AbstractBlockParser })
object.__index = object

function object.new(flag: boolean?)
	return (setmetatable(
		{
			_block = Nodes.Paragraph(),
			_linkReferenceDefinitionParser = LinkReferenceDefinitionParser.new(flag)
		},
		object
	))
end

function object.canHaveLazyContinuationLines(_): boolean
	return true
end

function object:getBlock()
	return self._block
end

function object.tryContinue(_, object2)
	if object2:isBlank() then
		return BlockContinue.none()
	end

	return BlockContinue.atIndex(object2:getIndex())
end

function object:addLine(p)
	self._linkReferenceDefinitionParser:parse(p)
end

function object:addSourceSpan(p)
	self._linkReferenceDefinitionParser:addSourceSpan(p)
end

function object:getDefinitions()
	local linkReferenceDefinition = DefinitionMap.new("LinkReferenceDefinition")

	for _, v in ipairs(self._linkReferenceDefinitionParser:getDefinitions()) do
		linkReferenceDefinition:putIfAbsent(v.label, v)
	end

	return table.freeze({ linkReferenceDefinition })
end

function object:closeBlock()
	for _, v in ipairs(self._linkReferenceDefinitionParser:getDefinitions()) do
		self._block:insertBefore(v)
	end

	if self._linkReferenceDefinitionParser:getParagraphLines():isEmpty() then
		self._block:unlink()
	else
		self._block:setSourceSpans(self._linkReferenceDefinitionParser:getParagraphSourceSpans())
	end
end

function object:parseInlines(object2)
	local paragraphLines = self._linkReferenceDefinitionParser:getParagraphLines()

	if not paragraphLines:isEmpty() then
		object2:parse(paragraphLines, self._block)
	end
end

function object:getParagraphLines()
	return self._linkReferenceDefinitionParser:getParagraphLines()
end

function object:removeLines(p: number)
	return self._linkReferenceDefinitionParser:removeLines(p)
end

return object
