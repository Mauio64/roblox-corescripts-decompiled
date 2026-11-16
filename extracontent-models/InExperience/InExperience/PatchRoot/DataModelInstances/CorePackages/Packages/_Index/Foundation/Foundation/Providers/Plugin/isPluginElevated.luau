local function isPluginElevated(object)
	return (pcall(function()
		return object:GetPluginComponent("Panels")
	end))
end

return isPluginElevated
