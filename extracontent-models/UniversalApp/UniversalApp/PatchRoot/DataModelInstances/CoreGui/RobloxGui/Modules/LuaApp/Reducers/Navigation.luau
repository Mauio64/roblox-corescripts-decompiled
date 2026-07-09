local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(Modules.Common.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local tutils = require(CorePackages.Packages.tutils)
local mutedError = require(Modules.LuaApp.mutedError)
local ApplySetNavigationLocked = require(Modules.LuaApp.Actions.ApplySetNavigationLocked)
local SetBackNavigationDisabled = require(Modules.LuaApp.Actions.SetBackNavigationDisabled)
local ApplyRoactNavigationHistory = require(Modules.LuaApp.Actions.ApplyRoactNavigationHistory)
local FlagSettings = require(Modules.LuaApp.FlagSettings)
local Constants = require(Modules.LuaApp.Constants)
local getCurrentRouteState = require(CorePackages.Workspace.Packages.Navigation).getCurrentRouteState
local GetFFlagLuaAppRefactorSelectRoute = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagLuaAppRefactorSelectRoute
local NavigationRodux = require(CorePackages.Workspace.Packages.NavigationRodux)
local getLegacyPageFromRoactNavigationRoute = NavigationRodux.Utils.getLegacyPageFromRoactNavigationRoute
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local FFlagUseBackDisableSignalStore = SharedFlags.FFlagUseBackDisableSignalStore
local FFlagRoduxSignalsNavigationMigration = SharedFlags.FFlagRoduxSignalsNavigationMigration
local FFlagSignalsNavP2NavigationPrimitives = SharedFlags.FFlagSignalsNavP2NavigationPrimitives
local v21 = if not FFlagRoduxSignalsNavigationMigration then nil else require(Modules.LuaApp.Navigation.AppNavigation)
local v22 = if not FFlagRoduxSignalsNavigationMigration then nil else require(Modules.LuaApp.Navigation.LegacyNavigationStore)

local function getDefaultRoactNavigationState() -- line: 31
	-- upvalues: FlagSettings (copy)
	return {
		routeName = FlagSettings.GetDefaultAppPage(),
		key = FlagSettings.GetDefaultAppPage()
	}
end
local function getDefaultRouteState() -- line: 39
	-- upvalues: FlagSettings (copy)
	return {
		routeName = FlagSettings.GetDefaultAppPage(),
		key = FlagSettings.GetDefaultAppPage(),
		name = FlagSettings.GetDefaultAppPage(),
		rnKey = FlagSettings.GetDefaultAppPage()
	}
end
local function getDefaultRoute() -- line: 48
	-- upvalues: getDefaultRouteState (copy)
	return { (getDefaultRouteState()) }
end

local v26 = Rodux.createReducer({
	lockNavigationActions = false,
	backNavigationDisableCounter = 0,
	history = if not FFlagRoduxSignalsNavigationMigration then {{ (getDefaultRouteState()) }} else nil,
	currentRoute = if not FFlagRoduxSignalsNavigationMigration then getDefaultRouteState() else nil,
	roactNavigationState = if not FFlagRoduxSignalsNavigationMigration then if not GetFFlagLuaAppRefactorSelectRoute() then nil else {
		routeName = FlagSettings.GetDefaultAppPage(),
		key = FlagSettings.GetDefaultAppPage()
	} else nil
}, {
	[ApplyRoactNavigationHistory.name] = not FFlagSignalsNavP2NavigationPrimitives and function(p1, p2) -- line: 64
		-- upvalues: FFlagRoduxSignalsNavigationMigration (copy), Cryo (copy), mutedError (copy), tutils (copy), Constants (copy), FFlagAppIaHomeSubTab (copy), NavigationRodux (copy), GetFFlagLuaAppRefactorSelectRoute (copy), getLegacyPageFromRoactNavigationRoute (copy), getDefaultRouteState (copy), getCurrentRouteState (copy)
		if FFlagRoduxSignalsNavigationMigration then
			return Cryo.Dictionary.join(p1, {
				lockNavigationActions = p2.navigationState.isTransitioning or false
			})
		end

		local navigationState = p2.navigationState

		if not navigationState or not navigationState.routes or not navigationState.index then
			if p1.lockNavigationActions then
				p1 = Cryo.Dictionary.join(p1, {
					lockNavigationActions = false
				})
			end

			mutedError("Roact Navigation state is not complete in action: " .. tutils.toString(p2))

			return p1
		end

		local t1 = {}

		for i = 1, navigationState.index do
			local v33 = navigationState.routes[i]

			if v33.routeName == Constants.TempRnSwitchNavigatorName then
				v33 = v33.routes[v33.index]
			end

			if FFlagAppIaHomeSubTab and v33.routeName == NavigationRodux.Constants.HomeContainerName then
				v33 = v33.routes[v33.index]
			end

			local v34 = if not GetFFlagLuaAppRefactorSelectRoute() then Cryo.Dictionary.join(v33.params or {}, {
				name = v33.routeName,
				rnKey = v33.key
			}) else getLegacyPageFromRoactNavigationRoute(v33)

			table.insert(t1, Cryo.List.join(t1[i - 1] or {}, { v34 }))
		end

		if #t1 == 0 then
			mutedError("RN computed history is empty for action: " .. tutils.toString(p2))
			t1 = {{ (getDefaultRouteState()) }}
		end

		local v35 = getCurrentRouteState({
			state = p2.navigationState
		}) or getDefaultRouteState()

		if not GetFFlagLuaAppRefactorSelectRoute() then
			v35.name = v35.routeName
			v35.rnKey = v35.key
		end

		return Cryo.Dictionary.join(p1, {
			currentRoute = v35,
			history = t1,
			lockNavigationActions = navigationState.isTransitioning or false,
			roactNavigationState = table.clone(p2.navigationState)
		})
	end or nil,
	[ApplySetNavigationLocked.name] = not FFlagSignalsNavP2NavigationPrimitives and function(p3, p4) -- line: 136
		-- upvalues: Cryo (copy)
		if p3.lockNavigationActions == p4.locked then
			return p3
		end

		return Cryo.Dictionary.join(p3, {
			lockNavigationActions = p4.locked or false
		})
	end or nil,
	[SetBackNavigationDisabled.name] = not FFlagUseBackDisableSignalStore and function(p5, p6) -- line: 147
		-- upvalues: Cryo (copy)
		local v40 = p6.disabled and p5.backNavigationDisableCounter + 1 or math.max(p5.backNavigationDisableCounter - 1, 0)

		return Cryo.Dictionary.join(p5, {
			backNavigationDisableCounter = v40
		})
	end or nil
})

local function NavigationReducerWrapper(p7, p8, p9) -- line: 157
	-- upvalues: Cryo (copy), v26 (copy), v22 (copy), v21 (copy), FFlagSignalsNavP2NavigationPrimitives (copy)
	return Cryo.Dictionary.join(v26(p7, p8), {
		history = v22.getHistory(p9),
		currentRoute = v22.getCurrentRoute(p9),
		roactNavigationState = v21.getState(p9),
		lockNavigationActions = if not FFlagSignalsNavP2NavigationPrimitives then nil else v21.getIsNavigating(p9)
	})
end

if FFlagRoduxSignalsNavigationMigration then
	return NavigationReducerWrapper
end

return v26
