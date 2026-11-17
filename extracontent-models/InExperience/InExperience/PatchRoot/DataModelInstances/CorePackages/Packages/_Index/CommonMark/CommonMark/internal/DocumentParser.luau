local CommonMark = script:FindFirstAncestor("CommonMark")
require(CommonMark.parser.block.BlockParser)
require(CommonMark.parser.block.BlockParserFactory)
local BlockQuoteParser = require(CommonMark.internal.BlockQuoteParser)
require(CommonMark.parser.block.BlockStart)
local Characters = require(CommonMark.text.Characters)
local Definitions = require(CommonMark.internal.Definitions)
require(CommonMark.parser.delimiter.DelimiterProcessor)
local DocumentBlockParser = require(CommonMark.internal.DocumentBlockParser)
local FencedCodeBlockParser = require(CommonMark.internal.FencedCodeBlockParser)
local HeadingParser = require(CommonMark.internal.HeadingParser)
local HtmlBlockParser = require(CommonMark.internal.HtmlBlockParser)
local IncludeSourceSpans = require(CommonMark.parser.IncludeSourceSpans)
local IndentedCodeBlockParser = require(CommonMark.internal.IndentedCodeBlockParser)
require(CommonMark.parser.beta.InlineContentParserFactory)
local InlineParserContextImpl = require(CommonMark.internal.InlineParserContextImpl)
require(CommonMark.parser.InlineParserFactory)
local Integer = require(CommonMark.internal.port.Integer)
local LineReader = require(CommonMark.internal.util.LineReader)
require(CommonMark.parser.beta.LinkProcessor)
local ListBlockParser = require(CommonMark.internal.ListBlockParser)
require(CommonMark.parser.block.MatchedBlockParser)
require(CommonMark.node.Nodes)
local ParagraphParser = require(CommonMark.internal.ParagraphParser)
require(CommonMark.parser.block.ParserState)
local Parsing = require(CommonMark.internal.util.Parsing)
local SourceLine = require(CommonMark.parser.SourceLine)
local SourceLines = require(CommonMark.parser.SourceLines)
local SourceSpan = require(CommonMark.node.SourceSpan)
local ThematicBreakParser = require(CommonMark.internal.ThematicBreakParser)

local byte = string.byte
local find = string.find
local gsub = string.gsub
local rep = string.rep
local sub = string.sub

local defaultBlockParserTypes = {
	"BlockQuote",
	"Heading",
	"FencedCodeBlock",
	"HtmlBlock",
	"ThematicBreak",
	"ListBlock",
	"IndentedCodeBlock"
}

local frozen = table.freeze({
	BlockQuote = BlockQuoteParser.Factory.new(),
	Heading = HeadingParser.Factory.new(),
	FencedCodeBlock = FencedCodeBlockParser.Factory.new(),
	HtmlBlock = HtmlBlockParser.Factory.new(),
	ThematicBreak = ThematicBreakParser.Factory.new(),
	ListBlock = ListBlockParser.Factory.new(),
	IndentedCodeBlock = IndentedCodeBlockParser.Factory.new()
})

local class = {}
class.__index = class

function class.new(matchedBlockParser)
	return (setmetatable({ _matchedBlockParser = matchedBlockParser }, class))
end

function class:getMatchedBlockParser()
	return self._matchedBlockParser
end

local function isParagraphParser(p): boolean -- 2 equivalent calls inferred from this helper
	return getmetatable(p) == ParagraphParser
end

function class:getParagraphLines()
	if isParagraphParser(self._matchedBlockParser) then -- inferred equivalent call
		return self._matchedBlockParser:getParagraphLines()
	end

	return SourceLines.empty()
end

local class2 = {}
class2.__index = class2

function class2.new(blockParser, sourceIndex: number)
	return (setmetatable({ _blockParser = blockParser, _sourceIndex = sourceIndex }, class2))
end

local DocumentParser = {}
DocumentParser.__index = DocumentParser

function DocumentParser.new(blockParserFactories, inlineParserFactory, inlineContentParserFactories, delimiterProcessors, linkProcessors, linkMarkers, includeSourceSpans, maxOpenBlockParsers: number, maxInlineNesting: number, enabledInlineTypes, flag: boolean?)
	local self = setmetatable({
		_line = nil,
		_lineIndex = -1,
		_index = 0,
		_column = 0,
		_columnIsInTab = false,
		_nextNonSpace = 0,
		_nextNonSpaceColumn = 0,
		_indent = 0,
		_blank = false,
		_blockParserFactories = blockParserFactories,
		_inlineParserFactory = inlineParserFactory,
		_inlineContentParserFactories = inlineContentParserFactories,
		_delimiterProcessors = delimiterProcessors,
		_linkProcessors = linkProcessors,
		_linkMarkers = linkMarkers,
		_includeSourceSpans = includeSourceSpans,
		_maxOpenBlockParsers = maxOpenBlockParsers,
		_maxInlineNesting = maxInlineNesting,
		_enabledInlineTypes = enabledInlineTypes,
		_linkReferenceDefinitions = flag ~= false,
		_documentBlockParser = DocumentBlockParser.new(),
		_definitions = Definitions.new(),
		_openBlockParsers = {},
		_allBlockParsers = {}
	}, DocumentParser)

	self:activateBlockParser(class2.new(self._documentBlockParser, 0))
	return self
end

function DocumentParser.getDefaultBlockParserTypes()
	return defaultBlockParserTypes
end

function DocumentParser.calculateBlockParserFactories(p, list)
	local clone = table.clone(p)

	for _, item in ipairs(list) do
		table.insert(clone, frozen[item])
	end

	return clone
end

function DocumentParser.checkEnabledBlockTypes(list)
	for _, item in ipairs(list) do
		if frozen[item] ~= nil then
			continue
		end

		local joined = table.concat(defaultBlockParserTypes, ", ")
		error(`Can't enable block type {item}, possible options are: [{joined}]`)
	end
end

function DocumentParser:parse(value: string)
	local v = 0
	local v2 = Characters.findLineBreak(value, v)

	while v2 ~= -1 do
		self:parseLine(sub(value, v + 1, v2), v)

		if v2 + 1 < #value then
			if byte(value, v2 + 1) == 13 then
				if byte(value, v2 + 1 + 1) == 10 then
					v = v2 + 2
				else
					v = v2 + 1
				end
			else
				v = v2 + 1
			end
		else
			v = v2 + 1
		end

		v2 = Characters.findLineBreak(value, v)
	end

	if value ~= "" and (v == 0 or v < #value) then
		self:parseLine(sub(value, v + 1), v)
	end

	return self:finalizeAndProcess()
end

function DocumentParser:parseReader(p: string)
	local v = LineReader.new(p)

	local v2 = v:readLine()
	local total = 0

	while v2 ~= nil do
		self:parseLine(v2, total)
		total += #v2
		local lineTerminator = v:getLineTerminator()

		if lineTerminator ~= nil then
			total += #lineTerminator
		end

		v2 = v:readLine()
	end

	return self:finalizeAndProcess()
end

function DocumentParser:getLine()
	return self._line
end

function DocumentParser:getIndex()
	return self._index
end

function DocumentParser:getNextNonSpaceIndex()
	return self._nextNonSpace
end

function DocumentParser:getColumn()
	return self._column
end

function DocumentParser:getIndent()
	return self._indent
end

function DocumentParser:isBlank()
	return self._blank
end

function DocumentParser:getActiveBlockParser()
	local openBlockParsers = self._openBlockParsers
	return openBlockParsers[#openBlockParsers - 1 + 1]._blockParser
end

function DocumentParser:parseLine(p: string, p2: number)
	self:setLine(p, p2)

	local openBlockParsers = self._openBlockParsers
	local v = 1

	for i = 1, #openBlockParsers - 1 do
		local openBlockParser = openBlockParsers[i + 1]
		local blockParser = openBlockParser._blockParser
		self:findNextNonSpace()

		local v2 = blockParser:tryContinue(self)

		if v2 == nil then
			break
		end

		openBlockParser._sourceIndex = self:getIndex()

		if v2:isFinalize() then
			self:addSourceSpans()
			self:closeBlockParsers(#openBlockParsers - i)
			return
		end

		if v2:getNewIndex() == -1 then
			if v2:getNewColumn() ~= -1 then
				self:setNewColumn(v2:getNewColumn())
			end
		else
			self:setNewIndex(v2:getNewIndex())
		end

		v += 1
	end

	local v2 = #openBlockParsers - v
	local v3 = openBlockParsers[v - 1 + 1]._blockParser
	local v4 = false

	local index = self._index
	local v5

	if v3:getBlock().kind == "Paragraph" then
		v5 = true
	else
		v5 = v3:isContainer()
	end

	while v5 do
		index = self._index
		self:findNextNonSpace()

		if
			self:isBlank()
			or self._indent < Parsing.CODE_BLOCK_INDENT
			and Characters.isLetter(self._line:getContent(), self._nextNonSpace)
		then
			self:setNewIndex(self._nextNonSpace)
			break
		end

		local blockStart = self:findBlockStart(v3)

		if blockStart == nil then
			self:setNewIndex(self._nextNonSpace)
			break
		end

		v4 = true
		local index2 = self:getIndex()

		if v2 > 0 then
			self:closeBlockParsers(v2)
			v2 = 0
		end

		if blockStart:getNewIndex() == -1 then
			if blockStart:getNewColumn() ~= -1 then
				self:setNewColumn(blockStart:getNewColumn())
			end
		else
			self:setNewIndex(blockStart:getNewIndex())
		end

		local v6 = nil

		if blockStart:getReplaceParagraphLines() >= 1 or blockStart:isReplaceActiveBlockParser() then
			local activeBlockParser = self:getActiveBlockParser()

			if isParagraphParser(activeBlockParser) then -- inferred equivalent call
				local v7

				if blockStart:isReplaceActiveBlockParser() then
					v7 = Integer.MAX_VALUE
				else
					v7 = blockStart:getReplaceParagraphLines()
				end

				v6 = self:replaceParagraphLines(v7, activeBlockParser)
			elseif blockStart:isReplaceActiveBlockParser() then
				v6 = self:prepareActiveBlockParserForReplacement(activeBlockParser)
			end
		end

		for _, v7 in ipairs(blockStart:getBlockParsers()) do
			self:addChild(class2.new(v7, index2))

			if v6 ~= nil then
				v7:getBlock():setSourceSpans(v6)
			end

			v5 = v7:isContainer()
			v3 = v7
		end
	end

	if v4 or self:isBlank() or not self:getActiveBlockParser():canHaveLazyContinuationLines() then
		if v2 > 0 then
			self:closeBlockParsers(v2)
		end

		if not v3:isContainer() then
			self:addLine()
			return
		end

		if self:isBlank() then
			self:addSourceSpans()

			return
		end

		local v6 = ParagraphParser.new(self._linkReferenceDefinitions)
		self:addChild(class2.new(v6, index))
		self:addLine()
	else
		openBlockParsers[#openBlockParsers - 1 + 1]._sourceIndex = index

		self:addLine()
	end
end

local function prepareLine(value: string) -- 1 equivalent call inferred from this helper
	if find(value, "\0", 1, true) == nil then
		return value
	end

	return (gsub(value, "%z", "�"))
end

function DocumentParser:setLine(list: string, p: number)
	self._lineIndex += 1
	self._index = 0
	self._column = 0
	self._columnIsInTab = false
	list = prepareLine(list) -- inferred equivalent call
	local v

	if self._includeSourceSpans ~= IncludeSourceSpans.NONE then
		v = SourceSpan.of(self._lineIndex, 0, p, #list)
	end

	self._line = SourceLine.of(list, v)
end

function DocumentParser:findNextNonSpace()
	local index = self._index
	local column = self._column

	self._blank = true
	local content = self._line:getContent()
	local v = #content

	while index < v do
		local v2 = byte(content, index + 1)

		if v2 == 32 then
			index += 1
			column += 1
		elseif v2 == 9 then
			index += 1
			column += 4 - column % 4
		else
			self._blank = false
			break
		end
	end

	self._nextNonSpace = index
	self._nextNonSpaceColumn = column
	self._indent = self._nextNonSpaceColumn - self._column
end

function DocumentParser:setNewIndex(p: number)
	if self._nextNonSpace <= p then
		self._index = self._nextNonSpace
		self._column = self._nextNonSpaceColumn
	end

	local v = #self._line:getContent()

	while self._index < p and self._index ~= v do
		self:advance()
	end

	self._columnIsInTab = false
end

function DocumentParser:setNewColumn(column: number)
	if self._nextNonSpaceColumn <= column then
		self._index = self._nextNonSpace
		self._column = self._nextNonSpaceColumn
	end

	local v = #self._line:getContent()

	while self._column < column and self._index ~= v do
		self:advance()
	end

	if not (column < self._column) then
		self._columnIsInTab = false

		return
	end

	self._index -= 1
	self._column = column
	self._columnIsInTab = true
end

function DocumentParser:advance()
	local v = byte(self._line:getContent(), self._index + 1)
	self._index += 1

	if v == 9 then
		self._column += Parsing.columnsToNextTabStop(self._column)
	else
		self._column += 1
	end
end

function DocumentParser:addLine()
	local line = self._line
	local index = self._index
	local v

	if self._columnIsInTab then
		local v2 = index + 1
		local v3 = sub(line:getContent(), v2 + 1, #line:getContent())
		v = rep(" ", (Parsing.columnsToNextTabStop(self._column))) .. v3
	elseif index == 0 then
		v = line:getContent()
	else
		v = sub(line:getContent(), index + 1, #line:getContent())
	end

	local v2 = nil

	if self._includeSourceSpans == IncludeSourceSpans.BLOCKS_AND_INLINES then
		local sourceSpan = line:getSourceSpan()

		if index < sourceSpan:getLength() then
			v2 = sourceSpan:subSpan(index)
		end
	end

	self:getActiveBlockParser():addLine(SourceLine.of(v, v2))
	self:addSourceSpans()
end

function DocumentParser:addSourceSpans()
	if self._includeSourceSpans ~= IncludeSourceSpans.NONE then
		local openBlockParsers = self._openBlockParsers
		local line = self._line

		for i = 1, #openBlockParsers - 1 do
			local openBlockParser = openBlockParsers[i + 1]

			local v = math.min(openBlockParser._sourceIndex, self._index)

			if #line:getContent() - v ~= 0 then
				openBlockParser._blockParser:addSourceSpan(line:getSourceSpan():subSpan(v))
			end
		end
	end
end

function DocumentParser:findBlockStart(p)
	if #self._openBlockParsers > self._maxOpenBlockParsers then
		return nil
	end

	local v = class.new(p)

	for _, blockParserFactory in ipairs(self._blockParserFactories) do
		local v2 = blockParserFactory:tryStart(self, v)

		if v2 ~= nil then
			return v2
		end
	end

	return nil
end

function DocumentParser:processInlines()
	local v = InlineParserContextImpl.new(
		self._inlineContentParserFactories,
		self._delimiterProcessors,
		self._linkProcessors,
		self._linkMarkers,
		self._maxInlineNesting,
		self._definitions,
		self._enabledInlineTypes
	)

	local v2 = self._inlineParserFactory:create(v)

	for _, allBlockParser in ipairs(self._allBlockParsers) do
		allBlockParser:parseInlines(v2)
	end
end

function DocumentParser:addChild(p)
	while not self:getActiveBlockParser():canContain(p._blockParser:getBlock()) do
		self:closeBlockParsers(1)
	end

	self:getActiveBlockParser():getBlock():appendChild(p._blockParser:getBlock())
	self:activateBlockParser(p)
end

function DocumentParser:activateBlockParser(p)
	table.insert(self._openBlockParsers, p)
end

function DocumentParser:deactivateBlockParser()
	return (table.remove(self._openBlockParsers))
end

function DocumentParser:replaceParagraphLines(p: number, object)
	local v = object:removeLines(p)

	self:closeBlockParsers(1)
	return v
end

function DocumentParser:prepareActiveBlockParserForReplacement(object)
	self:deactivateBlockParser()

	object:closeBlock()
	object:getBlock():unlink()
	return object:getBlock():getSourceSpans()
end

function DocumentParser:finalizeAndProcess()
	self:closeBlockParsers(#self._openBlockParsers)
	self:processInlines()
	return self._documentBlockParser:getBlock()
end

function DocumentParser:closeBlockParsers(p: number)
	for _ = 0, p - 1 do
		local blockParser = self:deactivateBlockParser()._blockParser
		self:finalize(blockParser)

		table.insert(self._allBlockParsers, blockParser)
	end
end

function DocumentParser:finalize(object)
	self:addDefinitionsFrom(object)
	object:closeBlock()
end

function DocumentParser:addDefinitionsFrom(object)
	for _, v in ipairs(object:getDefinitions()) do
		self._definitions:addDefinitions(v)
	end
end

return DocumentParser
