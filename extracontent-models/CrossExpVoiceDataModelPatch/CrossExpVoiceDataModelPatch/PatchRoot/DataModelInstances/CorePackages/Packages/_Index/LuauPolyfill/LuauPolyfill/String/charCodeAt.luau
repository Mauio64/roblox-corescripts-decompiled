local ParentParent = script.Parent.Parent
local NaN = require(ParentParent.Number).NaN

return function(s1: string, n1: number) -- line: 10
	-- upvalues: NaN (copy)
	if typeof(n1) ~= "number" then
		n1 = 1
	end

	local v5, v6 = utf8.len(s1)

	assert(v5 ~= nil, ("string `%s` has an invalid byte at position %s"):format(s1, (tostring(v6))))

	if v5 < n1 or n1 < 1 then
		return NaN
	end

	local v7 = utf8.offset(s1, n1)
	local v8 = utf8.codepoint(s1, v7, v7)

	if v8 == nil then
		return NaN
	end

	return v8
end
