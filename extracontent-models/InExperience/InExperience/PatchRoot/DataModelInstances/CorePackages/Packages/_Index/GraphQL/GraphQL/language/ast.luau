local parent = script.Parent.Parent.Parent
require(parent.LuauPolyfill)

require(script.Parent.source)

require(script.Parent.tokenKind)

local class = {}
class.__index = class

function class.new(startToken, endToken, source)
	return (setmetatable({
		["start"] = startToken.start,
		_end = endToken._end,
		startToken = startToken,
		endToken = endToken,
		source = source
	}, class))
end

function class:toJSON()
	return { start = self.start, _end = self._end }
end

local class2 = {}
class2.__index = class2

function class2.new(kind, start: number, p: number, line: number, column: number, prev, p2: string?)
	return (setmetatable({
		["kind"] = kind,
		start = start,
		_end = p,
		line = line,
		column = column,
		value = p2,
		prev = prev,
		next = nil
	}, class2))
end

function class2.toJSON(data)
	return { kind = data.kind, value = data.value, line = data.line, column = data.column }
end

return {
	Location = class,
	Token = class2,
	isNode = function(p): boolean
		return typeof(p) == "table" and typeof(p.kind) == "string"
	end
}
