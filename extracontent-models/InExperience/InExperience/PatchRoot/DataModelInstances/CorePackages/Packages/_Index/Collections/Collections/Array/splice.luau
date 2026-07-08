local ParentParent = script.Parent.Parent.Parent

require(ParentParent.ES7Types)

return function(p1, n1: number, n2: number?, ...) -- line: 24
	if n1 > #p1 then
		for i = 1, select("#", ...) do
			table.insert(p1, (select(i, ...)))
		end

		return {}
	end

	local v6 = #p1

	if n1 < 1 then
		n1 = math.max(v6 - math.abs(n1), 1)
	end

	local t1 = {}
	local v8 = n2 or v6

	if v8 > 0 then
		for _ = n1, math.min(v6, n1 + math.max(0, v8 - 1)) do
			table.insert(t1, (table.remove(p1, n1)))
		end
	end

	for i = select("#", ...), 1, -1 do
		table.insert(p1, n1, (select(i, ...)))
	end

	return t1
end
