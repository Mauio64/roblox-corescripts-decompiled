local ParentParent = script.Parent.Parent
local Symbol = require(ParentParent.Symbols.Symbol)
local strict = require(ParentParent.strict)

local function createEnum(s1: string, t1: {[any]: any}) -- line: 19
	-- upvalues: Symbol (copy), strict (copy)
	assert(typeof(s1) == "string", "Bad argument #1, expected string")
	assert(typeof(t1) == "table", "Bad argument #2, expected list of values")

	local t2 = {}

	for _, v in ipairs(t1) do
		assert(v ~= "isMember", "Shadowing 'isMember' function is not allowed")
		assert(typeof(v) == "string", "Only string names are supported for enum types")

		local v10 = Symbol.named(v)
		local v11 = ("%s.%s"):format(s1, v)

		getmetatable(v10).__tostring = function() -- line: 31
			-- upvalues: v11 (copy)
			return v11
		end
		t2[v] = v10
	end

	function t2.isMember(p1) -- line: 38
		-- upvalues: t2 (copy)
		if typeof(p1) ~= "userdata" then
			return false
		end

		for _, v in pairs(t2) do
			if p1 == v then
				return true
			end
		end

		return false
	end

	getmetatable((newproxy(true))).__index = t2

	return strict(t2, s1)
end

return createEnum
