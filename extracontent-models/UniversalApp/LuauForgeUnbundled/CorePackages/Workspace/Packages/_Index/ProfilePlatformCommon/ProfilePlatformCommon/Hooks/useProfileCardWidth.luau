local InputUi = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatformCommon/InputUi")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatformCommon/RobloxAppHooks")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatformCommon/RoactUtils")
local useScreenSize = RobloxAppHooks.useScreenSize
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local getSafeAreaSize = InputUi.getSafeAreaSize
local useNavBarSize = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatformCommon/AppNavBar").useNavBarSize
local getDisplayStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatformCommon/Display").GetDisplayStore
local fFlagProfilePlatformNewProfileHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatformCommon/SharedFlags").FFlagProfilePlatformNewProfileHeader

local defineFastFlag = game:DefineFastFlag("FixIsWideModeCheck", false)

return function()
	local safeAreaSize = getSafeAreaSize(useScreenSize(), (useSelector(function(p2)
		return p2.GlobalGuiInset
	end)))
	local v7

	if defineFastFlag then
		v7 = safeAreaSize.X.Offset > safeAreaSize.Y.Offset
	else
		v7 = getDisplayStore(false).getDisplaySize(false) ~= Enum.DisplaySize.Small
	end

	local v8 = useNavBarSize()

	if not fFlagProfilePlatformNewProfileHeader then
		return (math.min(safeAreaSize.X.Offset, 640))
	end

	if v7 then
		return (math.max(456, (math.floor((safeAreaSize.X.Offset - v8) / 3))))
	end

	return (math.min(safeAreaSize.X.Offset, 640))
end
