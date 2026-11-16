local function pipe(callback, ...)
	local v = select("#", ...)

	if v == 0 then
		return callback
	end

	local v2 = { ... }
	return function(...)
		local v3 = { callback(...) }

		for i = 1, v do
			v3 = { v2[i](unpack(v3)) }
		end

		return unpack(v3)
	end
end

return pipe
