local Parent = script:FindFirstAncestor("SystemTheme").Parent
local t = require(Parent.t)
local t1 = {
	Light = Enum.SystemThemeValue.light,
	Dark = Enum.SystemThemeValue.dark,
	SystemLight = Enum.SystemThemeValue.systemLight,
	SystemDark = Enum.SystemThemeValue.systemDark,
	Error = Enum.SystemThemeValue.error
}

function t1.getSystemThemeEnum(p1) -- line: 26
	-- upvalues: t1 (copy), t (copy)
	for _, v in pairs(t1) do
		if t.userdata(v) and (p1 == v.Name or p1 == v.Value) then
			return v
		end
	end

	return t1.Error
end
function t1.isLightTheme(p2) -- line: 35
	-- upvalues: t1 (copy)
	return p2 == t1.Light or p2 == t1.SystemLight
end
function t1.isDarkTheme(p3) -- line: 39
	-- upvalues: t1 (copy)
	return p3 == t1.Dark or p3 == t1.SystemDark
end
function t1.isSystemTheme(p4) -- line: 43
	-- upvalues: t1 (copy)
	return p4 == t1.SystemLight or p4 == t1.SystemDark
end

return t1
