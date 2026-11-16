local function createSpy(callback)
	local spy = { callCount = 0, values = {}, valuesLength = 0 }

	function spy.value(...)
		spy.callCount += 1
		spy.values = { ... }
		spy.valuesLength = select("#", ...)

		if callback == nil then
			return
		end

		return callback(...)
	end

	function spy.assertCalledWith(_, ...)
		local v = select("#", ...)

		if spy.valuesLength ~= v then
			error(("Expected %d arguments, but was called with %d arguments"):format(spy.valuesLength, v), 2)
		end

		for i = 1, v do
			local v2 = select(i, ...)

			assert(
				spy.values[i] == v2,
				"value differs; got " .. tostring(spy.values[i]) .. ", expected " .. tostring(v2)
			)
		end
	end

	function spy.captureValues(_, ...)
		local v = select("#", ...)

		assert(spy.valuesLength == v, "length of expected values differs from stored values")
		local result = {}

		for i = 1, v do
			result[select(i, ...)] = spy.values[i]
		end

		return result
	end

	setmetatable(spy, {
		__index = function(_, p)
			error(("%q is not a valid member of spy"):format(p))
		end
	})

	return spy
end

return createSpy
