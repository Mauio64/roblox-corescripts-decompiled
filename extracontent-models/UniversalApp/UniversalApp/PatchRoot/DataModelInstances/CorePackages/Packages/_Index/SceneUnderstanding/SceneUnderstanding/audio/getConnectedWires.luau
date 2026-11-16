local function getConnectedWires(object, p: string)
	local success, result = pcall(function()
		return object:GetConnectedWires(p)
	end)

	if success then
		return result
	end

	return {}
end

return getConnectedWires
