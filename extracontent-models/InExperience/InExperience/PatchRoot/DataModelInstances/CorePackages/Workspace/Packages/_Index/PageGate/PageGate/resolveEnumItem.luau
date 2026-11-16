local function resolveEnumItem(p: string, p2: string)
	local success, result = pcall(function()
		return Enum[p][p2]
	end)
	return if success then result else nil
end

return resolveEnumItem
