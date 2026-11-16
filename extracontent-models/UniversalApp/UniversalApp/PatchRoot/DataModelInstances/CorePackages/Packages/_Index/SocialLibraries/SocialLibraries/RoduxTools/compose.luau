return function(...)
	local v = { ... }
	local count = #v

	if count == 0 then
		return function(p)
			return p
		end
	end

	local v2 = v[1]
	local v3 = v2

	for i = 2, count do
		local v4 = v[i]
		local v5 = v3

		v2 = function(...)
			return v5(v4(...))
		end

		v3 = v2
	end

	return v3
end
