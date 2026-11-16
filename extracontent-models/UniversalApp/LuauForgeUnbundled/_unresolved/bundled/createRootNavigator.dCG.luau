local RoactNavigation = require("@game/CorePackages/Workspace/Packages/RoactNavigation")
require("@luauforge/bundled/dCC")
local module2 = require("@luauforge/bundled/dCI")
local appPage = require("@luauforge/bundled/dCF").AppPage
local isPlatformSingleSignOnSupported = require("@luauforge/bundled/dCJ").isPlatformSingleSignOnSupported
local fFlagLuaAppSkipStartupRouteHop = require("@luauforge/bundled/dCz").FFlagLuaAppSkipStartupRouteHop

local module3 = require("@luauforge/bundled/dCK")
local module4 = require("@luauforge/bundled/dDt")

local platformAccountRouter = tostring(appPage.PlatformAccountRouter)
local defineFastString = game:DefineFastString("RootNavigatorInitialRouteName", platformAccountRouter)
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")

local function fn()
	return {
		transitionSpec = { frequency = 1000000, dampingRatio = 1 }
	}
end

local function createRootNavigator(items, items2)
	local v5 = {}

	for k, item in items2 do
		v5[item] = k
	end

	local v6 = {}
	local v7 = {}

	for k, item in items do
		if v5[next(item)] ~= nil then
			table.insert(v6, item)
		else
			table.insert(v7, item)
		end
	end

	table.sort(v6, function(a, b): boolean
		local v8 = next(a)
		local v9 = next(b)
		return v5[v8] < v5[v9]
	end)

	local v8 = { [module2.Constants.TempRnSwitchNavigatorName] = module4(v6) }
	table.insert(v7, v8)

	local v11 = if fFlagLuaAppSkipStartupRouteHop and defineFastString == platformAccountRouter and not isPlatformSingleSignOnSupported(ThirdPartyUserService) then tostring(appPage.Startup) else defineFastString
	return module3(v7, {
		initialRouteName = v11,
		mode = RoactNavigation.StackPresentationStyle.Overlay,
		transitionConfig = fn,
		defaultNavigationOptions = {
			absorbInputSelectable = false,
			overlayTransparency = 0.3
		}
	})
end

return createRootNavigator
