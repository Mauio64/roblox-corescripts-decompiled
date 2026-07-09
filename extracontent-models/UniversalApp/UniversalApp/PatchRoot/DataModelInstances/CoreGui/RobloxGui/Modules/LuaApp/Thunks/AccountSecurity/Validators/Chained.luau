return function(...) -- line: 3
	local t1 = { ... }

	return function(p1) -- line: 6
		-- upvalues: t1 (copy)
		local v3 = nil

		for _, v in ipairs(t1) do
			v3 = if v3 ~= nil then v3:andThen(function(p2) -- line: 12
				-- upvalues: v (copy), p1 (copy)
				if p2 ~= nil then
					return p2
				end

				return v(p1)
			end) else v(p1)
		end

		return v3
	end
end
