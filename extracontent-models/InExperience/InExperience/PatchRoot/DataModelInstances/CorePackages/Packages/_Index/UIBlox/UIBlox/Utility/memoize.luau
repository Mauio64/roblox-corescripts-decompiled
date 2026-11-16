local function captureSize(...)
	return { ... }, (select)("#", ...)
end

local function memoize(callback)
	assert(type(callback) == "function", "memoize requires a function to memoize")

	local v = nil
	local v2 = nil
	local v3 = nil
	local v4 = nil

	return function(...)
		local v5 = select("#", ...)

		while v5 > 0 and select(v5, ...) == nil do
			v5 -= 1
		end

		if v5 == v2 then
			for i = 1, v2 do
				if select(i, ...) ~= v[i] then
					v = { ... }
					v3, v4 = captureSize(callback(...))
					break
				end
			end

			return unpack(v3, 1, v4)
		end

		v = { ... }
		v2 = v5
		v3, v4 = captureSize(callback(...))
		return unpack(v3, 1, v4)
	end
end

return memoize
