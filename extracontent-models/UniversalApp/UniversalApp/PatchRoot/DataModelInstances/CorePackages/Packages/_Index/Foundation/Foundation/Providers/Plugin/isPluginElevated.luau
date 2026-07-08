local function isPluginElevated(p1) -- line: 5
	return (pcall(function() -- line: 6
		-- upvalues: p1 (copy)
		return p1:GetPluginComponent("Panels")
	end))
end

return isPluginElevated
