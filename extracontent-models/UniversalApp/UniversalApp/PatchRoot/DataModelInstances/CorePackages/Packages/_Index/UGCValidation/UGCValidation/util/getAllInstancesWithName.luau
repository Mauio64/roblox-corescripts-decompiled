return function(p1, s1: string) -- line: 1
	local descendants = p1:GetDescendants()

	table.insert(descendants, p1)

	local t1 = {}

	for _, v6 in descendants do
		if s1 == v6.Name then
			table.insert(t1, v6)
		end
	end

	return t1
end
