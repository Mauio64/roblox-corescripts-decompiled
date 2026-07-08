local function createSpy(p1) -- line: 8
	local t1 = {
		callCount = 0,
		valuesLength = 0,
		values = {}
	}

	function t1.value(...) -- line: 15
		-- upvalues: t1 (copy), p1 (copy)
		t1.callCount = t1.callCount + 1
		t1.values = { ... }
		t1.valuesLength = select("#", ...)

		if p1 ~= nil then
			return p1(...)
		end
	end
	function t1.assertCalledWith(_, ...) -- line: 27
		-- upvalues: t1 (copy)
		local v5 = select("#", ...)

		if v5 ~= t1.valuesLength then
			error(("Expected %d arguments, but was called with %d arguments"):format(t1.valuesLength, v5), 2)
		end

		for i = 1, v5 do
			local v7 = select(i, ...)

			assert(v7 == t1.values[i], "value differs; got " .. tostring(t1.values[i]) .. ", expected " .. tostring(v7))
		end
	end
	function t1.captureValues(_, ...) -- line: 44
		-- upvalues: t1 (copy)
		local v9 = select("#", ...)
		local t2 = {}

		assert(v9 == t1.valuesLength, "length of expected values differs from stored values")

		for i = 1, v9 do
			t2[select(i, ...)] = t1.values[i]
		end

		return t2
	end

	setmetatable(t1, {
		__index = function(_, p5) -- line: 59
			error(("%q is not a valid member of spy"):format(p5))
		end
	})

	return t1
end

return createSpy
