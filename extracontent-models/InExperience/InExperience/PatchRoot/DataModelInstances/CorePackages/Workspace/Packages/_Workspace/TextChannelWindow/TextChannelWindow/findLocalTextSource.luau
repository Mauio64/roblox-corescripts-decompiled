local function findLocalTextSource(instance, p: string?)
	if instance == nil or p == nil then
		return nil
	end

	for _, textSource in instance:GetChildren() do
		if textSource:IsA("TextSource") and tostring(textSource.UserId) == p then
			return textSource
		end
	end

	return nil
end

return findLocalTextSource
