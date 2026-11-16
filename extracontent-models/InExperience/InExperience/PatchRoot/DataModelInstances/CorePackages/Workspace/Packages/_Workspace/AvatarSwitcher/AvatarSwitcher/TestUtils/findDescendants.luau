local FindDescendants = {}

function FindDescendants.findFirstDescendant(folder, className: string, callback)
	for _, descendant in folder:GetDescendants() do
		if descendant:IsA(className) and (callback == nil or callback(descendant)) then
			return descendant
		end
	end

	return nil
end

function FindDescendants.findAllDescendants(folder, className: string)
	local descendants = {}

	for _, descendant in folder:GetDescendants() do
		if descendant:IsA(className) then
			table.insert(descendants, descendant)
		end
	end

	return descendants
end

return FindDescendants
