local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Signals = require(CorePackages.Packages.Signals)
local RobloxPlusTheme = require(Modules.LuaApp.Themes.RobloxPlusTheme)

local function createRobloxPlusThemeStore() -- line: 12
	-- upvalues: Signals (copy), RobloxPlusTheme (copy)
	local v6, v7 = Signals.createSignal(RobloxPlusTheme.Default)

	return {
		getColorThemeKey = v6,
		setColorThemeKey = v7
	}
end

return createRobloxPlusThemeStore
