local Parent = script:FindFirstAncestor("ProfilePlatformCommon").Parent
local InputUi = require(Parent.InputUi)
local RobloxAppHooks = require(Parent.RobloxAppHooks)
local RoactUtils = require(Parent.RoactUtils)
local useScreenSize = RobloxAppHooks.useScreenSize
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local getSafeAreaSize = InputUi.getSafeAreaSize
local useNavBarSize = require(Parent.AppNavBar).useNavBarSize
local GetDisplayStore = require(Parent.Display).GetDisplayStore
local FFlagProfilePlatformNewProfileHeader = require(Parent.SharedFlags).FFlagProfilePlatformNewProfileHeader
local v11 = game:DefineFastFlag("FixIsWideModeCheck", false)

return function() -- line: 19
	-- upvalues: useScreenSize (copy), useSelector (copy), getSafeAreaSize (copy), v11 (copy), GetDisplayStore (copy), useNavBarSize (copy), FFlagProfilePlatformNewProfileHeader (copy)
	local v12 = useScreenSize()
	local v13 = useSelector(function(p1) -- line: 21
		return p1.GlobalGuiInset
	end)
	local v14 = getSafeAreaSize(v12, v13)
	local v15 = if not v11 then GetDisplayStore(false).getDisplaySize(false) ~= Enum.DisplaySize.Small else v14.X.Offset > v14.Y.Offset
	local v16 = useNavBarSize()

	if FFlagProfilePlatformNewProfileHeader then
		if v15 then
			return (math.max(456, (math.floor((v14.X.Offset - v16) / 3))))
		end

		return (math.min(v14.X.Offset, 640))
	end

	return (math.min(v14.X.Offset, 640))
end
