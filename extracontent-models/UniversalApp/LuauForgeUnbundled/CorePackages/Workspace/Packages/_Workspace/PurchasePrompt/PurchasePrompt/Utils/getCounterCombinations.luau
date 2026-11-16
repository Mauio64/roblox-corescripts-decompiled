return function(p2, p3, p4, p5, p6)
	local v5 = {}

	if p5 == nil then
		table.insert(v5, p2 .. p3 .. p4)
	else
		table.insert(v5, p2 .. p5 .. p3 .. p4)
	end

	if p6 == nil then
		return v5
	end

	local v6 = tostring(p6)

	if p5 == nil then
		table.insert(v5, p2 .. p3 .. v6 .. p4)
	else
		table.insert(v5, p2 .. p5 .. p3 .. v6 .. p4)
		return v5
	end

	return v5
end
