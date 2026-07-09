local Modules = game:GetService("CoreGui").RobloxGui.Modules
local GetFFlagUseNonYieldGetSystemTheme = require(Modules.LuaApp.Flags.GetFFlagUseNonYieldGetSystemTheme)

return function(p1) -- line: 5
	-- upvalues: GetFFlagUseNonYieldGetSystemTheme (copy)
	if GetFFlagUseNonYieldGetSystemTheme() then
		return p1:getSystemTheme()
	end

	return p1:getSystemThemeAsync()
end
