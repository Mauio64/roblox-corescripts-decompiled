return function(p1, p2) -- line: 9
	if type(p1) ~= "string" then
		return ""
	end

	if type(p2) ~= "table" then
		return p1
	end

	for k, v in pairs(p2) do
		if type(k) == "string" and type(v) == "string" then
			p1 = string.gsub(p1, k, v)
		end
	end

	return p1
end
