return function()
	local v5 = game:GetService("SystemThemeService")

	if v5 then
		local SystemThemeService = game:GetService("SystemThemeService")
		v5 = SystemThemeService:isSystemThemeAvailable()
	end

	return v5
end
