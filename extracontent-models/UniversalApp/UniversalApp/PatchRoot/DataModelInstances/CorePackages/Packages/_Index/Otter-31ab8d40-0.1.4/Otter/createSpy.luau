local function createSpy(p1) -- line: 1
	local t1 = {
		callCount = 0,
		valuesLength = 0,
		values = {}
	}

	function t1.value(...) -- line: 8
		-- upvalues: t1 (copy), p1 (copy)
		t1.callCount = t1.callCount + 1
		t1.values = { ... }
		t1.valuesLength = select("#", ...)

		if p1 ~= nil then
			return p1(...)
		end
	end
	function t1.assertCalledWith(_, ...) -- line: 18
		-- upvalues: t1 (copy)
		local v5 = select("#", ...)

		assert(t1.valuesLength, v5, "length of expected values differs from stored values")

		for i = 1, v5 do
			local v7 = select(i, ...)

			assert(t1.values[i], v7, "value differs")
		end
	end

	setmetatable(t1, {
		__index = function(_, p4) -- line: 30
			error(("%q is not a valid member of spy"):format(p4))
		end
	})

	return t1
end

return createSpy
