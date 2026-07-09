local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ClassicTheme = require(Modules.LuaApp.Themes.ClassicTheme)
local DeprecatedLightTheme = require(Modules.LuaApp.Themes.DeprecatedLightTheme)
local DeprecatedDarkTheme = require(Modules.LuaApp.Themes.DeprecatedDarkTheme)
local CorePackages = game:GetService("CorePackages")
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local t1 = {
	dark = DeprecatedDarkTheme,
	light = DeprecatedLightTheme,
	classic = ClassicTheme
}

return function(p1) -- line: 18
	-- upvalues: t1 (copy), Logging (copy), ClassicTheme (copy)
	if p1 ~= nil and #p1 > 0 then
		local v9 = t1[string.lower(p1)]

		if v9 ~= nil then
			return v9
		end

		Logging.warn("Unrecognized theme name: " .. p1)
	end

	return ClassicTheme
end
