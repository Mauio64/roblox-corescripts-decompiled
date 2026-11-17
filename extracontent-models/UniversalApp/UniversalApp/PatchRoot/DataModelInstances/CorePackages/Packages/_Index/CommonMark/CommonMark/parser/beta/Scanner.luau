local CommonMark = script:FindFirstAncestor("CommonMark")
require(CommonMark.text.CharMatcher)
local Position = require(CommonMark.parser.beta.Position)
local SourceLine = require(CommonMark.parser.SourceLine)
local SourceLines = require(CommonMark.parser.SourceLines)
require(CommonMark.node.SourceSpan)
local Utf8 = require(CommonMark.internal.port.Utf8)

local byte = string.byte
local char = string.char
local find = string.find
local sub = string.sub

local Scanner = {}
Scanner.__index = Scanner

Scanner.END = 0

function Scanner.new(lines, lineIndex: number, p: number)
	local self = setmetatable({
		_lines = lines,
		_lineIndex = lineIndex,
		_index = p,
		_line = SourceLine.of("", nil),
		_lineLength = 0
	}, Scanner)

	if #lines > 0 then
		self:checkPosition(lineIndex, p)
		self:setLine(lines[lineIndex + 1])
	end

	return self
end

function Scanner.of(object)
	return Scanner.new(object:getLines(), 0, 0)
end

function Scanner:peek()
	if self._index < self._lineLength then
		return byte(self._line:getContent(), self._index + 1)
	else
		return if self._lineIndex < #self._lines - 1 then 10 else 0
	end
end

function Scanner:peekCodePoint()
	if self._index < self._lineLength then
		return Utf8.codePointAt(self._line:getContent(), self._index)
	end

	return if self._lineIndex < #self._lines - 1 then 10 else 0
end

function Scanner:peekPreviousCodePoint()
	if self._index > 0 then
		return Utf8.codePointBefore(self._line:getContent(), self._index)
	end

	return if self._lineIndex > 0 then 10 else 0
end

function Scanner:hasNext(): boolean
	return self._index < self._lineLength or self._lineIndex < #self._lines - 1
end

function Scanner:next()
	self._index += 1

	if self._index > self._lineLength then
		self._lineIndex += 1

		if self._lineIndex < #self._lines then
			self:setLine(self._lines[self._lineIndex + 1])
		else
			self:setLine(SourceLine.of("", nil))
		end

		self._index = 0
	end
end

function Scanner:nextChar(p: number): boolean
	if self:peek() ~= p then
		return false
	end

	self:next()
	return true
end

function Scanner:nextString(list: string): boolean
	if not (self._index < self._lineLength and self._index + #list <= self._lineLength) then
		return false
	end

	if sub(self._line:getContent(), self._index + 1, self._index + #list) ~= list then
		return false
	end

	self._index += #list
	return true
end

function Scanner:matchMultiple(p: number)
	local count = 0

	while self:peek() == p do
		count += 1
		self:next()
	end

	return count
end

function Scanner:match(object)
	local count = 0

	while object:matches(self:peek()) do
		count += 1
		self:next()
	end

	return count
end

function Scanner:whitespace()
	local count = 0

	while true do
		local v = self:peek()

		if v ~= 32 and v ~= 9 and v ~= 10 and v ~= 11 and v ~= 12 and v ~= 13 then
			return count
		end

		count += 1
		self:next()
	end
end

local charPatterns = {}

local function findCharPattern(p: number) -- 1 equivalent call inferred from this helper
	local charPattern = charPatterns[p]

	if charPattern ~= nil then
		return charPattern
	end

	local v

	if p >= 48 and p <= 57 or p >= 65 and p <= 90 then
		v = true
	elseif p >= 97 then
		v = p <= 122
	else
		v = false
	end

	charPattern = "[\0" .. (v and "" or "%") .. char(p) .. "]"
	charPatterns[p] = charPattern

	return charPattern
end

function Scanner:findChar(p: number)
	local total = 0

	while true do
		if self._index < self._lineLength then
			local v = find(self._line:getContent(), findCharPattern(p), self._index + 1) -- inferred equivalent call
			local v2

			if v == nil then
				v2 = self._lineLength
			else
				v2 = v - 1
			end

			total += v2 - self._index
			self._index = v2
		end

		local v = self:peek()

		if v == 0 then
			return -1
		end

		if v == p then
			return total
		end

		total += 1
		self:next()
	end
end

function Scanner:findMatcher(object)
	local count = 0

	while true do
		local v = self:peek()

		if v == 0 then
			return -1
		end

		if object:matches(v) then
			return count
		end

		count += 1
		self:next()
	end
end

function Scanner:position()
	return Position.new(self._lineIndex, self._index)
end

function Scanner:setPosition(p)
	self:checkPosition(p.lineIndex, p.index)
	self._lineIndex = p.lineIndex
	self._index = p.index
	self:setLine(self._lines[self._lineIndex + 1])
end

function Scanner:getSource(p, p2)
	if p.lineIndex == p2.lineIndex then
		local line = self._lines[p.lineIndex + 1]
		local content = line:getContent()

		if p.index < 0 or p.index > p2.index or p2.index > #content then
			error(`begin {p.index}, end {p2.index}, length {#content}`)
		end

		local v = sub(content, p.index + 1, p2.index)

		local sourceSpan = line:getSourceSpan()
		local v2

		if sourceSpan ~= nil then
			v2 = sourceSpan:subSpan(p.index, p2.index)
		end

		return SourceLines.of(SourceLine.of(v, v2))
	else
		local empty = SourceLines.empty()

		local line = self._lines[p.lineIndex + 1]
		empty:addLine(line:substring(p.index, #line:getContent()))

		for i = p.lineIndex + 1, p2.lineIndex - 1 do
			empty:addLine(self._lines[i + 1])
		end

		empty:addLine(self._lines[p2.lineIndex + 1]:substring(0, p2.index))
		return empty
	end
end

function Scanner:setLine(line)
	self._line = line
	self._lineLength = #line:getContent()
end

function Scanner:checkPosition(p: number, p2: number)
	if p < 0 or #self._lines <= p then
		error(`Line index {p} out of range, number of lines: {#self._lines}`)
	end

	local line = self._lines[p + 1]

	if p2 < 0 or #line:getContent() < p2 then
		error(`Index {p2} out of range, line length: {#line:getContent()}`)
	end
end

return Scanner
