local Parent = script:FindFirstAncestor("DeviceOrientationRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 5
	return {
		deviceOrientation = p1
	}
end)
