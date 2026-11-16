local CommonMark = script:FindFirstAncestor("CommonMark")
local Characters = require(CommonMark.text.Characters)

local byte = string.byte
local sub = string.sub

local LineReader = {}
LineReader.__index = LineReader

function LineReader.new(input: string)
	return (setmetatable({
		_input = input,
		_position = 0,
		_limit = #input,
		_lineTerminator = nil
	}, LineReader))
end

local line

function LineReader:readLine()
	local input = self._input

	if input == nil then
		error("LineReader is closed")
	end

	local position = self._position

	if self._limit <= position then
		return line(self, nil, nil)
	end

	local lineBreak = Characters.findLineBreak(input, position)

	if lineBreak == -1 then
		self._position = self._limit
		return line(self, sub(input, position + 1, self._limit), nil)
	end

	if byte(input, lineBreak + 1) == 10 then
		self._position = lineBreak + 1
		return line(self, sub(input, position + 1, lineBreak), "\n")
	end

	if byte(input, lineBreak + 1 + 1) == 10 then
		self._position = lineBreak + 2
		return line(self, sub(input, position + 1, lineBreak), "\r\n")
	end

	self._position = lineBreak + 1
	return line(self, sub(input, position + 1, lineBreak), "\r")
end

function LineReader:getLineTerminator()
	return self._lineTerminator
end

function LineReader:close()
	if self._input == nil then
		return
	end

	self._input = nil
end

line = function(state, p: string?, lineTerminator: string?)
	state._lineTerminator = lineTerminator
	return p
end

return LineReader
