return function(p1, p2) -- line: 1
	local v3 = p1 or {}

	if (p2 == "POST" or p2 == "PATCH") and not v3["Content-Type"] then
		v3["Content-Type"] = "application/json"
	end

	return v3
end
