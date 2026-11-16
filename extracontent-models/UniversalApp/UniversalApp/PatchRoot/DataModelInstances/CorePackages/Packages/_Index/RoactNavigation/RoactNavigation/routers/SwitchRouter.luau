local parent = script.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object

local NavigationActions = require(parent.NavigationActions)
local BackBehavior = require(parent.BackBehavior)
local getScreenForRouteName = require(script.Parent.getScreenForRouteName)
local createConfigGetter = require(script.Parent.createConfigGetter)
local validateRouteConfigMap = require(script.Parent.validateRouteConfigMap)
local validateRouteConfigArray = require(script.Parent.validateRouteConfigArray)
local invariant = require(parent.utils.invariant)
local StackActions = require(parent.routers.StackActions)
local SwitchActions = require(script.Parent.SwitchActions)
local pathUtils = require(script.Parent.pathUtils)
local createPathParser = pathUtils.createPathParser

local function defaultActionCreators()
	return {}
end

local function mapToRouteName(items)
	return (next(items))
end

local function foldToRoutes(p, items)
	local v, v2 = next(items)
	p[v] = v2
	return p
end

return function(p, options)
	validateRouteConfigArray(p)
	options = options or {}
	local v = validateRouteConfigMap(Array.reduce(p, foldToRoutes, {}))

	local order = options.order or Array.map(p, mapToRouteName)

	local getCustomActionCreators = options.getCustomActionCreators or defaultActionCreators

	local initialRouteParams = options.initialRouteParams
	local initialRouteName = options.initialRouteName or order[1]
	local backBehavior = options.backBehavior or BackBehavior.None

	local v2 = options.resetOnBlur == nil or options.resetOnBlur

	local index = Array.indexOf(order, initialRouteName)

	if index < 1 then
		local joined = table.concat(Array.map(order, function(p2)
			return ("\"%s\""):format(p2)
		end), ", ")

		error(("Invalid initialRouteName '%s'. Should be one of %s"):format(initialRouteName, joined), 2)
	end

	local childRouters = {}

	for _, v3 in order do
		local screenForRouteName = getScreenForRouteName(v, v3)

		if type(screenForRouteName) == "table" and screenForRouteName.router then
			childRouters[v3] = screenForRouteName.router
		else
			childRouters[v3] = false
		end
	end

	local function getParamsForRoute(p2, p3) -- 1 equivalent call inferred from this helper
		local v3 = v[p2]

		if type(v3) ~= "table" or not v3.params then
			return p3
		end

		if p3 then
			return (Object.assign(table.clone(v3.params), p3))
		end

		return (table.clone(v3.params))
	end

	local pathParser = createPathParser(childRouters, v, options)
	local getPathAndParamsForRoute = pathParser.getPathAndParamsForRoute
	local getActionForPathAndParams = pathParser.getActionForPathAndParams

	local function resetChildRoute(routeName)
		local params

		if routeName == initialRouteName then
			params = initialRouteParams
		end

		params = getParamsForRoute(routeName, params) -- inferred equivalent call
		local v3 = childRouters[routeName]

		if not v3 then
			return { key = routeName, routeName = routeName, params = params }
		end

		local v4 = NavigationActions.init()
		return Object.assign(table.clone(v3.getStateForAction(v4)), {
			key = routeName,
			routeName = routeName,
			params = params
		})
	end

	local function getNextState(data, clone, p2)
		if clone and p2 and clone.index ~= p2.index and v2 then
			local routeName = clone.routes[clone.index].routeName
			local clone2 = table.clone(p2.routes)
			clone2[clone.index] = resetChildRoute(routeName)
			p2 = Object.assign(table.clone(p2), { routes = clone2 })
		end

		if backBehavior ~= BackBehavior.History or clone and p2 and p2.index == clone.index then
			return p2
		end

		local filtered = not clone and {} or clone.routeKeyHistory

		if data.type == NavigationActions.Navigate then
			local key = p2.routes[p2.index].key
			filtered = Array.filter(filtered, function(p3): boolean
				return p3 ~= key
			end)

			table.insert(filtered, key)
		elseif data.type == NavigationActions.Back then
			filtered = table.clone(filtered)
			table.remove(filtered, #filtered)
		end

		return Object.assign(table.clone(p2), { routeKeyHistory = filtered })
	end

	local function getInitialState()
		local mapped = Array.map(order, resetChildRoute)
		local initialState = { routes = mapped, index = index }

		if backBehavior == BackBehavior.History then
			initialState.routeKeyHistory = { mapped[index].key }
		end

		return initialState
	end

	local v3 = {
		childRouters = childRouters,
		getActionCreators = function(p2, p3)
			return getCustomActionCreators(p2, p3)
		end,
		getScreenOptions = createConfigGetter(v, options.defaultNavigationOptions)
	}

	function v3.getStateForAction(data, p2)
		local clone

		if p2 then
			clone = table.clone(p2)
		end

		local v4 = p2 or getInitialState()
		local v5 = v4.index

		local params = data.type == NavigationActions.Init and data.params

		if params then
			v4.routes = Array.map(v4.routes, function(p3)
				local v6 = p3.routeName == initialRouteName and initialRouteParams or {}
				local assign = Object.assign
				local clone2 = table.clone(p3)
				local params2

				if p3.params then
					params2 = Object.assign(table.clone(p3.params), params, v6)
				else
					params2 = Object.assign(table.clone(params), v6)
				end

				return assign(clone2, { params = params2 })
			end)
		end

		if data.type == SwitchActions.JumpTo and (data.key == nil or data.key == v4.key) then
			local params2 = data.params
			local index2 = Array.findIndex(v4.routes, function(p3): boolean
				return p3.routeName == data.routeName
			end)

			if index2 < 1 then
				error(("There is no route named '%s' in the navigator with the key '%s'.\n"):format(
					data.routeName,
					data.key
				) .. "Must be one of: " .. table.concat(Array.map(v4.routes, function(p3)
					return p3.routeName
				end), ","))
			end

			local routes = v4.routes

			if params2 then
				return v4.routes.map(function(p3, p4)
					if p4 == index2 then
						return Object.assign(table.clone(p3), {
							params = Object.assign(table.clone(p3.params), params2)
						})
					end

					return p3
				end)
			end

			return getNextState(data, clone, Object.assign(table.clone(v4), {
				routes = routes,
				index = index2
			}))
		else
			local route = v4.routes[v4.index]
			local v6 = childRouters[order[v4.index]]

			if v6 then
				local stateForAction = v6.getStateForAction(data, route)

				if not stateForAction and p2 then
					return nil
				end

				if stateForAction and stateForAction ~= route then
					local clone2 = table.clone(v4.routes)
					clone2[v4.index] = stateForAction
					return getNextState(data, clone, Object.assign(table.clone(v4), {
						routes = clone2
					}))
				end
			end

			local v7 = data.key == nil or data.key == route.key

			if data.type == NavigationActions.Back then
				if v7 and backBehavior == BackBehavior.InitialRoute then
					v5 = index
				elseif v7 and backBehavior == BackBehavior.Order then
					v5 = math.max(1, v5 - 1)
				elseif v7 and backBehavior == BackBehavior.History and #v4.routeKeyHistory > 1 then
					local v8 = v4.routeKeyHistory[#v4.routeKeyHistory - 1]
					v5 = Array.indexOf(order, v8)
				end
			end

			local v8

			if data.type == NavigationActions.Navigate then
				v8 = Array.find(order, function(p3, p4): boolean
					if p3 ~= data.routeName then
						return false
					end

					v5 = p4
					return true
				end) ~= nil

				if v8 then
					local route2 = v4.routes[v5]
					local v9 = childRouters[data.routeName]
					local v10 = route2

					v10 = data.action and v9 and v9.getStateForAction(data.action, route2) or v10

					if data.params then
						local assign = Object.assign
						local clone2 = table.clone(v10)
						local params2

						if data.params == Object.None then
							params2 = Object.None
						elseif v10.params then
							params2 = Object.assign(table.clone(v10.params), data.params)
						else
							params2 = table.clone(data.params)
						end

						v10 = assign(clone2, { params = params2 })
					end

					if v10 == route2 then
						if v10 == route2 and v4.index == v5 and clone then
							return nil
						end
					else
						local clone2 = table.clone(v4.routes)
						clone2[v5] = v10
						return getNextState(
							data,
							clone,
							Object.assign(table.clone(v4), { routes = clone2, index = v5 })
						)
					end
				end
			else
				v8 = false
			end

			if data.type == NavigationActions.SetParams then
				local key = data.key
				local index2 = Array.findIndex(v4.routes, function(p3): boolean
					return p3.key == key
				end)

				if index2 > 0 then
					local route2 = v4.routes[index2]

					local params2 = Object.None

					if data.params ~= Object.None then
						if route2.params and data.params then
							params2 = Object.assign(table.clone(route2.params), data.params)
						elseif route2.params then
							params2 = table.clone(route2.params)
						else
							params2 = not data.params and {} or table.clone(data.params)
						end
					end

					local clone2 = table.clone(v4.routes)

					clone2[index2] = Object.assign(table.clone(route2), { params = params2 })

					return getNextState(data, clone, Object.assign(table.clone(v4), {
						routes = clone2
					}))
				end
			end

			if v5 ~= v4.index then
				return getNextState(data, clone, Object.assign(table.clone(v4), { index = v5 }))
			end

			if v8 and not p2 then
				return v4
			end

			if v8 then
				return table.clone(v4)
			end

			local v9 = data.type ~= NavigationActions.Back
				and data.type ~= StackActions.Pop
				and data.type ~= StackActions.PopToTop

			if not v9 then
				if data.type == NavigationActions.Back then
					v9 = data.key ~= nil
				else
					v9 = false
				end
			end

			if not v9 then
				return v4
			end

			local v10 = v4.index
			local routes = v4.routes
			Array.find(order, function(p3, p4): boolean
				local v11 = childRouters[p3]

				if p4 == v10 then
					return false
				end

				local route2 = routes[p4]

				if v11 then
					route2 = v11.getStateForAction(data, route2)
				end

				if not route2 then
					v10 = p4
					return true
				end

				if route2 == routes[p4] then
					return false
				end

				routes = table.clone(routes)
				routes[p4] = route2
				v10 = p4
				return true
			end)

			if data.preserveFocus then
				v10 = v4.index
			end

			if v10 ~= v4.index or routes ~= v4.routes then
				return getNextState(data, clone, Object.assign(table.clone(v4), {
					index = v10,
					routes = routes
				}))
			end

			return v4
		end
	end

	function v3.getComponentForState(p2)
		local routeName = (p2.routes[p2.index] or {}).routeName
		invariant(
			routeName,
			"There is no route defined for index '%d'. Check that you passed in a navigation state with a valid tab/screen index.",
			p2.index
		)

		local v4 = childRouters[routeName]

		if v4 then
			return v4.getComponentForState(p2.routes[p2.index])
		end

		return getScreenForRouteName(v, routeName)
	end

	function v3.getComponentForRouteName(p2)
		return getScreenForRouteName(v, p2)
	end

	function v3.getPathAndParamsForState(p2)
		return getPathAndParamsForRoute(p2.routes[p2.index])
	end

	function v3.getActionForPathAndParams(p2, p3)
		return getActionForPathAndParams(p2, p3)
	end

	return v3
end
