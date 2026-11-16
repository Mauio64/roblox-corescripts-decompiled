local function resolveEnumItem(p2, p3)
	local success, result = pcall(function()
		return Enum[p2][p3]
	end)

	if success then
		return result
	end

	return nil
end

return resolveEnumItem
