local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local InputUi = require(ProfilePlatformParent.InputUi)
local RobloxAppHooks = require(ProfilePlatformParent.RobloxAppHooks)
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local useScreenSize = RobloxAppHooks.useScreenSize
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local getSafeAreaSize = InputUi.getSafeAreaSize
local useNavBarSize = require(ProfilePlatformParent.AppNavBar).useNavBarSize
local Constants = require(ProfilePlatform.Common.Constants)

return function(b1: boolean) -- line: 13
	-- upvalues: useScreenSize (copy), useSelector (copy), getSafeAreaSize (copy), useNavBarSize (copy), Constants (copy)
	local v12 = useScreenSize()
	local v13 = useSelector(function(p1) -- line: 15
		return p1.GlobalGuiInset
	end)
	local v14 = getSafeAreaSize(v12, v13)
	local v15 = useNavBarSize()

	if b1 then
		return (math.max(Constants.MINIMUN_CONTAINER_WIDTH, (math.floor((v14.X.Offset - v15) / 3))))
	end

	return (math.min(v14.X.Offset, Constants.MAXIMUM_CONTAINER_WIDTH))
end
