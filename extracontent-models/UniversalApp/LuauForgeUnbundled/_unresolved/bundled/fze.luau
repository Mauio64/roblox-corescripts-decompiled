return function()
	local SystemThemeService = game:GetService("SystemThemeService")
	local v5

	if SystemThemeService then
		local SystemThemeService2 = game:GetService("SystemThemeService")
		v5 = SystemThemeService2:isSystemThemeAvailable() and require("@luauforge/bundled/fyZ") or nil
	end

	return v5
end
