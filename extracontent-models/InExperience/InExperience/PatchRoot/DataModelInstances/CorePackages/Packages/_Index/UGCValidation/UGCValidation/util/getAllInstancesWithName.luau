return function(folder, p: string)
	local descendants = folder:GetDescendants()
	table.insert(descendants, folder)

	local descendants2 = {}

	for _, descendant in descendants do
		if descendant.Name == p then
			table.insert(descendants2, descendant)
		end
	end

	return descendants2
end
