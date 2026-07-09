local function findAllDescendants(p1, p2: ((...any) -> ...any)) -- line: 1
	local t1 = {}

	for _, descendant in ipairs(p1:GetDescendants()) do
		if p2(descendant) then
			table.insert(t1, descendant)
		end
	end

	return t1
end

return findAllDescendants
