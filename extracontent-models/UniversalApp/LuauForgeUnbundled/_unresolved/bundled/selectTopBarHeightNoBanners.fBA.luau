local module = require("@luauforge/bundled/dzD")

local function selectTopBarHeightNoBanners(p2)
	return p2.TopBar.statusBarHeight + module.NAV_BAR_SIZE
end

return selectTopBarHeightNoBanners
