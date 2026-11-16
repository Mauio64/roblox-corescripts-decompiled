local CommonMark = script:FindFirstAncestor("CommonMark")
require(CommonMark.parser.block.BlockParser)

local BlockStart = {}
BlockStart.__index = BlockStart

function BlockStart.none(): nil
	return nil
end

function BlockStart.of(...)
	return (setmetatable({
		_blockParsers = { ... },
		_newIndex = -1,
		_newColumn = -1,
		_replaceActiveBlockParser = false,
		_replaceParagraphLines = 0
	}, BlockStart))
end

function BlockStart:getBlockParsers()
	return self._blockParsers
end

function BlockStart:getNewIndex()
	return self._newIndex
end

function BlockStart:getNewColumn()
	return self._newColumn
end

function BlockStart:isReplaceActiveBlockParser()
	return self._replaceActiveBlockParser
end

function BlockStart:getReplaceParagraphLines()
	return self._replaceParagraphLines
end

function BlockStart:atIndex(newIndex: number)
	self._newIndex = newIndex
	return self
end

function BlockStart:atColumn(newColumn: number)
	self._newColumn = newColumn
	return self
end

function BlockStart:replaceActiveBlockParser()
	self._replaceActiveBlockParser = true
	return self
end

function BlockStart:replaceParagraphLines(replaceParagraphLines: number)
	if not (replaceParagraphLines >= 1) then
		error("Lines must be >= 1")
	end

	self._replaceParagraphLines = replaceParagraphLines
	return self
end

return BlockStart
