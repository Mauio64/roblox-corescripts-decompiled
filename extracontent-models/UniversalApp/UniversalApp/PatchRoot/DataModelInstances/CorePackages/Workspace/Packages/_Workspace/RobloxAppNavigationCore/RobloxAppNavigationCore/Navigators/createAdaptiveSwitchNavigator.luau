local RobloxAppNavigationCore = script:FindFirstAncestor("RobloxAppNavigationCore")
local RobloxAppNavigationCoreParent = RobloxAppNavigationCore.Parent
local createNavigator = require(RobloxAppNavigationCoreParent.RoactNavigation).createNavigator

require(RobloxAppNavigationCoreParent.Navigation)

local AdaptiveSwitchView = require(RobloxAppNavigationCore.Views.AdaptiveSwitchView)
local createLazySwitchRouter = require(RobloxAppNavigationCore.Routers.createLazySwitchRouter)

local function createAdaptiveSwitchNavigator(p1, p2) -- line: 11
	-- upvalues: createLazySwitchRouter (copy), createNavigator (copy), AdaptiveSwitchView (copy)
	local v9 = createLazySwitchRouter(p1, p2)

	return createNavigator(AdaptiveSwitchView, v9, p2)
end

return createAdaptiveSwitchNavigator
