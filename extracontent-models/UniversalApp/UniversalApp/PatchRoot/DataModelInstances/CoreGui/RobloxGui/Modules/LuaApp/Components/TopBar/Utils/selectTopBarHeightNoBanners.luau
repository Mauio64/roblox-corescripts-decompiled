local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Constants = require(Modules.LuaApp.Constants)

local function selectTopBarHeightNoBanners(p1) -- line: 9
	-- upvalues: Constants (copy)
	return p1.TopBar.statusBarHeight + Constants.NAV_BAR_SIZE
end

return selectTopBarHeightNoBanners
