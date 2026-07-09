game:DefineFastFlag("SystemThemeLuaEnabled10", false)

local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)
local t1 = {
	Light = Enum.SystemThemeValue.light,
	Dark = Enum.SystemThemeValue.dark,
	SystemLight = Enum.SystemThemeValue.systemLight,
	SystemDark = Enum.SystemThemeValue.systemDark,
	Error = Enum.SystemThemeValue.error
}

function t1.getSystemThemeEnum(p1) -- line: 27
	-- upvalues: t1 (copy), t (copy)
	for _, v in pairs(t1) do
		if t.userdata(v) and (p1 == v.Name or p1 == v.Value) then
			return v
		end
	end

	return t1.Error
end
function t1.isLightTheme(p2) -- line: 36
	-- upvalues: t1 (copy)
	return p2 == t1.Light or p2 == t1.SystemLight
end
function t1.isDarkTheme(p3) -- line: 40
	-- upvalues: t1 (copy)
	return p3 == t1.Dark or p3 == t1.SystemDark
end
function t1.isSystemTheme(p4) -- line: 44
	-- upvalues: t1 (copy)
	return p4 == t1.SystemLight or p4 == t1.SystemDark
end

if game:GetFastFlag("SystemThemeLuaEnabled10") then
	return require(CorePackages.Workspace.Packages.SystemTheme).Enum.SystemThemeEnum
end

return t1
