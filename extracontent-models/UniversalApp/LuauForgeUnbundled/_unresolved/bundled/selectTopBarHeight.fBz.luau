local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild

local function selectTopBarHeight(p2)
	if isVRAppBuild() then
		return 0
	end

	return p2.TopBar.topBarHeight
end

return selectTopBarHeight
