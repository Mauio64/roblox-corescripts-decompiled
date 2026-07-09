local function findDescendant(p1, p2: ((...any) -> ...any)) -- line: 1
	for _, descendant in ipairs(p1:GetDescendants()) do
		if p2(descendant) then
			return descendant
		end
	end

	return nil
end

return findDescendant
