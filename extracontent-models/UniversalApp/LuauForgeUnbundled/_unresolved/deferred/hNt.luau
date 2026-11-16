return function(...)
	local v5 = { ... }

	return function(p2)
		local v6 = nil

		for i, v7 in ipairs(v5) do
			if v6 == nil then
				v6 = v7(p2)
			else
				v6 = v6:andThen(function(p3)
					if p3 == nil then
						return v7(p2)
					end

					return p3
				end)
			end
		end

		return v6
	end
end
