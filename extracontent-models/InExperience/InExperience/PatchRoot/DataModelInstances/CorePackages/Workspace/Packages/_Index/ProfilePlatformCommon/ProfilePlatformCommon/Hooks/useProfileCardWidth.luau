local parent = script:FindFirstAncestor("ProfilePlatformCommon").Parent

local InputUi = require(parent.InputUi)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local RoactUtils = require(parent.RoactUtils)
local useScreenSize = RobloxAppHooks.useScreenSize
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local getSafeAreaSize = InputUi.getSafeAreaSize
local AppNavBar = require(parent.AppNavBar)
local useNavBarSize = AppNavBar.useNavBarSize
local Display = require(parent.Display)
local GetDisplayStore = Display.GetDisplayStore
local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader

local defineFastFlag = game:DefineFastFlag("FixIsWideModeCheck", false)

return function()
	local safeAreaSize = getSafeAreaSize(useScreenSize(), (useSelector(function(p)
		return p.GlobalGuiInset
	end)))
	local v

	if defineFastFlag then
		v = safeAreaSize.X.Offset > safeAreaSize.Y.Offset
	else
		v = GetDisplayStore(false).getDisplaySize(false) ~= Enum.DisplaySize.Small
	end

	local v2 = useNavBarSize()

	if not FFlagProfilePlatformNewProfileHeader then
		return (math.min(safeAreaSize.X.Offset, 640))
	end

	if v then
		return (math.max(456, (math.floor((safeAreaSize.X.Offset - v2) / 3))))
	end

	return (math.min(safeAreaSize.X.Offset, 640))
end
