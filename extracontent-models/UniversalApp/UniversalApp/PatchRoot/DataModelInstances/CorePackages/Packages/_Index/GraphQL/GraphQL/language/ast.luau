local ParentParent = script.Parent.Parent.Parent

require(ParentParent.LuauPolyfill)
require(script.Parent.source)
require(script.Parent.tokenKind)

local t1 = {}

t1.__index = t1

function t1.new(t2: {[any]: any}, t3: {[any]: any}, p1) -- line: 50
	-- upvalues: t1 (copy)
	return (setmetatable({
		start = t2.start,
		_end = t3._end,
		startToken = t2,
		endToken = t3,
		source = p1
	}, t1))
end
function t1.toJSON(p2) -- line: 62
	return {
		start = p2.start,
		_end = p2._end
	}
end

local t4 = {}

t4.__index = t4

function t4.new(p3, n1: number, n2: number, n3: number, n4: number, t5: {[any]: any}?, s1: string?) -- line: 138
	-- upvalues: t4 (copy)
	return (setmetatable({
		kind = p3,
		start = n1,
		_end = n2,
		line = n3,
		column = n4,
		value = s1,
		prev = t5,
		next = nil
	}, t4))
end
function t4.toJSON(p4) -- line: 161
	return {
		kind = p4.kind,
		value = p4.value,
		line = p4.line,
		column = p4.column
	}
end

return {
	Location = t1,
	Token = t4,
	isNode = function(p5) -- line: 181
		return typeof(p5) == "table" and typeof(p5.kind) == "string"
	end
}
