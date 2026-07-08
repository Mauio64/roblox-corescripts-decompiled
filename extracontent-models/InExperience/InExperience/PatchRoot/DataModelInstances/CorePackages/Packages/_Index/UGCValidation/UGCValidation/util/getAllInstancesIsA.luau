return function(p1, s1: string) -- line: 1
	local ok, _ = pcall(Instance.new, s1)

	assert(ok, `{ s1 } does not exist. Did you make a typo?`)

	local descendants = p1:GetDescendants()

	table.insert(descendants, p1)

	local t1 = {}

	for _, v8 in descendants do
		if v8:IsA(s1) then
			table.insert(t1, v8)
		end
	end

	return t1
end
