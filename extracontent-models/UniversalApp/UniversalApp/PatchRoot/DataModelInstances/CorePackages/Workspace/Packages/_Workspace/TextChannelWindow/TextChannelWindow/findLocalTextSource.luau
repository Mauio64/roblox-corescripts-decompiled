local function findLocalTextSource(p1, s1: string?) -- line: 3
	if p1 == nil or s1 == nil then
		return nil
	end

	for _, child in p1:GetChildren() do
		if child:IsA("TextSource") and s1 == tostring(child.UserId) then
			return child
		end
	end

	return nil
end

return findLocalTextSource
