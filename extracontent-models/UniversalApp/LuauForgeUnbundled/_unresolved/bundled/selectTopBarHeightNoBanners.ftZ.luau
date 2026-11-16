local module = require("@luauforge/bundled/dwA")

local function selectTopBarHeightNoBanners(p2)
	return p2.TopBar.statusBarHeight + module.NAV_BAR_SIZE
end

return selectTopBarHeightNoBanners
