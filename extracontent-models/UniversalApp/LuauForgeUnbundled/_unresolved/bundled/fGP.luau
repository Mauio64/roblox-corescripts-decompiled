local module = require("@luauforge/bundled/fGQ")

local v5 = {
	Light = Enum.SystemThemeValue.light,
	Dark = Enum.SystemThemeValue.dark,
	SystemLight = Enum.SystemThemeValue.systemLight,
	SystemDark = Enum.SystemThemeValue.systemDark,
	Error = Enum.SystemThemeValue.error
}

function v5.getSystemThemeEnum(p2)
	for k, v6 in pairs(v5) do
		if module.userdata(v6) and (v6.Name == p2 or v6.Value == p2) then
			return v6
		end
	end

	return v5.Error
end

function v5.isLightTheme(p2): boolean
	return p2 == v5.Light or p2 == v5.SystemLight
end

function v5.isDarkTheme(p2): boolean
	return p2 == v5.Dark or p2 == v5.SystemDark
end

function v5.isSystemTheme(p2): boolean
	return p2 == v5.SystemLight or p2 == v5.SystemDark
end

return v5
