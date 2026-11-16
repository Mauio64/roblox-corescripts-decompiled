local InputUi = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/InputUi")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")
local useScreenSize = RobloxAppHooks.useScreenSize
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local getSafeAreaSize = InputUi.getSafeAreaSize
local useNavBarSize = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AppNavBar").useNavBarSize
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants")

return function(p2)
	local safeAreaSize = getSafeAreaSize(useScreenSize(), (useSelector(function(p3)
		return p3.GlobalGuiInset
	end)))
	local v7 = useNavBarSize()

	if p2 then
		return (math.max(Constants.MINIMUN_CONTAINER_WIDTH, (math.floor((safeAreaSize.X.Offset - v7) / 3))))
	end

	return (math.min(safeAreaSize.X.Offset, Constants.MAXIMUM_CONTAINER_WIDTH))
end
