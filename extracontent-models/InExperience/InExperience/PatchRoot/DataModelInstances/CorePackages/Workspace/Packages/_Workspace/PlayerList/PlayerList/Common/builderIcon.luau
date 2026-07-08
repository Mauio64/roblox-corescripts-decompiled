local function builderIcon(s1: string, s2: string?) -- line: 1
	return {
		isFoundationIcon = true,
		name = s1,
		variant = s2 or "Regular"
	}
end

return builderIcon
