return function(p: string, p2: string, p3: string, p4: string?, p5: number?)
	local v = {}

	if p4 == nil then
		table.insert(v, p .. p2 .. p3)
	else
		table.insert(v, p .. p4 .. p2 .. p3)
	end

	if p5 == nil then
		return v
	end

	local v2 = tostring(p5)

	if p4 == nil then
		table.insert(v, p .. p2 .. v2 .. p3)
	else
		table.insert(v, p .. p4 .. p2 .. v2 .. p3)
		return v
	end

	return v
end
