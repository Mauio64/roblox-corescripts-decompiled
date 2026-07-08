return function(...) -- line: 4
	local t1 = { ... }
	local v2 = #t1

	if v2 == 0 then
		return function(p1) -- line: 9
			return p1
		end
	end

	local v3 = t1[1]

	for i = 2, v2 do
		local v5 = t1[i]
		local v6 = v3

		function v3(...) -- line: 18
			-- upvalues: v6 (copy), v5 (copy)
			return v6(v5(...))
		end
	end

	return v3
end
