return function(options, p)
	local v = options or {}

	if (p == "POST" or p == "PATCH") and not v["Content-Type"] then
		v["Content-Type"] = "application/json"
	end

	return v
end
