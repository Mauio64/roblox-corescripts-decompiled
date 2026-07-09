local SystemTheme = script:FindFirstAncestor("SystemTheme")

return function() -- line: 3
	-- upvalues: SystemTheme (copy)
	return game:GetService("SystemThemeService") and (not not game:GetService("SystemThemeService"):isSystemThemeAvailable() and require(SystemTheme.Enum.SystemThemeEnum)) or nil
end
