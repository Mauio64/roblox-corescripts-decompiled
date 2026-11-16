local byte = string.byte

local AsciiMatcher = {}
AsciiMatcher.__index = AsciiMatcher

local class = {}
class.__index = class

function AsciiMatcher:new()
	return (setmetatable({ _set = self._set }, AsciiMatcher))
end

function AsciiMatcher:matches(p: number): boolean
	return self._set[p] == true
end

function AsciiMatcher:newBuilder()
	return class.new(table.clone(self._set))
end

function AsciiMatcher.builder()
	return class.new({})
end

function AsciiMatcher:builderMatcher()
	return class.new(table.clone(self._set))
end

function class.new(set)
	return (setmetatable({ _set = set }, class))
end

function class:c(p: number)
	if p > 127 then
		error("Can only match ASCII characters")
	end

	self._set[p] = true
	return self
end

function class:anyOf(value: string)
	for i = 0, #value - 1 do
		self:c(byte(value, i + 1))
	end

	return self
end

function class:anyOfSet(items)
	for k in items do
		self:c(k)
	end

	return self
end

function class:range(p: number, p2: number)
	for i = p, p2 do
		self:c(i)
	end

	return self
end

function class.build(p)
	return AsciiMatcher.new(p)
end

AsciiMatcher.Builder = class

return AsciiMatcher
