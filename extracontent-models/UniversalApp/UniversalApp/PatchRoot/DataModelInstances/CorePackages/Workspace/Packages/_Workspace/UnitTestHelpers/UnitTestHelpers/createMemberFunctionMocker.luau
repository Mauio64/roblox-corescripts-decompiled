local ParentParent = script.Parent.Parent
local jest = require(ParentParent.JestGlobals).jest

local function createMemberFunctionMocker(p1) -- line: 7
	-- upvalues: jest (copy)
	local t1 = {}
	local mt = getmetatable(p1)

	local function mockMemberFunction(p2) -- line: 11
		-- upvalues: mt (copy), jest (copy), t1 (copy)
		local v10 = mt[p2]
		local v11 = jest.fn()

		mt[p2] = v11
		table.insert(t1, function() -- line: 15
			-- upvalues: mt (copy), p2 (copy), v10 (copy)
			mt[p2] = v10
		end)

		return v11
	end
	local function reset() -- line: 21
		-- upvalues: t1 (copy)
		for i = #t1, 1, -1 do
			t1[i]()
		end

		table.clear(t1)
	end

	return mockMemberFunction, reset
end

return createMemberFunctionMocker
