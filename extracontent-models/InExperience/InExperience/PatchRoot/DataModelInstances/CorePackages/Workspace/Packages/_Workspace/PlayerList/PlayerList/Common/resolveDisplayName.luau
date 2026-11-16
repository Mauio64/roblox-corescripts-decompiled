local function resolveDisplayName(p)
	if p.DisplayName == nil or p.DisplayName == "" then
		return p.Name
	end

	return p.DisplayName
end

return resolveDisplayName
