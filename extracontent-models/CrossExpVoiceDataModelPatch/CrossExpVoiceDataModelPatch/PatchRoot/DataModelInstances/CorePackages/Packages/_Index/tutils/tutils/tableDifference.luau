return function(p1, p2) -- line: 5
	local t1 = {}

	for k, v in pairs(p1) do
		if p2[k] ~= p1[k] then
			t1[k] = v
		end
	end

	for k, v in pairs(p2) do
		if p2[k] ~= p1[k] then
			t1[k] = v
		end
	end

	return t1
end
