local ParentParent = script.Parent.Parent
local NaN = require(ParentParent.Number).NaN

return function(s1: string, n1: number) -- line: 24
	-- upvalues: NaN (copy)
	if type(n1) ~= "number" then
		n1 = 1
	end

	local v5 = string.len(s1)

	if n1 < 1 or v5 < n1 then
		return NaN
	end

	local v6 = utf8.offset(s1, n1)

	if v6 == nil or v5 < v6 then
		return NaN
	end

	local v7 = utf8.codepoint(s1, v6, v6)

	if v7 == nil then
		return NaN
	end

	return v7
end
