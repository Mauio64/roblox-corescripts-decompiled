local inspectRouteEntry = require("@luauforge/bundled/dFH").inspectRouteEntry
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/RoactNavigation")
local createConfigGetter = RoactNavigation.createConfigGetter
local getScreenForRouteName = RoactNavigation.getScreenForRouteName
local validateRouteConfigMap = RoactNavigation.validateRouteConfigMap
local LuauPolyfill = require("@game/CorePackages/Workspace/Packages/LuauPolyfill")
local array = LuauPolyfill.Array
local object = LuauPolyfill.Object

local StateUtils = require("@game/CorePackages/Packages/_Index/RoactNavigation/RoactNavigation/StateUtils")

local module4 = require("@luauforge/bundled/dGw")

local __DEV__ = _G.__DEV__

local v5 = {
	Init = RoactNavigation.Actions.Init,
	Back = RoactNavigation.Actions.Back,
	Navigate = RoactNavigation.Actions.Navigate,
	SetParams = RoactNavigation.Actions.SetParams,
	Pop = RoactNavigation.StackActions.Pop,
	PopToTop = RoactNavigation.StackActions.PopToTop,
	Push = RoactNavigation.StackActions.Push,
	Reset = RoactNavigation.StackActions.Reset,
	Replace = RoactNavigation.StackActions.Replace,
	CompleteTransition = RoactNavigation.StackActions.CompleteTransition
}

local v6 = tostring(math.random(100000, 1000000))
local count = 0

local function generateKey()
	count += 1
	return `id-{v6}-{tostring(count)}`
end

local function isResetToRootStack(p2): boolean
	return p2.type == v5.Reset and p2.key == nil
end

local function getParamsForAction(p2)
	if p2.params == object.None then
		return nil
	end

	return p2.params
end

return function(p2, options)
	local mapped = array.map(p2, function(p3)
		return (inspectRouteEntry(p3))
	end)

	local reduced = array.reduce(p2, function(p3, p4)
		local v7, v8 = inspectRouteEntry(p4)
		p3[v7] = v8
		return p3
	end, {})

	if __DEV__ then
		validateRouteConfigMap(reduced)
	end

	local v7 = options or {}
	local initialRouteName = v7.initialRouteName or mapped[1]

	if __DEV__ and reduced[initialRouteName] == nil then
		local joined = table.concat(mapped, ", ")
		error(`Invalid initialRouteName: '{initialRouteName}'. Should be one of: {joined}`)
	end

	local v8 = {}

	local function getChildRouter(p3)
		if v8[p3] ~= nil or reduced[p3] == nil then
			return v8[p3]
		end

		local screenForRouteName = getScreenForRouteName(reduced, p3)

		if typeof(screenForRouteName) == "table" and screenForRouteName.router then
			v8[p3] = screenForRouteName.router
		else
			v8[p3] = false
		end

		return v8[p3]
	end

	local function getInitialState(data)
		if (data.type == v5.Navigate or data.type == v5.Push) and reduced[data.routeName] ~= nil then
			local v10 = data.key

			if not v10 then
				count += 1
				v10 = `id-{v6}-{tostring(count)}`
			end

			local v9 = { key = v10, routeName = data.routeName, params = data.params }

			local routeName = data.routeName

			if v8[routeName] == nil and reduced[routeName] ~= nil then
				local screenForRouteName = getScreenForRouteName(reduced, routeName)

				if typeof(screenForRouteName) == "table" and screenForRouteName.router then
					v8[routeName] = screenForRouteName.router
				else
					v8[routeName] = false
				end
			end

			local v11 = v8[routeName]

			if v11 then
				local action = data.action or RoactNavigation.Actions.init()
				local stateForAction = v11.getStateForAction(action)
				v9 = object.assign(table.clone(stateForAction), v9)
			end

			return {
				key = "StackRouterRoot",
				index = 1,
				routes = { v9 },
				isTransitioning = false
			}
		else
			count += 1
			local v9 = {
				key = `id-{v6}-{tostring(count)}`,
				routeName = initialRouteName
			}

			local v10 = initialRouteName

			if v8[v10] == nil and reduced[v10] ~= nil then
				local screenForRouteName = getScreenForRouteName(reduced, v10)

				if typeof(screenForRouteName) == "table" and screenForRouteName.router then
					v8[v10] = screenForRouteName.router
				else
					v8[v10] = false
				end
			end

			local v11 = v8[v10]

			if v11 then
				local v12 = RoactNavigation.Actions.init()
				local stateForAction = v11.getStateForAction(v12)
				v9 = object.assign(table.clone(stateForAction), v9)
			end

			return {
				key = "StackRouterRoot",
				index = 1,
				routes = { v9 },
				isTransitioning = false
			}
		end
	end

	local function getStateForAction(data, p3)
		local v9 = p3 or getInitialState(data)

		if not p3 then
			return v9
		end

		local route = v9.routes[v9.index]

		local v10 = module4

		if v10 then
			v10 = data.type == v5.Push and reduced[data.routeName] ~= nil
		end

		local v11, routeName, v12, v13, v14, v15, replaceAndPrune, key, v16, v17

		if v10 then
			if data.type == v5.Navigate then
				for i = #v9.routes, 1, -1 do
					v11 = v9.routes[i]
					routeName = v11.routeName

					if v8[routeName] == nil and reduced[routeName] ~= nil then
						v12 = getScreenForRouteName(reduced, routeName)

						if typeof(v12) == "table" and v12.router then
							v8[routeName] = v12.router
						else
							v8[routeName] = false
						end
					end

					v13 = v8[routeName]

					v14 = if data.routeName == v11.routeName and data.action then data.action else data

					if not v13 then
						continue
					end

					v15 = v13.getStateForAction(v14, v11)

					if v15 == nil or v15 ~= v11 then
						replaceAndPrune = StateUtils.replaceAndPrune

						key = if v15 then v15.key else v11.key
						v16 = replaceAndPrune(v9, key, v15 or v11)

						v17 = v9.isTransitioning

						if v9.index ~= v16.index then
							v17 = data.immediate ~= true
						end

						return object.assign(table.clone(v16), { isTransitioning = v17 })
					end
				end
			end
		else
			local v18 = data.type == v5.Reset and data.key == nil

			if v18 or data.type == v5.Navigate then
				if data.type == v5.Navigate then
					for i = #v9.routes, 1, -1 do
						v11 = v9.routes[i]
						routeName = v11.routeName

						if v8[routeName] == nil and reduced[routeName] ~= nil then
							v12 = getScreenForRouteName(reduced, routeName)

							if typeof(v12) == "table" and v12.router then
								v8[routeName] = v12.router
							else
								v8[routeName] = false
							end
						end

						v13 = v8[routeName]

						v14 = if data.routeName == v11.routeName and data.action then data.action else data

						if not v13 then
							continue
						end

						v15 = v13.getStateForAction(v14, v11)

						if v15 == nil or v15 ~= v11 then
							replaceAndPrune = StateUtils.replaceAndPrune

							key = if v15 then v15.key else v11.key
							v16 = replaceAndPrune(v9, key, v15 or v11)

							v17 = v9.isTransitioning

							if v9.index ~= v16.index then
								v17 = data.immediate ~= true
							end

							return object.assign(table.clone(v16), {
								isTransitioning = v17
							})
						end
					end
				end
			else
				local routeName2 = route.routeName

				if v8[routeName2] == nil and reduced[routeName2] ~= nil then
					local screenForRouteName = getScreenForRouteName(reduced, routeName2)

					if typeof(screenForRouteName) == "table" and screenForRouteName.router then
						v8[routeName2] = screenForRouteName.router
					else
						v8[routeName2] = false
					end
				end

				local v19 = v8[routeName2]

				if v19 then
					local stateForAction = v19.getStateForAction(data, route)

					if stateForAction ~= nil and stateForAction ~= route then
						return StateUtils.replaceAt(v9, route.key, stateForAction, data.type == v5.SetParams)
					end
				end
			end
		end

		if (data.type == v5.Navigate or data.type == v5.Push) and reduced[data.routeName] ~= nil then
			local routeName2 = data.routeName

			if v8[routeName2] == nil and reduced[routeName2] ~= nil then
				local screenForRouteName = getScreenForRouteName(reduced, routeName2)

				if typeof(screenForRouteName) == "table" and screenForRouteName.router then
					v8[routeName2] = screenForRouteName.router
				else
					v8[routeName2] = false
				end
			end

			local v18 = v8[routeName2]

			if __DEV__ then
				assert(
					data.type ~= v5.Push or data.key == nil,
					"StackRouter does not support key on the push action"
				)
			end

			local fn = data.key and function(p4): boolean
				return p4.key == data.key
			end or function(p4): boolean
				return p4.routeName == data.routeName
			end

			local index = array.findIndex(v9.routes, fn)

			if data.type == v5.Push or not (index > 0) then
				local v19

				if v18 then
					local v20 = data.action

					if not v20 then
						local init = RoactNavigation.Actions.init
						local v22 = if data.params ~= object.None then data.params else nil

						v20 = init({ params = v22 })
					end

					local assign = object.assign
					local v22 = if data.params ~= object.None then data.params else nil

					local stateForAction = v18.getStateForAction(v20)
					local v23 = { routeName = data.routeName, key = 0 }
					local v24 = data.key

					if not v24 then
						count += 1
						v24 = `id-{v6}-{tostring(count)}`
					end

					v23.key = v24
					v19 = assign({ params = v22 }, stateForAction, v23)
				else
					v19 = { params = 0, routeName = 0, key = 0 }
					local v20 = if data.params ~= object.None then data.params else nil

					v19.params = v20
					v19.routeName = data.routeName
					local v21 = data.key

					if not v21 then
						count += 1
						v21 = `id-{v6}-{tostring(count)}`
					end

					v19.key = v21
				end

				return object.assign(StateUtils.push(v9, v19), {
					isTransitioning = data.immediate ~= true
				})
			else
				if v9.index == index and not data.params then
					return nil
				end

				local slice = array.slice(v9.routes, 1, index + 1)

				if data.params then
					local route2 = v9.routes[index]
					local assign = object.assign
					local clone = table.clone(route2)
					local v20

					if data.params == object.None then
						v20 = object.None
					elseif route2.params then
						v20 = object.assign(table.clone(route2.params), data.params)
					else
						v20 = table.clone(data.params)
					end

					slice[index] = assign(clone, { params = v20 })
				end

				local v19 = v9.isTransitioning

				if v9.index ~= index then
					v19 = data.immediate ~= true
				end

				return object.assign(table.clone(v9), {
					isTransitioning = v19,
					index = index,
					routes = slice
				})
			end
		else
			if data.type == v5.Push and reduced[data.routeName] == nil then
				return v9
			end

			if data.type == v5.Navigate or data.type == v5.Push then
				for k in reduced do
					if v8[k] == nil and reduced[k] ~= nil then
						local screenForRouteName = getScreenForRouteName(reduced, k)

						if typeof(screenForRouteName) == "table" and screenForRouteName.router then
							v8[k] = screenForRouteName.router
						else
							v8[k] = false
						end
					end

					local v18 = v8[k]

					if not v18 then
						continue
					end

					local stateForAction = v18.getStateForAction(RoactNavigation.Actions.init())

					local stateForAction2 = v18.getStateForAction(data, stateForAction)

					local v19 = nil

					if stateForAction2 == nil then
						v19 = stateForAction
					elseif stateForAction2 ~= stateForAction then
						v19 = stateForAction2
					end

					if v19 then
						local assign = object.assign
						local clone = table.clone(v19)

						local v21 = data.key

						if not v21 then
							count += 1
							v21 = `id-{v6}-{tostring(count)}`
						end

						local v22 = assign(clone, { routeName = k, key = v21 })

						return object.assign(StateUtils.push(v9, v22), {
							isTransitioning = data.immediate ~= true
						})
					end
				end
			end

			if data.type == v5.PopToTop then
				if data.key and v9.key ~= data.key then
					return v9
				end

				if v9.index > 1 then
					return object.assign(table.clone(v9), {
						isTransitioning = data.immediate ~= true,
						index = 1,
						routes = { v9.routes[1] }
					})
				end

				return v9
			end

			if data.type == v5.Replace then
				local v18

				if data.key == nil and #v9.routes > 0 then
					v18 = #v9.routes
				else
					v18 = array.findIndex(v9.routes, function(p4): boolean
						return p4.key == data.key
					end)
				end

				if v18 > 0 then
					local routeName2 = data.routeName

					if v8[routeName2] == nil and reduced[routeName2] ~= nil then
						local screenForRouteName = getScreenForRouteName(reduced, routeName2)

						if typeof(screenForRouteName) == "table" and screenForRouteName.router then
							v8[routeName2] = screenForRouteName.router
						else
							v8[routeName2] = false
						end
					end

					local v19 = v8[routeName2]
					local v20

					if v19 then
						local v21 = data.action

						if not v21 then
							local init = RoactNavigation.Actions.init
							local v23 = if data.params ~= object.None then data.params else nil

							v21 = init({ params = v23 })
						end

						v20 = v19.getStateForAction(v21)
					else
						v20 = {}
					end

					local clone = table.clone(v9.routes)
					local assign = object.assign
					local v22 = if data.params ~= object.None then data.params else nil

					local v23 = { routeName = data.routeName, key = 0 }
					local v24 = data.newKey

					if not v24 then
						count += 1
						v24 = `id-{v6}-{tostring(count)}`
					end

					v23.key = v24
					clone[v18] = assign({ params = v22 }, v20, v23)

					return object.assign(table.clone(v9), { routes = clone })
				end
			end

			if
				data.type == v5.CompleteTransition
				and (data.key == nil or data.key == v9.key)
				and data.toChildKey == v9.routes[v9.index].key
				and v9.isTransitioning
			then
				return object.assign(table.clone(v9), { isTransitioning = false })
			end

			if data.type == v5.SetParams then
				local key2 = data.key
				local index = array.findIndex(v9.routes, function(p4): boolean
					return p4.key == key2
				end)

				if index > 0 then
					local route2 = v9.routes[index]

					local v18 = object.None

					if data.params ~= object.None then
						if route2.params and data.params then
							v18 = object.assign(table.clone(route2.params), data.params)
						elseif route2.params then
							v18 = table.clone(route2.params)
						else
							v18 = not data.params and {} or table.clone(data.params)
						end
					end

					local clone = table.clone(v9.routes)
					clone[index] = object.assign(table.clone(route2), { params = v18 })

					return object.assign(table.clone(v9), { routes = clone })
				end
			end

			if data.type == v5.Reset then
				if data.key ~= nil and data.key ~= v9.key then
					return v9
				end

				local v18 = not data.actions and {} or array.map(data.actions, function(data2)
					local routeName2 = data2.routeName

					if v8[routeName2] == nil and reduced[routeName2] ~= nil then
						local screenForRouteName = getScreenForRouteName(reduced, routeName2)

						if typeof(screenForRouteName) == "table" and screenForRouteName.router then
							v8[routeName2] = screenForRouteName.router
						else
							v8[routeName2] = false
						end
					end

					local v19 = v8[routeName2]
					local v20

					if v19 then
						local v21 = data2.action

						if not v21 then
							local init = RoactNavigation.Actions.init
							local v23 = if data2.params ~= object.None then data2.params else nil

							v21 = init({ params = v23 })
						end

						v20 = v19.getStateForAction(v21)
					else
						v20 = {}
					end

					local assign = object.assign
					local v22 = if data2.params ~= object.None then data2.params else nil

					local v23 = { routeName = data2.routeName, key = 0 }
					local v24 = data2.key

					if not v24 then
						count += 1
						v24 = `id-{v6}-{tostring(count)}`
					end

					v23.key = v24
					return assign({ params = v22 }, v20, v23)
				end)

				return object.assign(table.clone(v9), {
					routes = v18,
					index = data.index
				})
			else
				if data.type == v5.Back or data.type == v5.Pop then
					local key2 = data.key
					local n = data.n
					local immediate = data.immediate
					local prune = data.prune

					if data.type == v5.Pop and prune == false and key2 then
						local index = array.findIndex(v9.routes, function(p4): boolean
							return p4.key == key2
						end)

						if index > 0 then
							local v18 = math.max(index - (n or 1), 1)

							local joined = array.concat(
								array.slice(v9.routes, 1, v18 + 1),
								array.slice(v9.routes, index + 1)
							)

							if #joined > 0 then
								return object.assign(table.clone(v9), {
									routes = joined,
									index = #joined,
									isTransitioning = immediate ~= true
								})
							end
						end
					else
						local v18 = v9.index

						if data.type == v5.Pop and n ~= nil then
							v18 = math.max(2, v9.index - n + 1)
						elseif key2 then
							v18 = array.findIndex(v9.routes, function(p4): boolean
								return p4.key == key2
							end)
						end

						if v18 > 1 then
							return object.assign(table.clone(v9), {
								routes = array.slice(v9.routes, 1, v18),
								index = v18 - 1,
								isTransitioning = immediate ~= true
							})
						end
					end
				end

				local key2 = data.key
				local v18 = if key2 then StateUtils.indexOf(v9, key2) else nil

				for i = #v9.routes, 1, -1 do
					local route2 = v9.routes[i]

					if not (route2.key ~= route.key and (v18 == 1 or route2.key == key2)) then
						continue
					end

					local routeName2 = route2.routeName

					if v8[routeName2] == nil and reduced[routeName2] ~= nil then
						local screenForRouteName = getScreenForRouteName(reduced, routeName2)

						if typeof(screenForRouteName) == "table" and screenForRouteName.router then
							v8[routeName2] = screenForRouteName.router
						else
							v8[routeName2] = false
						end
					end

					local v19 = v8[routeName2]

					if not v19 then
						continue
					end

					local stateForAction = v19.getStateForAction(data, route2)

					if stateForAction == nil then
						return v9
					end

					if stateForAction ~= route2 then
						return StateUtils.replaceAt(v9, route2.key, stateForAction, data.preserveFocus)
					end
				end

				return v9
			end
		end
	end

	local function getComponentForRouteName(p3)
		return getScreenForRouteName(reduced, p3)
	end

	local function getActionCreators(p3, p4)
		local getCustomActionCreators = v7.getCustomActionCreators or function()
			return {}
		end

		return object.assign(table.clone(getCustomActionCreators(p3, p4)), {
			pop = function(p5, options2)
				return RoactNavigation.StackActions.pop(object.assign({ n = p5 }, options2 or {}))
			end,
			popToTop = function(p5)
				return RoactNavigation.StackActions.popToTop(p5)
			end,
			push = function(p5, p6, p7)
				return RoactNavigation.StackActions.push({
					routeName = p5,
					params = p6,
					action = p7
				})
			end,
			replace = function(value, p5, p6, p7)
				if typeof(value) == "string" then
					return RoactNavigation.StackActions.replace({
						routeName = value,
						params = p5,
						action = p6,
						key = p3.key,
						newKey = p7
					})
				end

				if __DEV__ then
					assert(typeof(value) == "table", "replaceWith must be a table or string")
					assert(p5 == nil, "params must not be provided to .replace() when specifying a table")
					assert(
						p6 == nil,
						"Child action must not be provided to .replace() when specifying a table"
					)
					assert(p7 == nil, "newKey must not be provided to .replace() when specifying a table")
				end

				return RoactNavigation.StackActions.replace(value)
			end,
			reset = function(list, p5)
				local v9 = p5 == nil and #list or p5

				return RoactNavigation.StackActions.reset({
					actions = list,
					index = v9,
					key = p4
				})
			end,
			dismiss = function()
				return RoactNavigation.Actions.back({ key = p4 })
			end
		})
	end

	return {
		childRouters = v8,
		getStateForAction = getStateForAction,
		getComponentForRouteName = getComponentForRouteName,
		getActionCreators = getActionCreators,
		getScreenOptions = createConfigGetter(reduced, v7.defaultNavigationOptions)
	}
end
