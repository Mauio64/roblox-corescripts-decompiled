local function captureSize(...) -- line: 31
	return { ... }, select("#", ...)
end
local function memoize(p1: ((...any) -> ...any)) -- line: 37
	-- upvalues: captureSize (copy)
	assert(type(p1) == "function", "memoize requires a function to memoize")

	local t1 = nil
	local u5 = nil
	local u6 = nil
	local u7 = nil

	return function(...) -- line: 45
		-- upvalues: u5 (ref), u6 (ref), u7 (ref), captureSize (copy), p1 (copy), t1 (ref)
		local v8 = select("#", ...)

		while v8 > 0 and select(v8, ...) == nil do
			v8 -= 1
		end

		if v8 ~= u5 then
			local v9, v10 = captureSize(p1(...))

			u6 = v9
			u7 = v10
			t1 = { ... }
			u5 = v8

			return unpack(u6, 1, u7)
		end

		for i = 1, u5 do
			if select(i, ...) ~= t1[i] then
				local v12, v13 = captureSize(p1(...))

				u6 = v12
				u7 = v13
				t1 = { ... }

				return unpack(u6, 1, u7)
			end
		end

		return unpack(u6, 1, u7)
	end
end

return memoize
