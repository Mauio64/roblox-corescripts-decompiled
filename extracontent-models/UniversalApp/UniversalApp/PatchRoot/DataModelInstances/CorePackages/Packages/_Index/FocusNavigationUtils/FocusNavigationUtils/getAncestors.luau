local function getAncestors(p)
	local parents = { p }

	while p.Parent do
		table.insert(parents, p.Parent)
		p = p.Parent
	end

	return parents
end

return getAncestors
