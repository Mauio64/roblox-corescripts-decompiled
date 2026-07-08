local RegEx = require(script.Parent.RegEx)
local t1 = {}
local t2 = {
	__index = t1,
	__tostring = function(p1) -- line: 14
		return (tostring(p1._innerRegEx))
	end
}

function t1.exec(t3: {[any]: any}, s1: string) -- line: 19
	local v8 = t3._innerRegEx:match(s1)

	if not v8 then
		return nil
	end

	local v9 = v8:span()
	local v10 = v8:grouparr()
	local t4 = { v10[0] }

	for i = 1, v10.n do
		t4[i + 1] = v10[i]
	end

	t4.n = v10.n + 1
	t4.index = v9
	t4.input = s1

	return t4
end
function t1.test(t5: {[any]: any}, s2: string) -- line: 38
	return t5:exec(s2) ~= nil
end

local function new(_, p3, s3: string?) -- line: 42
	-- upvalues: RegEx (copy), t2 (copy)
	local v18 = s3 or ""
	local v19 = RegEx.new(p3, v18)

	return (setmetatable({
		source = p3,
		ignoreCase = v18:find("i") ~= nil,
		global = v18:find("g") ~= nil,
		multiline = v18:find("m") ~= nil,
		_innerRegEx = v19
	}, t2))
end

return (setmetatable(t1, {
	__call = new
}))
