local parent = script.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object

local NavigationActions = require(parent.NavigationActions)
local StackActions = require(script.Parent.StackActions)
local KeyGenerator = require(parent.utils.KeyGenerator)
local StateUtils = require(parent.StateUtils)
local getScreenForRouteName = require(script.Parent.getScreenForRouteName)
local createConfigGetter = require(script.Parent.createConfigGetter)
local validateRouteConfigArray = require(script.Parent.validateRouteConfigArray)
local validateRouteConfigMap = require(script.Parent.validateRouteConfigMap)
local invariant = require(parent.utils.invariant)
local pathUtils = require(script.Parent.pathUtils)
local createPathParser = pathUtils.createPathParser

local ChildIsScreenRouterSymbolroblox = require(script.Parent["ChildIsScreenRouterSymbol.roblox"])

local function fn()
	return {}
end

local function behavesLikePushAction(data): boolean -- 3 equivalent calls inferred from this helper
	return data.type == NavigationActions.Navigate or data.type == StackActions.Push
end

local function isResetToRootStack(data): boolean -- 1 equivalent call inferred from this helper
	return data.type == StackActions.Reset and data.key == nil
end

local function mapToRouteName(items)
	return (next(items))
end

local function foldToRoutes(p, items, _)
	local v, v2 = next(items)
	p[v] = v2
	return p
end

return function(p, options)
	validateRouteConfigArray(p)
	local v = options or {}
	local v2 = validateRouteConfigMap(Array.reduce(p, foldToRoutes, {}))

	local order = v.order or Array.map(p, mapToRouteName)

	local v3 = {}

	for _, v4 in order do
		local v5 = v2[v4]

		if type(v5) == "table" and v5.screen then
			v5 = v5.screen
		end

		if type(v5) == "table" and v5.router then
			v3[v4] = v5.router
		else
			v3[v4] = ChildIsScreenRouterSymbolroblox
		end
	end

	local initialRouteParams = v.initialRouteParams
	local getCustomActionCreators = v.getCustomActionCreators or fn

	local initialRouteName = v.initialRouteName or order[1]

	local v4 = v3[initialRouteName]

	if Array.indexOf(order, initialRouteName) < 1 then
		local v5 = ""

		for _, v6 in order do
			v5 ..= v6 .. ","
		end

		error(string.format("Invalid initialRouteName '%s'. Must be one of [%s]", initialRouteName, v5), 2)
	end

	local function getInitialState(data)
		local v5 = {}
		local v6 = v3[data.routeName]

		if behavesLikePushAction(data) and v6 ~= nil then -- inferred equivalent call
			local v7

			if v6 == ChildIsScreenRouterSymbolroblox then
				v7 = {}
			else
				local action = data.action or NavigationActions.init({ params = data.params })
				v7 = v6.getStateForAction(action)
			end

			return {
				key = "StackRouterRoot",
				isTransitioning = false,
				index = 1,
				routes = { Object.assign({ params = data.params }, v7, {
						key = data.key or KeyGenerator.generateKey(),
						routeName = data.routeName
					}) }
			}
		else
			if v4 ~= nil and v4 ~= ChildIsScreenRouterSymbolroblox then
				v5 = v4.getStateForAction(NavigationActions.navigate({
					routeName = initialRouteName,
					params = initialRouteParams
				}))
			end

			local v7 = v2[initialRouteName]

			local v8 = type(v7) == "table" and v7.params

			local params = (v8 or v5.params or data.params or initialRouteParams)
				and Object.assign(
					not v8 and {} or table.clone(v8),
					v5.params or {},
					data.params or {},
					initialRouteParams or {}
				)

			local initialRouteKey = v.initialRouteKey
			return {
				key = "StackRouterRoot",
				isTransitioning = false,
				index = 1,
				routes = { (Object.assign(table.clone(v5), {
						params = params,
						routeName = initialRouteName,
						key = data.key or initialRouteKey or KeyGenerator.generateKey()
					})) }
			}
		end
	end

	local function getParamsForRouteAndAction(routeName, data)
		if data.params == Object.None then
			return nil
		end

		local v5 = v2[routeName]

		if type(v5) == "table" and v5.params then
			return Object.assign(table.clone(v5.params), data.params)
		end

		if data.params then
			return Object.assign({}, data.params)
		end

		return nil
	end

	local pathParser = createPathParser(v3, v2, v)
	local getPathAndParamsForRoute = pathParser.getPathAndParamsForRoute
	local getActionForPathAndParams = pathParser.getActionForPathAndParams

	local childRouters = {}

	for k, v5 in v3 do
		if v5 ~= ChildIsScreenRouterSymbolroblox then
			childRouters[k] = v5
		end
	end

	local v5 = { childRouters = childRouters, _CHILD_IS_SCREEN = ChildIsScreenRouterSymbolroblox }

	function v5.getComponentForState(p2)
		local v6 = p2.routes[p2.index] or {}
		local routeName = v6.routeName
		invariant(
			routeName,
			"There is no route defined for index '%d'. Make sure that you passed in a navigation state with a valid stack index.",
			p2.index
		)

		local v7 = v3[routeName]

		if v7 == nil or v7 == ChildIsScreenRouterSymbolroblox then
			return getScreenForRouteName(v2, routeName)
		end

		return v3[routeName].getComponentForState(v6)
	end

	function v5.getComponentForRouteName(p2)
		return getScreenForRouteName(v2, p2)
	end

	function v5.getActionCreators(p2, p3)
		return Object.assign(table.clone(getCustomActionCreators(p2, p3)), {
			pop = function(p4, options2)
				return StackActions.pop(Object.assign({ n = p4 }, options2 or {}))
			end,
			popToTop = function(p4)
				return StackActions.popToTop(p4)
			end,
			push = function(routeName, params, action)
				return StackActions.push({ routeName = routeName, params = params, action = action })
			end,
			replace = function(routeName, params, action, newKey)
				if type(routeName) == "string" then
					return StackActions.replace({
						routeName = routeName,
						params = params,
						action = action,
						key = p2.key,
						newKey = newKey
					})
				end

				invariant(type(routeName) == "table", "replaceWith must be a table or string")
				invariant(params == nil, "params must not be provided to .replace() when specifying a table")
				invariant(action == nil, "Child action must not be provided to .replace() when specifying a table")
				invariant(newKey == nil, "newKey must not be provided to .replace() when specifying a table")

				return StackActions.replace(routeName)
			end,
			reset = function(actions, p4)
				local v6 = p4 == nil and #actions or p4

				return StackActions.reset({ actions = actions, index = v6, key = p3 })
			end,
			dismiss = function()
				return NavigationActions.back({ key = p3 })
			end
		})
	end

	function v5.getStateForAction(data, data2)
		if not data2 then
			return getInitialState(data)
		end

		local route = data2.routes[data2.index]

		if isResetToRootStack(data) or data.type == NavigationActions.Navigate then -- inferred equivalent call
			if data.type == NavigationActions.Navigate then
				for i = #data2.routes, 1, -1 do
					local route2 = data2.routes[i]
					local v6 = v3[route2.routeName]
					local v7

					if data.routeName == route2.routeName and data.action then
						v7 = data.action
					else
						v7 = data
					end

					if not (v6 ~= nil and v6 ~= ChildIsScreenRouterSymbolroblox) then
						continue
					end

					local stateForAction = v6.getStateForAction(v7, route2)

					if stateForAction == nil or stateForAction ~= route2 then
						local replaceAndPrune = StateUtils.replaceAndPrune
						local v8

						if stateForAction then
							v8 = stateForAction.key
						else
							v8 = route2.key
						end

						local v9 = replaceAndPrune(data2, v8, stateForAction or route2)

						local isTransitioning = data2.isTransitioning

						if data2.index ~= v9.index then
							isTransitioning = data.immediate ~= true
						end

						return Object.assign(table.clone(v9), { isTransitioning = isTransitioning })
					end
				end
			end
		else
			local v6 = v3[route.routeName]

			if v6 ~= nil and v6 ~= ChildIsScreenRouterSymbolroblox then
				local stateForAction = v6.getStateForAction(data, route)

				if stateForAction ~= nil and stateForAction ~= route then
					return StateUtils.replaceAt(
						data2,
						route.key,
						stateForAction,
						data.type == NavigationActions.SetParams
					)
				end
			end
		end

		if behavesLikePushAction(data) and v3[data.routeName] ~= nil then -- inferred equivalent call
			local v6 = v3[data.routeName]
			invariant(
				data.type ~= StackActions.Push or data.key == nil,
				"StackRouter does not support key on the push action"
			)

			local fn2 = data.key and function(p2): boolean
				return p2.key == data.key
			end or function(p2): boolean
				return p2.routeName == data.routeName
			end

			local index = Array.findIndex(data2.routes, fn2)

			if data.type == StackActions.Push or not (index > 0) then
				local v7

				if v6 == ChildIsScreenRouterSymbolroblox then
					v7 = {
						params = getParamsForRouteAndAction(data.routeName, data),
						routeName = data.routeName,
						key = data.key or KeyGenerator.generateKey()
					}
				else
					local action = data.action
						or NavigationActions.init({
							params = getParamsForRouteAndAction(data.routeName, data)
						})

					v7 = Object.assign(
						{
							params = getParamsForRouteAndAction(data.routeName, data)
						},
						v6.getStateForAction(action),
						{
							routeName = data.routeName,
							key = data.key or KeyGenerator.generateKey()
						}
					)
				end

				return Object.assign(StateUtils.push(data2, v7), {
					isTransitioning = data.immediate ~= true
				})
			else
				if data2.index == index and not data.params then
					return nil
				end

				local slice = Array.slice(data2.routes, 1, index + 1)

				if data.params then
					local route2 = data2.routes[index]
					local assign = Object.assign
					local clone = table.clone(route2)
					local params

					if data.params == Object.None then
						params = Object.None
					elseif route2.params then
						params = Object.assign(table.clone(route2.params), data.params)
					else
						params = table.clone(data.params)
					end

					slice[index] = assign(clone, { params = params })
				end

				local isTransitioning = data2.isTransitioning

				if data2.index ~= index then
					isTransitioning = data.immediate ~= true
				end

				return Object.assign(table.clone(data2), {
					isTransitioning = isTransitioning,
					index = index,
					routes = slice
				})
			end
		else
			if data.type == StackActions.Push and v3[data.routeName] == nil then
				return data2
			end

			if behavesLikePushAction(data) then -- inferred equivalent call
				for k in v3 do
					local v6 = v3[k]

					if not (v6 ~= nil and v6 ~= ChildIsScreenRouterSymbolroblox) then
						continue
					end

					local stateForAction = v6.getStateForAction(NavigationActions.init())

					local stateForAction2 = v6.getStateForAction(data, stateForAction)

					local v7 = nil

					if stateForAction2 == nil then
						v7 = stateForAction
					elseif stateForAction2 ~= stateForAction then
						v7 = stateForAction2
					end

					if v7 then
						local v8 = Object.assign(table.clone(v7), {
							routeName = k,
							key = data.key or KeyGenerator.generateKey()
						})

						return Object.assign(StateUtils.push(data2, v8), {
							isTransitioning = data.immediate ~= true
						})
					end
				end
			end

			if data.type == StackActions.PopToTop then
				if data.key and data2.key ~= data.key then
					return data2
				end

				if data2.index > 1 then
					return Object.assign(table.clone(data2), {
						isTransitioning = data.immediate ~= true,
						index = 1,
						routes = { data2.routes[1] }
					})
				end

				return data2
			end

			if data.type == StackActions.Replace then
				local v6

				if data.key == nil and #data2.routes > 0 then
					v6 = #data2.routes
				else
					v6 = Array.findIndex(data2.routes, function(p2): boolean
						return p2.key == data.key
					end)
				end

				if v6 > 0 then
					local v7 = v3[data.routeName]
					local v8

					if v7 == nil or v7 == ChildIsScreenRouterSymbolroblox then
						v8 = {}
					else
						local action = data.action
							or NavigationActions.init({
								params = getParamsForRouteAndAction(data.routeName, data)
							})

						v8 = v7.getStateForAction(action)
					end

					local clone = table.clone(data2.routes)
					clone[v6] = Object.assign({
						params = getParamsForRouteAndAction(data.routeName, data)
					}, v8, {
						routeName = data.routeName,
						key = data.newKey or KeyGenerator.generateKey()
					})

					return Object.assign(table.clone(data2), { routes = clone })
				end
			end

			if
				data.type == StackActions.CompleteTransition
				and (data.key == nil or data.key == data2.key)
				and data.toChildKey == data2.routes[data2.index].key
				and data2.isTransitioning
			then
				return Object.assign(table.clone(data2), { isTransitioning = false })
			end

			if data.type == NavigationActions.SetParams then
				local key = data.key
				local index = Array.findIndex(data2.routes, function(p2): boolean
					return p2.key == key
				end)

				if index > 0 then
					local route2 = data2.routes[index]

					local params = Object.None

					if data.params ~= Object.None then
						if route2.params and data.params then
							params = Object.assign(table.clone(route2.params), data.params)
						elseif route2.params then
							params = table.clone(route2.params)
						else
							params = not data.params and {} or table.clone(data.params)
						end
					end

					local clone = table.clone(data2.routes)
					clone[index] = Object.assign(table.clone(route2), { params = params })

					return Object.assign(table.clone(data2), { routes = clone })
				end
			end

			if data.type == StackActions.Reset then
				if data.key ~= nil and data.key ~= data2.key then
					return data2
				end

				local routes = not data.actions and {} or Array.map(data.actions, function(data3)
					local v6 = v3[data3.routeName]
					local v7

					if v6 == nil or v6 == ChildIsScreenRouterSymbolroblox then
						v7 = {}
					else
						local action = data3.action
							or NavigationActions.init({
								params = getParamsForRouteAndAction(data3.routeName, data3)
							})

						v7 = v6.getStateForAction(action)
					end

					return Object.assign({
						params = getParamsForRouteAndAction(data3.routeName, data3)
					}, v7, {
						routeName = data3.routeName,
						key = data3.key or KeyGenerator.generateKey()
					})
				end)

				return Object.assign(table.clone(data2), { routes = routes, index = data.index })
			else
				if data.type == NavigationActions.Back or data.type == StackActions.Pop then
					local key = data.key
					local n = data.n
					local immediate = data.immediate
					local prune = data.prune

					if data.type == StackActions.Pop and prune == false and key then
						local index = Array.findIndex(data2.routes, function(p2): boolean
							return p2.key == key
						end)

						if index > 0 then
							local v6 = math.max(index - (n or 1), 1)

							local joined = Array.concat(
								Array.slice(data2.routes, 1, v6 + 1),
								Array.slice(data2.routes, index + 1)
							)

							if #joined > 0 then
								return Object.assign(table.clone(data2), {
									routes = joined,
									index = #joined,
									isTransitioning = immediate ~= true
								})
							end
						end
					else
						local v6 = data2.index

						if data.type == StackActions.Pop and n ~= nil then
							v6 = math.max(2, data2.index - n + 1)
						elseif key then
							v6 = Array.findIndex(data2.routes, function(p2): boolean
								return p2.key == key
							end)
						end

						if v6 > 1 then
							return Object.assign(table.clone(data2), {
								routes = Array.slice(data2.routes, 1, v6),
								index = v6 - 1,
								isTransitioning = immediate ~= true
							})
						end
					end
				end

				local v6

				if data.key then
					v6 = StateUtils.indexOf(data2, data.key)
				end

				for i = #data2.routes, 1, -1 do
					local route2 = data2.routes[i]

					if not (route2.key ~= route.key and (v6 == 1 or route2.key == data.key)) then
						continue
					end

					local v7 = v3[route2.routeName]

					if not (v7 ~= nil and v7 ~= ChildIsScreenRouterSymbolroblox) then
						continue
					end

					local stateForAction = v7.getStateForAction(data, route2)

					if stateForAction == nil then
						return data2
					end

					if stateForAction ~= route2 then
						return StateUtils.replaceAt(data2, route2.key, stateForAction, data.preserveFocus)
					end
				end

				return data2
			end
		end
	end

	function v5.getPathAndParamsForState(p2)
		return getPathAndParamsForRoute(p2.routes[p2.index])
	end

	function v5.getActionForPathAndParams(p2, p3)
		return getActionForPathAndParams(p2, p3)
	end

	v5.getScreenOptions = createConfigGetter(v2, v.defaultNavigationOptions)

	return v5
end
