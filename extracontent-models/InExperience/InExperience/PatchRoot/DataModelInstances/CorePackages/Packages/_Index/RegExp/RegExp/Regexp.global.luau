local RegEx = require(script.Parent.RegEx)

local v = {}
local v2 = {
	__index = v,
	__tostring = function(p)
		return (tostring(p._innerRegEx))
	end
}

function v:exec(input: string)
	local match = self._innerRegEx:match(input)

	if not match then
		return nil
	end

	local span = match:span()
	local grouparr = match:grouparr()

	local result = { grouparr[0] }

	for i = 1, grouparr.n do
		result[i + 1] = grouparr[i]
	end

	result.n = grouparr.n + 1
	result.index = span
	result.input = input
	return result
end

function v:test(p: string): boolean
	return self:exec(p) ~= nil
end

local function new(_, source, value: string?)
	value = value or ""
	local innerRegEx = RegEx.new(source, value)
	return (setmetatable({
		source = source,
		ignoreCase = value:find("i") ~= nil,
		global = value:find("g") ~= nil,
		multiline = value:find("m") ~= nil,
		_innerRegEx = innerRegEx
	}, v2))
end

return (setmetatable(v, { __call = new }))
