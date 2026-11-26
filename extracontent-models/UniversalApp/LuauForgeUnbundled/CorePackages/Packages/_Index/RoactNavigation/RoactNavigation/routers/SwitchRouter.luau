local inspectRouteEntry = require("@luauforge/bundled/dFH").inspectRouteEntry
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/RoactNavigation")
local createConfigGetter = RoactNavigation.createConfigGetter
local getScreenForRouteName = RoactNavigation.getScreenForRouteName
local validateRouteConfigMap = RoactNavigation.validateRouteConfigMap
local stackActions = RoactNavigation.StackActions
local backBehavior = RoactNavigation.BackBehavior
local LuauPolyfill = require("@game/CorePackages/Workspace/Packages/LuauPolyfill")
local array = LuauPolyfill.Array
local object = LuauPolyfill.Object

local fFlagFixInactiveChildStateForwarding = require("@luauforge/bundled/dFE").FFlagFixInactiveChildStateForwarding

local __DEV__ = _G.__DEV__

local v5 = {
	Init = RoactNavigation.Actions.Init,
	Back = RoactNavigation.Actions.Back,
	Navigate = RoactNavigation.Actions.Navigate,
	SetParams = RoactNavigation.Actions.SetParams
}

return function(p2, options)
	local mapped = array.map(p2, function(p3)
		return (inspectRouteEntry(p3))
	end)

	local reduced = array.reduce(mapped, function(p3, p4, p5)
		p3[p4] = p5
		return p3
	end, {})

	local reduced2 = array.reduce(p2, function(p3, p4)
		local v6, v7 = inspectRouteEntry(p4)
		p3[v6] = v7
		return p3
	end, {})

	if __DEV__ then
		validateRouteConfigMap(reduced2)
	end

	local v6 = options or {}
	local initialRouteName = v6.initialRouteName or mapped[1]
	local backBehavior2 = v6.backBehavior or backBehavior.None

	if __DEV__ and reduced2[initialRouteName] == nil then
		local joined = table.concat(mapped, ", ")
		error(`Invalid initialRouteName: '{initialRouteName}'. Should be one of: {joined}`)
	end

	local v7 = {}

	local function getChildRouter(p3)
		if v7[p3] ~= nil or reduced2[p3] == nil then
			return v7[p3]
		end

		local screenForRouteName = getScreenForRouteName(reduced2, p3)

		if typeof(screenForRouteName) == "table" and screenForRouteName.router then
			v7[p3] = screenForRouteName.router
		else
			v7[p3] = false
		end

		return v7[p3]
	end

	local function initializeChildRoute(p3)
		local v8 = { key = p3, routeName = p3 }

		if v7[p3] == nil and reduced2[p3] ~= nil then
			local screenForRouteName = getScreenForRouteName(reduced2, p3)

			if typeof(screenForRouteName) == "table" and screenForRouteName.router then
				v7[p3] = screenForRouteName.router
			else
				v7[p3] = false
			end
		end

		local v9 = v7[p3]

		if v9 then
			local v10 = RoactNavigation.Actions.init()
			local stateForAction = v9.getStateForAction(v10)
			v8 = object.assign(table.clone(stateForAction), v8)
		end

		return v8
	end

	local function getInitialState()
		return {
			routes = { initializeChildRoute(initialRouteName) },
			index = 1
		}
	end

	local function getNextState(data, data2, p3)
		if
			backBehavior2 ~= backBehavior.History
			or data2 and data2.routes[data2.index].key == p3.routes[p3.index].key
		then
			return p3
		end

		local v8 = data2 and data2.routeKeyHistory or {}

		if data.type == v5.Init then
			v8 = { p3.routes[p3.index].key }
		elseif data.type == v5.Navigate then
			local key = p3.routes[p3.index].key
			v8 = table.clone(v8)
			table.insert(v8, key)
		elseif data.type == v5.Back then
			v8 = table.clone(v8)
			table.remove(v8)
		end

		return object.assign(table.clone(p3), { routeKeyHistory = v8 })
	end

	local function sortRoutes(list, p3)
		table.sort(list, function(a, b): boolean
			return reduced[a.routeName] < reduced[b.routeName]
		end)

		return array.findIndex(list, function(p4): boolean
			return p4.key == p3
		end)
	end

	return {
		childRouters = v7,
		getStateForAction = function(data, p3)
			local v8 = p3 or {
				routes = { initializeChildRoute(initialRouteName) },
				index = 1
			}

			if data.type == v5.Init then
				return getNextState(data, p3, v8)
			end

			local route = v8.routes[v8.index]
			local routeName = route.routeName

			if v7[routeName] == nil and reduced2[routeName] ~= nil then
				local screenForRouteName = getScreenForRouteName(reduced2, routeName)

				if typeof(screenForRouteName) == "table" and screenForRouteName.router then
					v7[routeName] = screenForRouteName.router
				else
					v7[routeName] = false
				end
			end

			local v9 = v7[routeName]

			if v9 then
				local stateForAction = v9.getStateForAction(data, route)

				if stateForAction == nil then
					if p3 == nil then
						return getNextState(data, nil, v8)
					end

					return nil
				elseif stateForAction ~= route then
					local clone = table.clone(v8.routes)
					clone[v8.index] = stateForAction
					return getNextState(data, p3, object.assign(table.clone(v8), {
						routes = clone
					}))
				end
			end

			if data.type == v5.Back then
				local route2 = v8.routes[v8.index]

				if data.key == nil or data.key == route2.key then
					local v10 = route2.key

					if backBehavior2 == backBehavior.InitialRoute then
						v10 = initialRouteName
					elseif backBehavior2 == backBehavior.Order then
						v10 = mapped[math.max(1, table.find(mapped, v10) - 1)]
					elseif backBehavior2 == backBehavior.History then
						local routeKeyHistory = v8.routeKeyHistory

						if #routeKeyHistory > 1 then
							v10 = routeKeyHistory[#routeKeyHistory - 1]
						end
					end

					if v10 ~= route2.key then
						local index = array.findIndex(v8.routes, function(p4): boolean
							return p4.key == v10
						end)

						if index > 0 then
							return getNextState(data, p3, object.assign(table.clone(v8), {
								index = index
							}))
						end

						local clone = table.clone(v8.routes)
						table.insert(clone, initializeChildRoute(v10))
						return getNextState(
							data,
							p3,
							object.assign(table.clone(v8), {
								routes = clone,
								index = sortRoutes(clone, v10)
							})
						)
					end
				end
			end

			if data.type == v5.Navigate then
				local routeName2 = data.routeName

				if reduced2[routeName2] ~= nil then
					local index = array.findIndex(v8.routes, function(p4): boolean
						return p4.routeName == routeName2
					end)

					local route2 = v8.routes[index]

					local v10 = if index < 0 then initializeChildRoute(routeName2) else route2

					if data.action then
						if v7[routeName2] == nil and reduced2[routeName2] ~= nil then
							local screenForRouteName = getScreenForRouteName(reduced2, routeName2)

							if typeof(screenForRouteName) == "table" and screenForRouteName.router then
								v7[routeName2] = screenForRouteName.router
							else
								v7[routeName2] = false
							end
						end

						local v11 = v7[routeName2]

						v10 = v11 and v11.getStateForAction(data.action, v10) or v10
					end

					if data.params then
						local assign = object.assign
						local clone = table.clone(v10)
						local v12

						if data.params == object.None then
							v12 = object.None
						else
							v12 = if v10.params then object.assign(table.clone(v10.params), data.params) else data.params
						end

						v10 = assign(clone, { params = v12 })
					end

					if index < 0 then
						local clone = table.clone(v8.routes)
						table.insert(clone, v10)
						return getNextState(
							data,
							p3,
							object.assign(table.clone(v8), {
								routes = clone,
								index = sortRoutes(clone, routeName2)
							})
						)
					elseif route2 == v10 then
						if v8.index ~= index then
							return getNextState(data, p3, object.assign(table.clone(v8), {
								index = index
							}))
						end

						if p3 == nil then
							return getNextState(data, nil, v8)
						end

						return nil
					else
						local clone = table.clone(v8.routes)
						clone[index] = v10
						return getNextState(
							data,
							p3,
							object.assign(table.clone(v8), {
								routes = clone,
								index = index
							})
						)
					end
				end
			end

			if data.type == v5.SetParams then
				local index = array.findIndex(v8.routes, function(p4): boolean
					return p4.key == data.key
				end)

				if index > 0 then
					local route2 = v8.routes[index]
					local v10 = object.None

					if data.params ~= object.None then
						if route2.params and data.params then
							v10 = object.assign(table.clone(route2.params), data.params)
						else
							v10 = data.params or route2.params or {}
						end
					end

					local clone = table.clone(v8.routes)
					clone[index] = object.assign(table.clone(route2), { params = v10 })

					return getNextState(data, p3, object.assign(table.clone(v8), {
						routes = clone
					}))
				end
			end

			local v10 = data.type ~= v5.Back
				and data.type ~= stackActions.Pop
				and data.type ~= stackActions.PopToTop

			if not v10 then
				v10 = data.type == v5.Back and data.key ~= nil
			end

			if not v10 then
				return v8
			end

			local v11 = v8.index
			local routes = v8.routes
			local routeName2 = routes[v11].routeName

			local reduced3 = array.reduce(routes, function(p4, p5, p6)
				p4[p5.routeName] = p6
				return p4
			end, {})

			for k, v13 in mapped do
				if v13 == routeName2 then
					continue
				end

				if v7[v13] == nil and reduced2[v13] ~= nil then
					local screenForRouteName = getScreenForRouteName(reduced2, v13)

					if typeof(screenForRouteName) == "table" and screenForRouteName.router then
						v7[v13] = screenForRouteName.router
					else
						v7[v13] = false
					end
				end

				local v14 = v7[v13]

				if not v14 then
					continue
				end

				local v15 = reduced3[v13]

				if v15 == nil then
					local v16 = initializeChildRoute(v13)
					local stateForAction = v14.getStateForAction(data, v16)

					if stateForAction then
						if stateForAction ~= v16 then
							routes = table.clone(routes)
							table.insert(routes, stateForAction)
							v11 = sortRoutes(routes, v13)
							break
						end
					else
						routes = table.clone(routes)
						table.insert(routes, v16)
						v11 = sortRoutes(routes, v13)
						break
					end
				else
					local v16 = routes[v15]
					local stateForAction = v14.getStateForAction(data, v16)

					if stateForAction then
						if stateForAction ~= v16 then
							routes = table.clone(routes)

							if fFlagFixInactiveChildStateForwarding then
								v16 = stateForAction
							end

							routes[v15] = v16
							v11 = v15
							break
						end
					else
						v11 = v15
						break
					end
				end
			end

			if data.preserveFocus then
				v11 = v8.index
			end

			if v11 ~= v8.index or routes ~= v8.routes then
				return getNextState(
					data,
					p3,
					object.assign(table.clone(v8), { index = v11, routes = routes })
				)
			end

			return v8
		end,
		getComponentForRouteName = function(p3)
			return getScreenForRouteName(reduced2, p3)
		end,
		getActionCreators = function(p3, p4)
			return (v6.getCustomActionCreators or function()
				return {}
			end)(p3, p4)
		end,
		getScreenOptions = createConfigGetter(reduced2, v6.defaultNavigationOptions)
	}
end
