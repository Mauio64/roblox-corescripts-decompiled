local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local NavigationActions = require(ParentParent.NavigationActions)
local BackBehavior = require(ParentParent.BackBehavior)
local getScreenForRouteName = require(script.Parent.getScreenForRouteName)
local createConfigGetter = require(script.Parent.createConfigGetter)
local validateRouteConfigMap = require(script.Parent.validateRouteConfigMap)
local validateRouteConfigArray = require(script.Parent.validateRouteConfigArray)
local invariant = require(ParentParent.utils.invariant)
local StackActions = require(ParentParent.routers.StackActions)
local SwitchActions = require(script.Parent.SwitchActions)
local createPathParser = require(script.Parent.pathUtils).createPathParser

local function defaultActionCreators() -- line: 20
	return {}
end
local function mapToRouteName(p1) -- line: 24
	return (next(p1))
end
local function foldToRoutes(p2, p3) -- line: 29
	local v22, v23 = next(p3)

	p2[v22] = v23

	return p2
end

return function(p4, p5) -- line: 35
	-- upvalues: validateRouteConfigArray (copy), validateRouteConfigMap (copy), Array (copy), foldToRoutes (copy), mapToRouteName (copy), defaultActionCreators (copy), BackBehavior (copy), getScreenForRouteName (copy), Object (copy), createPathParser (copy), NavigationActions (copy), createConfigGetter (copy), SwitchActions (copy), StackActions (copy), invariant (copy)
	validateRouteConfigArray(p4)

	local v26 = p5 or {}
	local v27 = validateRouteConfigMap(Array.reduce(p4, foldToRoutes, {}))
	local v28 = v26.order or Array.map(p4, mapToRouteName)
	local v29 = v26.getCustomActionCreators or defaultActionCreators
	local initialRouteParams = v26.initialRouteParams
	local v31 = v26.initialRouteName or v28[1]
	local v32 = v26.backBehavior or BackBehavior.None
	local u33 = v26.resetOnBlur == nil or v26.resetOnBlur
	local v34 = Array.indexOf(v28, v31)

	if v34 < 1 then
		local v35 = table.concat(Array.map(v28, function(p6) -- line: 61
			return ("\"%s\""):format(p6)
		end), ", ")

		error(("Invalid initialRouteName '%s'. Should be one of %s"):format(v31, v35), 2)
	end

	local t1 = {}

	for _, v38 in v28 do
		local v39 = getScreenForRouteName(v27, v38)

		if type(v39) == "table" and v39.router then
			t1[v38] = v39.router
		else
			t1[v38] = false
		end
	end

	local function getParamsForRoute(p7, p8) -- line: 80
		-- upvalues: v27 (copy), Object (copy)
		local v50 = v27[p7]

		if type(v50) == "table" and v50.params then
			if p8 then
				return (Object.assign(table.clone(v50.params), p8))
			end

			return (table.clone(v50.params))
		end

		return p8
	end

	local v41 = createPathParser(t1, v27, v26)
	local getPathAndParamsForRoute = v41.getPathAndParamsForRoute
	local getActionForPathAndParams = v41.getActionForPathAndParams

	local function resetChildRoute(p9) -- line: 95
		-- upvalues: v31 (copy), initialRouteParams (copy), v27 (copy), Object (copy), t1 (copy), NavigationActions (copy)
		local v52 = if p9 ~= v31 then nil else initialRouteParams
		local v53 = v27[p9]
		local v54 = if type(v53) ~= "table" or not v53.params then v52 else if not v52 then table.clone(v53.params) else Object.assign(table.clone(v53.params), v52)
		local v55 = t1[p9]

		if v55 then
			local v56 = NavigationActions.init()

			return Object.assign(table.clone(v55.getStateForAction(v56)), {
				key = p9,
				routeName = p9,
				params = v54
			})
		end

		return {
			key = p9,
			routeName = p9,
			params = v54
		}
	end
	local function getNextState(p10, p11, p12) -- line: 118
		-- upvalues: u33 (ref), resetChildRoute (copy), Object (copy), v32 (copy), BackBehavior (copy), NavigationActions (copy), Array (copy)
		if p11 and (p12 and p11.index ~= p12.index and u33) then
			local routeName = p11.routes[p11.index].routeName
			local v61 = table.clone(p12.routes)

			v61[p11.index] = resetChildRoute(routeName)
			p12 = Object.assign(table.clone(p12), {
				routes = v61
			})
		end

		if v32 ~= BackBehavior.History or p11 and p12 and p12.index == p11.index then
			return p12
		end

		local v62 = if not p11 then {} else p11.routeKeyHistory

		if p10.type == NavigationActions.Navigate then
			local key = p12.routes[p12.index].key

			v62 = Array.filter(v62, function(p13) -- line: 136
				-- upvalues: key (copy)
				return p13 ~= key
			end)
			table.insert(v62, key)
		elseif p10.type == NavigationActions.Back then
			v62 = table.clone(v62)
			table.remove(v62, #v62)
		end

		return Object.assign(table.clone(p12), {
			routeKeyHistory = v62
		})
	end
	local function getInitialState() -- line: 148
		-- upvalues: Array (copy), v28 (copy), resetChildRoute (copy), v34 (copy), v32 (copy), BackBehavior (copy)
		local v64 = Array.map(v28, resetChildRoute)
		local t2 = {
			routes = v64,
			index = v34
		}

		if v32 == BackBehavior.History then
			t2.routeKeyHistory = { v64[v34].key }
		end

		return t2
	end

	return {
		childRouters = t1,
		getActionCreators = function(p14, p15) -- line: 165
			-- upvalues: v29 (copy)
			return v29(p14, p15)
		end,
		getScreenOptions = createConfigGetter(v27, v26.defaultNavigationOptions),
		getStateForAction = function(p16, p17) -- line: 171
			-- upvalues: getInitialState (copy), NavigationActions (copy), Array (copy), v31 (copy), initialRouteParams (copy), Object (copy), SwitchActions (copy), getNextState (copy), t1 (copy), v28 (copy), v32 (copy), BackBehavior (copy), v34 (copy), StackActions (copy)
			local v70 = if not p17 then nil else table.clone(p17)
			local v71 = p17 or getInitialState()
			local index = v71.index

			if p16.type == NavigationActions.Init then
				local params = p16.params

				if params then
					v71.routes = Array.map(v71.routes, function(p18) -- line: 181
						-- upvalues: v31 (copy), initialRouteParams (copy), Object (copy), params (copy)
						local v107 = p18.routeName == v31 and initialRouteParams or {}

						return Object.assign(table.clone(p18), {
							params = if not p18.params then Object.assign(table.clone(params), v107) else Object.assign(table.clone(p18.params), params, v107)
						})
					end)
				end
			end

			if p16.type == SwitchActions.JumpTo and (p16.key == nil or p16.key == v71.key) then
				local params = p16.params
				local v75 = Array.findIndex(v71.routes, function(p19) -- line: 194
					-- upvalues: p16 (copy)
					return p19.routeName == p16.routeName
				end)

				if v75 < 1 then
					error(("There is no route named '%s' in the navigator with the key '%s'.\n"):format(p16.routeName, p16.key) .. "Must be one of: " .. table.concat(Array.map(v71.routes, function(p20) -- line: 206
						return p20.routeName
					end), ","))
				end

				local routes = v71.routes

				if params then
					return v71.routes.map(function(p21, p22) -- line: 216
						-- upvalues: v75 (copy), Object (copy), params (copy)
						if p22 == v75 then
							return Object.assign(table.clone(p21), {
								params = Object.assign(table.clone(p21.params), params)
							})
						end

						return p21
					end)
				end

				return getNextState(p16, v70, Object.assign(table.clone(v71), {
					routes = routes,
					index = v75
				}))
			end

			local v77 = v71.routes[v71.index]
			local v78 = t1[v28[v71.index]]

			if v78 then
				local v79 = v78.getStateForAction(p16, v77)

				if not v79 and p17 then
					return nil
				end

				if v79 and v79 ~= v77 then
					local v80 = table.clone(v71.routes)

					v80[v71.index] = v79

					return getNextState(p16, v70, Object.assign(table.clone(v71), {
						routes = v80
					}))
				end
			end

			local v81 = p16.key == nil or p16.key == v77.key

			if p16.type == NavigationActions.Back then
				if v81 and v32 == BackBehavior.InitialRoute then
					index = v34
				elseif v81 and v32 == BackBehavior.Order then
					index = math.max(1, index - 1)
				elseif v81 and v32 == BackBehavior.History and #v71.routeKeyHistory > 1 then
					local v82 = v71.routeKeyHistory[#v71.routeKeyHistory - 1]

					index = Array.indexOf(v28, v82)
				end
			end

			local v83 = false

			if p16.type == NavigationActions.Navigate then
				v83 = Array.find(v28, function(p23, p24) -- line: 274
					-- upvalues: p16 (copy), index (ref)
					if p23 == p16.routeName then
						index = p24

						return true
					end

					return false
				end) ~= nil

				if v83 then
					local v84 = v71.routes[index]
					local v85 = t1[p16.routeName]
					local v86 = v84

					if p16.action and v85 then
						local v87 = v85.getStateForAction(p16.action, v84)

						if v87 then
							v86 = v87
						end
					end

					if p16.params then
						v86 = Object.assign(table.clone(v86), {
							params = if p16.params ~= Object.None then if not v86.params then table.clone(p16.params) else Object.assign(table.clone(v86.params), p16.params) else Object.None
						})
					end

					if v86 ~= v84 then
						local v88 = table.clone(v71.routes)

						v88[index] = v86

						local v89 = Object.assign(table.clone(v71), {
							routes = v88,
							index = index
						})

						return getNextState(p16, v70, v89)
					end

					if v86 == v84 and v71.index == index and v70 then
						return nil
					end
				end
			end

			if p16.type == NavigationActions.SetParams then
				local key = p16.key
				local v91 = Array.findIndex(v71.routes, function(p25) -- line: 320
					-- upvalues: key (copy)
					return p25.key == key
				end)

				if v91 > 0 then
					local v92 = v71.routes[v91]
					local None = Object.None

					if p16.params ~= Object.None then
						None = if not v92.params or not p16.params then if not v92.params then if not p16.params then {} else table.clone(p16.params) else table.clone(v92.params) else Object.assign(table.clone(v92.params), p16.params)
					end

					local v94 = table.clone(v71.routes)

					v94[v91] = Object.assign(table.clone(v92), {
						params = None
					})

					return getNextState(p16, v70, Object.assign(table.clone(v71), {
						routes = v94
					}))
				end
			end

			if index ~= v71.index then
				return getNextState(p16, v70, Object.assign(table.clone(v71), {
					index = index
				}))
			end

			if v83 and not p17 then
				return v71
			end

			if v83 then
				return table.clone(v71)
			end

			if p16.type ~= NavigationActions.Back and (p16.type ~= StackActions.Pop and p16.type ~= StackActions.PopToTop) or p16.type == NavigationActions.Back and p16.key ~= nil then
				local index2 = v71.index
				local routes = v71.routes

				Array.find(v28, function(p26, p27) -- line: 363
					-- upvalues: t1 (copy), index2 (ref), routes (ref), p16 (copy)
					local v117 = t1[p26]

					if p27 == index2 then
						return false
					end

					local v118 = routes[p27]

					if v117 then
						v118 = v117.getStateForAction(p16, v118)
					end

					if not v118 then
						index2 = p27

						return true
					end

					if v118 ~= routes[p27] then
						routes = table.clone(routes)
						routes[p27] = v118
						index2 = p27

						return true
					end

					return false
				end)

				if p16.preserveFocus then
					index2 = v71.index
				end

				if index2 ~= v71.index or routes ~= v71.routes then
					return getNextState(p16, v70, Object.assign(table.clone(v71), {
						index = index2,
						routes = routes
					}))
				end
			end

			return v71
		end,
		getComponentForState = function(p28) -- line: 410
			-- upvalues: invariant (copy), t1 (copy), getScreenForRouteName (copy), v27 (copy)
			local routeName = (p28.routes[p28.index] or {}).routeName

			invariant(routeName, "There is no route defined for index '%d'. Check that you passed in a navigation state with a valid tab/screen index.", p28.index)

			local v99 = t1[routeName]

			if v99 then
				return v99.getComponentForState(p28.routes[p28.index])
			end

			return getScreenForRouteName(v27, routeName)
		end,
		getComponentForRouteName = function(p29) -- line: 430
			-- upvalues: getScreenForRouteName (copy), v27 (copy)
			return getScreenForRouteName(v27, p29)
		end,
		getPathAndParamsForState = function(p30) -- line: 434
			-- upvalues: getPathAndParamsForRoute (copy)
			local v102 = p30.routes[p30.index]

			return getPathAndParamsForRoute(v102)
		end,
		getActionForPathAndParams = function(p31, p32) -- line: 439
			-- upvalues: getActionForPathAndParams (copy)
			return getActionForPathAndParams(p31, p32)
		end
	}
end
