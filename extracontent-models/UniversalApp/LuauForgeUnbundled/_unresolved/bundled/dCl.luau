local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/dCm")
local Cryo = require(CorePackages.Packages.Cryo)
local tutils = require(CorePackages.Packages.tutils)
local module2 = require("@luauforge/bundled/dCn")
local module3 = require("@luauforge/bundled/dwJ")
local module4 = require("@luauforge/bundled/dwK")
local module5 = require("@luauforge/bundled/dCo")
local module6 = require("@luauforge/bundled/dwA")
local getCurrentRouteState = require("@game/CorePackages/Workspace/Packages/Navigation").getCurrentRouteState

local getFFlagLuaAppRefactorSelectRoute = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagLuaAppRefactorSelectRoute
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")
local getLegacyPageFromRoactNavigationRoute = NavigationRodux.Utils.getLegacyPageFromRoactNavigationRoute
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local fFlagRoduxSignalsNavigationMigration = SharedFlags.FFlagRoduxSignalsNavigationMigration
local fFlagSignalsNavP2NavigationPrimitives = SharedFlags.FFlagSignalsNavP2NavigationPrimitives
local fFlagSignalsNavP3Final = SharedFlags.FFlagSignalsNavP3Final

local v5 = if fFlagRoduxSignalsNavigationMigration then require("@luauforge/bundled/dCt") else nil

local v6 = if fFlagRoduxSignalsNavigationMigration then require("@luauforge/bundled/hJh") else nil

if fFlagSignalsNavP3Final then
	local set = {}
	local function reportStraggler(p2)
		if set[p2] then
			return
		end

		set[p2] = true
		module2(string.format(
			"%s while FFlagSignalsNavP3Final is on. Navigation lock/history is owned by the Signals navigation object; use GetLegacyNavigationStore / AppNavigation signals instead.",
			p2
		))
	end

	local function describeKey(p2)
		return (string.sub(tostring(p2), 1, 64))
	end

	local v7 = nil
	local legacyCurrentRoute = nil
	local function getLegacyCurrentRoute()
		local currentRoute = v6.getCurrentRoute(false)

		if currentRoute == v7 then
			return legacyCurrentRoute
		end

		v7 = currentRoute
		legacyCurrentRoute = if currentRoute ~= nil then Cryo.Dictionary.join(currentRoute, {
			name = currentRoute.routeName,
			rnKey = currentRoute.key
		}) else nil

		return legacyCurrentRoute
	end

	local v8 = {
		history = function()
			return v6.getHistory(false)
		end,
		currentRoute = getLegacyCurrentRoute,
		lockNavigationActions = function()
			return v5.getIsNavigating(false)
		end,
		backNavigationDisableCounter = function(): number
			return 0
		end,
		roactNavigationState = function()
			return v5.getState(false)
		end
	}

	local object = setmetatable({}, {
		__index = function(p2, p3)
			local v9 = string.format("state.Navigation.%s was read", (string.sub(tostring(p3), 1, 64)))

			if not set[v9] then
				set[v9] = true
				module2(string.format(
					"%s while FFlagSignalsNavP3Final is on. Navigation lock/history is owned by the Signals navigation object; use GetLegacyNavigationStore / AppNavigation signals instead.",
					v9
				))
			end

			local v10 = v8[p3]

			if v10 then
				return (v10())
			end

			return nil
		end,
		__newindex = function(p2, p3)
			local v9 = string.format("state.Navigation.%s was written", (string.sub(tostring(p3), 1, 64)))

			if set[v9] then
				return
			end

			set[v9] = true
			module2(string.format(
				"%s while FFlagSignalsNavP3Final is on. Navigation lock/history is owned by the Signals navigation object; use GetLegacyNavigationStore / AppNavigation signals instead.",
				v9
			))
		end
	})

	local nameSet = { [module3.name] = true, [module4.name] = true }

	return function(p2, p3)
		if p3 == nil or not nameSet[p3.type] then
			return object
		end

		local v9 = string.format("%s was dispatched", (tostring(p3.type)))

		if not set[v9] then
			set[v9] = true
			module2(string.format(
				"%s while FFlagSignalsNavP3Final is on. Navigation lock/history is owned by the Signals navigation object; use GetLegacyNavigationStore / AppNavigation signals instead.",
				v9
			))
		end

		return object
	end
else
	local function getDefaultRoactNavigationState()
		return {
			routeName = module5.GetDefaultAppPage(),
			key = module5.GetDefaultAppPage()
		}
	end

	local function getDefaultRouteState()
		return {
			routeName = module5.GetDefaultAppPage(),
			key = module5.GetDefaultAppPage(),
			name = module5.GetDefaultAppPage(),
			rnKey = module5.GetDefaultAppPage()
		}
	end

	local function getDefaultRoute()
		return { getDefaultRouteState() }
	end

	local createReducer = module.createReducer
	local v7 = {
		history = not fFlagRoduxSignalsNavigationMigration and {
			{ getDefaultRouteState() }
		} or nil,
		currentRoute = 0,
		lockNavigationActions = false,
		backNavigationDisableCounter = 0,
		roactNavigationState = 0
	}
	local v8 = if not fFlagRoduxSignalsNavigationMigration then getDefaultRouteState() else nil
	v7.currentRoute = v8
	local v9 = if not fFlagRoduxSignalsNavigationMigration then getFFlagLuaAppRefactorSelectRoute() and {
		routeName = module5.GetDefaultAppPage(),
		key = module5.GetDefaultAppPage()
	} or nil else nil
	v7.roactNavigationState = v9
	local reducer = createReducer(v7, {
		[module4.name] = not fFlagSignalsNavP2NavigationPrimitives and function(p2, p3)
			if fFlagRoduxSignalsNavigationMigration then
				return Cryo.Dictionary.join(p2, {
					lockNavigationActions = p3.navigationState.isTransitioning or false
				})
			end

			local navigationState = p3.navigationState

			if navigationState and navigationState.routes and navigationState.index then
				local values = {}

				for i = 1, navigationState.index do
					local v11 = navigationState.routes[i]

					if v11.routeName == module6.TempRnSwitchNavigatorName then
						v11 = v11.routes[v11.index]
					end

					if fFlagAppIaHomeSubTab and v11.routeName == NavigationRodux.Constants.HomeContainerName then
						v11 = v11.routes[v11.index]
					end

					local v12 = if getFFlagLuaAppRefactorSelectRoute() then getLegacyPageFromRoactNavigationRoute(v11) else Cryo.Dictionary.join(v11.params or {}, {
						name = v11.routeName,
						rnKey = v11.key
					})

					table.insert(values, Cryo.List.join(values[i - 1] or {}, { v12 }))
				end

				if #values == 0 then
					module2("RN computed history is empty for action: " .. tutils.toString(p3))
					values = {
						{ getDefaultRouteState() }
					}
				end

				local v11 = getCurrentRouteState({ state = p3.navigationState }) or getDefaultRouteState()

				if not getFFlagLuaAppRefactorSelectRoute() then
					v11.name = v11.routeName
					v11.rnKey = v11.key
				end

				return Cryo.Dictionary.join(p2, {
					currentRoute = v11,
					history = values,
					lockNavigationActions = navigationState.isTransitioning or false,
					roactNavigationState = table.clone(p3.navigationState)
				})
			end

			if p2.lockNavigationActions then
				p2 = Cryo.Dictionary.join(p2, { lockNavigationActions = false })
			end

			module2("Roact Navigation state is not complete in action: " .. tutils.toString(p3))

			return p2
		end or nil,
		[module3.name] = not fFlagSignalsNavP2NavigationPrimitives and function(p2, p3)
			if p2.lockNavigationActions == p3.locked then
				return p2
			end

			return Cryo.Dictionary.join(p2, {
				lockNavigationActions = p3.locked or false
			})
		end or nil
	})

	local function NavigationReducerWrapper(p2, p3, p4)
		local join = Cryo.Dictionary.join
		local v11 = reducer(p2, p3)
		local v12 = {
			history = v6.getHistory(p4),
			currentRoute = v6.getCurrentRoute(p4),
			roactNavigationState = v5.getState(p4),
			lockNavigationActions = 0
		}

		local v13 = if fFlagSignalsNavP2NavigationPrimitives then v5.getIsNavigating(p4) else nil
		v12.lockNavigationActions = v13
		return join(v11, v12)
	end

	if fFlagRoduxSignalsNavigationMigration then
		return NavigationReducerWrapper
	end

	return reducer
end
