return function(p1) -- line: 1
	return function(p2, p3) -- line: 2
		-- upvalues: p1 (copy)
		local v4, v5 = p1(p2)

		if v4 == false then
			return v4, v5 .. ". Issue with: " .. p3
		end

		return v4
	end
end
