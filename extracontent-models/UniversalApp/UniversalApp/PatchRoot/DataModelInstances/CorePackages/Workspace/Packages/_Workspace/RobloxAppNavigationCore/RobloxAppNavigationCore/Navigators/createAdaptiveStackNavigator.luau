local RobloxAppNavigationCore = script:FindFirstAncestor("RobloxAppNavigationCore")
local RobloxAppNavigationCoreParent = RobloxAppNavigationCore.Parent
local createNavigator = require(RobloxAppNavigationCoreParent.RoactNavigation).createNavigator

require(RobloxAppNavigationCoreParent.Navigation)

local AdaptiveStackView = require(RobloxAppNavigationCore.Views.AdaptiveStackView)
local createLuaAppStackRouter = require(RobloxAppNavigationCore.Routers.createLuaAppStackRouter)

local function createAdaptiveStackNavigator(p1, p2) -- line: 11
	-- upvalues: createLuaAppStackRouter (copy), createNavigator (copy), AdaptiveStackView (copy)
	local v9 = createLuaAppStackRouter(p1, p2)

	return createNavigator(AdaptiveStackView, v9, p2)
end

return createAdaptiveStackNavigator
