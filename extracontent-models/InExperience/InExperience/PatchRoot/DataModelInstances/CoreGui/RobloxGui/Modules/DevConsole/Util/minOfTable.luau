return function(p1, p2) -- line: 2
	local t1 = {}

	for k, v in pairs(p1) do
		if not p2[k] then
			error("tables did not have matching indices")

			return
		end

		t1[k] = v < p2[k] and v or p2[k]
	end

	return t1
end
