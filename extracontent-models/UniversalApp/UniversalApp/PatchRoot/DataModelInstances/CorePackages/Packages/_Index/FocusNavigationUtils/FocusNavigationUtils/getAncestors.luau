local function getAncestors(p1) -- line: 1
	local t1 = { p1 }

	while p1.Parent do
		table.insert(t1, p1.Parent)
		p1 = p1.Parent
	end

	return t1
end

return getAncestors
