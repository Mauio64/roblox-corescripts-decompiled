local SourceSpan = {}
SourceSpan.__index = SourceSpan

local function new(lineIndex: number, columnIndex: number, inputIndex: number, length: number)
	if lineIndex < 0 then
		error(`lineIndex {lineIndex} must be >= 0`)
	end

	if columnIndex < 0 then
		error(`columnIndex {columnIndex} must be >= 0`)
	end

	if inputIndex < 0 then
		error(`inputIndex {inputIndex} must be >= 0`)
	end

	if length < 0 then
		error(`length {length} must be >= 0`)
	end

	return (setmetatable(
		{
			_lineIndex = lineIndex,
			_columnIndex = columnIndex,
			_inputIndex = inputIndex,
			_length = length
		},
		SourceSpan
	))
end

function SourceSpan.of(lineIndex: number, columnIndex: number, inputIndex: number, length: number)
	return new(lineIndex, columnIndex, inputIndex, length)
end

function SourceSpan:getLineIndex()
	return self._lineIndex
end

function SourceSpan:getColumnIndex()
	return self._columnIndex
end

function SourceSpan:getInputIndex()
	return self._inputIndex
end

function SourceSpan:getLength()
	return self._length
end

function SourceSpan:subSpan(p: number, p2: number?)
	local length = self._length

	if p2 == nil then
		return self:subSpan(p, length)
	end

	if p < 0 then
		error(`beginIndex {p} + must be >= 0`)
	end

	if length < p then
		error(`beginIndex {p} must be <= length {length}`)
	end

	if p2 < 0 then
		error(`endIndex {p2} + must be >= 0`)
	end

	if length < p2 then
		error(`endIndex {p2} must be <= length {length}`)
	end

	if p2 < p then
		error(`beginIndex {p} must be <= endIndex {p2}`)
	end

	if p == 0 and p2 == length then
		return self
	end

	return new(self._lineIndex, self._columnIndex + p, self._inputIndex + p, p2 - p)
end

function SourceSpan:equals(data): boolean
	if self == data then
		return true
	end

	if data == nil then
		return false
	end

	return self._lineIndex == data._lineIndex
		and self._columnIndex == data._columnIndex
		and self._inputIndex == data._inputIndex
		and self._length == data._length
end

function SourceSpan:toString()
	return `SourceSpan\{line={self._lineIndex}, column={self._columnIndex}, input={self._inputIndex}, length={self._length}}`
end

return SourceSpan
