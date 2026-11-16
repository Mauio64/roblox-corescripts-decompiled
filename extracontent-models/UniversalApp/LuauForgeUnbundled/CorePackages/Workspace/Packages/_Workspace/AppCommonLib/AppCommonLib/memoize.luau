local function captureSize(...)
	return { ... }, (select)("#", ...)
end

local function memoize(callback)
	assert(type(callback) == "function", "memoize requires a function to memoize")

	local v5 = nil
	local v6 = nil
	local v7 = nil
	local v8 = nil

	return function(...)
		local v9 = select("#", ...)

		while v9 > 0 and select(v9, ...) == nil do
			v9 -= 1
		end

		if v9 == v6 then
			for i = 1, v6 do
				if select(i, ...) ~= v5[i] then
					v7, v8 = captureSize(callback(...))
					v5 = { ... }
					break
				end
			end

			return unpack(v7, 1, v8)
		end

		v7, v8 = captureSize(callback(...))
		v5 = { ... }
		v6 = v9
		return unpack(v7, 1, v8)
	end
end

return memoize
