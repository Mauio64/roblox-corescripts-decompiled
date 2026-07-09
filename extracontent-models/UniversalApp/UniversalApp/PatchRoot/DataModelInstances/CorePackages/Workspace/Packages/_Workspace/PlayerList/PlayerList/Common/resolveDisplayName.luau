local function resolveDisplayName(p1) -- line: 1
	if p1.DisplayName ~= nil and p1.DisplayName ~= "" then
		return p1.DisplayName
	end

	return p1.Name
end

return resolveDisplayName
