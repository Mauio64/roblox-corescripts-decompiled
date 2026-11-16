return function(callback)
	return function(p, p2)
		local v, v2 = callback(p)

		if v == false then
			return false, v2 .. ". Issue with: " .. p2
		end

		return v
	end
end
