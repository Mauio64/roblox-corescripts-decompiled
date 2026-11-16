local parent = script:FindFirstAncestor("Utils").Parent

local TextSplitBy = require(parent.Enums.TextSplitBy)

local function isWhitespace(value: string): boolean -- 1 equivalent call inferred from this helper
	return value:match("%s") ~= nil
end

local function codepointEnd(text: string, codepointIndex: number) -- 1 equivalent call inferred from this helper
	local v = utf8.offset(text, codepointIndex + 1)

	if v == nil then
		return #text
	end

	return v - 1
end

local class = {}
class.__index = class

function class.new(text: string, p: number, p2: number, p3: number)
	local self = setmetatable({}, class)
	self._text = text
	self._initialGuess = self:_guessInitialBreak(p, p2, p3)
	self._index = self._initialGuess

	self:setDirection(1)
	return self
end

function class:_guessInitialBreak(_: number, p: number, p2: number)
	return (math.max(math.floor(#self._text * p2 / p), 1))
end

function class:findPossibleBreak()
	local index = self._index

	while self.direction == 1 and index <= #self._text or self.direction == -1 and index > 0 do
		if isWhitespace(self._text:sub(index, index)) then -- inferred equivalent call
			self._index = index + self._step

			return index - 1
		end

		index += self._step
	end

	return index
end

function class:setDirection(direction: number)
	self.direction = direction

	if direction ~= 1 then
		self._index = self._initialGuess
	end

	self._step = direction == 1 and 1 or -1
end

local class2 = {}
class2.__index = class2

function class2.new(text: string, p: number, p2: number, p3: number)
	local self = setmetatable({}, class2)
	self._text = text
	self._initialGuess = self:_guessInitialBreak(p, p2, p3)
	self._codepointIndex = self._initialGuess
	self._step = 0
	return self
end

function class2:_guessInitialBreak(p: number, p2: number, p3: number)
	return (math.max(math.floor(p * p3 / p2), 1))
end

function class2:findPossibleBreak()
	self._codepointIndex += self._step
	return codepointEnd(self._text, self._codepointIndex) -- inferred equivalent call
end

function class2:setDirection(direction)
	self.direction = direction
	self._step = direction == 1 and 1 or -1
end

local function splitWith(p, callback, value: string, p2: number, p3: number, p4: number)
	local v = p.new(value, p2, p3, p4)

	local v2 = v:findPossibleBreak()
	local v3 = value:sub(1, v2)
	local v4 = p4 < callback(v3) and -1 or 1

	v:setDirection(v4)
	local v5 = v2
	local count = 0

	while count < p2 do
		v2 = v:findPossibleBreak()

		v3 = value:sub(1, v2)
		local v6 = p4 < callback(v3) and -1 or 1

		if v4 == v6 then
			count += 1
			v5 = v2
			v4 = v6
		elseif v4 == 1 then
			return value:sub(1, v5), v5
		else
			break
		end
	end

	return v3, v2
end

local function split(p, callback, value: string, p2: number)
	local v = utf8.len(value)

	if v == nil then
		warn("Failed to get string length, it is probably malformed or non utf8")
		return value
	end

	local v2 = callback(value)

	if v2 <= p2 then
		return value
	end

	local v3 = if p == TextSplitBy.Word then class else class2

	local v4, v5 = splitWith(v3, callback, value, v, v2, p2)

	if v5 == 0 or v5 == #value then
		return value
	end

	return v4, (value:sub(v5 + 1))
end

return split
