function getUpdatedSelectedCapturesArray(p1, p2) -- line: 1
	local t1 = {}
	local v4 = false

	for _, v in ipairs(p1) do
		if v == p2 then
			v4 = true
		else
			table.insert(t1, v)
		end
	end

	if not v4 then
		table.insert(t1, p2)
	end

	return t1
end

return getUpdatedSelectedCapturesArray
