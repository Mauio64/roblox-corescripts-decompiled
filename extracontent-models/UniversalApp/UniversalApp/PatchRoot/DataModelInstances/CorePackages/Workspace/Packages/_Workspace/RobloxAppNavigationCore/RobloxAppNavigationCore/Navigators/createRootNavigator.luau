local Parent = script:FindFirstAncestor("RobloxAppNavigationCore").Parent
local RoactNavigation = require(Parent.RoactNavigation)

require(Parent.Navigation)

local NavigationRodux = require(Parent.NavigationRodux)
local AppPage = require(Parent.RobloxAppEnums).AppPage
local createAdaptiveStackNavigator = require(script.Parent.createAdaptiveStackNavigator)
local createMainSwitchNavigator = require(script.Parent.createMainSwitchNavigator)
local v7 = game:DefineFastString("RootNavigatorInitialRouteName", (tostring(AppPage.PlatformAccountRouter)))

local function v8() -- line: 17
	return {
		transitionSpec = {
			frequency = 1000000,
			dampingRatio = 1
		}
	}
end
local function createRootNavigator(p1, t1: {[any]: any}) -- line: 30
	-- upvalues: NavigationRodux (copy), createMainSwitchNavigator (copy), createAdaptiveStackNavigator (copy), v7 (copy), RoactNavigation (copy), v8 (copy)
	local t2 = {}

	for v13, v14 in t1 do
		t2[v14] = v13
	end

	local t3 = {}
	local t4 = {}

	for _, v18 in p1 do
		if t2[next(v18)] ~= nil then
			table.insert(t3, v18)
		else
			table.insert(t4, v18)
		end
	end

	table.sort(t3, function(p2, p3) -- line: 53
		-- upvalues: t2 (copy)
		local v21 = next(p2)
		local v22 = next(p3)

		return t2[v21] < t2[v22]
	end)
	table.insert(t4, {
		[NavigationRodux.Constants.TempRnSwitchNavigatorName] = createMainSwitchNavigator(t3)
	})

	return createAdaptiveStackNavigator(t4, {
		initialRouteName = v7,
		mode = RoactNavigation.StackPresentationStyle.Overlay,
		transitionConfig = v8,
		defaultNavigationOptions = {
			absorbInputSelectable = false,
			overlayTransparency = 0.3
		}
	})
end

return createRootNavigator
