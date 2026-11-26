local function canToggleForProbe(object, p2): boolean
	if not object then
		return not p2
	end

	local success, result = pcall(function()
		return object:IsEnabled()
	end)

	if success then
		return result == true
	end

	return not p2
end

return canToggleForProbe
