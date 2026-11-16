local function builderIcon(name: string, value: string?)
	return {
		isFoundationIcon = true,
		name = name,
		variant = value or "Regular"
	}
end

return builderIcon
