local CorePackages = game:GetService("CorePackages")
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild

local function selectTopBarHeight(p1) -- line: 7
	-- upvalues: IsVRAppBuild (copy)
	if IsVRAppBuild() then
		return 0
	end

	return p1.TopBar.topBarHeight
end

return selectTopBarHeight
