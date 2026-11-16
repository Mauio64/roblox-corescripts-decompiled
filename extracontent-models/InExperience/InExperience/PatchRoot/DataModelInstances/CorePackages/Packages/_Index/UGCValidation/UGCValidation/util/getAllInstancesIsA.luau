return function(folder, className: string)
	local success, _ = pcall(Instance.new, className)
	assert(success, `{className} does not exist. Did you make a typo?`)

	local descendants = folder:GetDescendants()
	table.insert(descendants, folder)

	local descendants2 = {}

	for _, descendant in descendants do
		if descendant:IsA(className) then
			table.insert(descendants2, descendant)
		end
	end

	return descendants2
end
