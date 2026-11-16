local function canToggleForProbe(object, p): boolean
	if not object then
		return not p
	end

	local success, result = pcall(function()
		return object:IsEnabled()
	end)

	if success then
		return result == true
	end

	return not p
end

return canToggleForProbe
