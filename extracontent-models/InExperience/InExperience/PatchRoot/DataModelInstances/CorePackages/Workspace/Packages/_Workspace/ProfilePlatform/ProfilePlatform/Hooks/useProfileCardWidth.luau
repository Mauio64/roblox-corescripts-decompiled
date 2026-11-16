local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local InputUi = require(parent.InputUi)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local RoactUtils = require(parent.RoactUtils)
local useScreenSize = RobloxAppHooks.useScreenSize
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local getSafeAreaSize = InputUi.getSafeAreaSize
local AppNavBar = require(parent.AppNavBar)
local useNavBarSize = AppNavBar.useNavBarSize
local Constants = require(ProfilePlatform.Common.Constants)

return function(flag: boolean)
	local safeAreaSize = getSafeAreaSize(useScreenSize(), (useSelector(function(p)
		return p.GlobalGuiInset
	end)))
	local v = useNavBarSize()

	if flag then
		return (math.max(Constants.MINIMUN_CONTAINER_WIDTH, (math.floor((safeAreaSize.X.Offset - v) / 3))))
	end

	return (math.min(safeAreaSize.X.Offset, Constants.MAXIMUM_CONTAINER_WIDTH))
end
