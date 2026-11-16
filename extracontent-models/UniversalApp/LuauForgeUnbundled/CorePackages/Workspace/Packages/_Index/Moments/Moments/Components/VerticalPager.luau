local module = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager/VerticalPager")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager/createPagerStore")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager/Types")

local VerticalPagerContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager/VerticalPagerContext")

return {
	VerticalPager = module,
	createPagerStore = module2,
	useVerticalPager = VerticalPagerContext.useVerticalPager,
	usePagerItem = VerticalPagerContext.usePagerItem,
	useIsPagerItemActive = VerticalPagerContext.useIsPagerItemActive
}
