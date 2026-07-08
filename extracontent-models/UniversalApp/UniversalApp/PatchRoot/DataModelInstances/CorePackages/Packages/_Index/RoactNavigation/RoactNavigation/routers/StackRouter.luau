local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local NavigationActions = require(ParentParent.NavigationActions)
local StackActions = require(script.Parent.StackActions)
local KeyGenerator = require(ParentParent.utils.KeyGenerator)
local StateUtils = require(ParentParent.StateUtils)
local getScreenForRouteName = require(script.Parent.getScreenForRouteName)
local createConfigGetter = require(script.Parent.createConfigGetter)
local validateRouteConfigArray = require(script.Parent.validateRouteConfigArray)
local validateRouteConfigMap = require(script.Parent.validateRouteConfigMap)
local invariant = require(ParentParent.utils.invariant)
local createPathParser = require(script.Parent.pathUtils).createPathParser
local lib = require(script.Parent["ChildIsScreenRouterSymbol.roblox"])

local function v17() -- line: 28
	return {}
end
local function behavesLikePushAction(p1) -- line: 32
	-- upvalues: NavigationActions (copy), StackActions (copy)
	return p1.type == NavigationActions.Navigate or p1.type == StackActions.Push
end
local function isResetToRootStack(p2) -- line: 36
	-- upvalues: StackActions (copy)
	return p2.type == StackActions.Reset and p2.key == nil
end
local function mapToRouteName(p3) -- line: 40
	return (next(p3))
end
local function foldToRoutes(p4, p5, _) -- line: 45
	local v28, v29 = next(p5)

	p4[v28] = v29

	return p4
end

return function(p7, p8) -- line: 51
	-- upvalues: validateRouteConfigArray (copy), validateRouteConfigMap (copy), Array (copy), foldToRoutes (copy), mapToRouteName (copy), lib (copy), v17 (copy), NavigationActions (copy), StackActions (copy), Object (copy), KeyGenerator (copy), createPathParser (copy), invariant (copy), getScreenForRouteName (copy), StateUtils (copy), createConfigGetter (copy)
	validateRouteConfigArray(p7)

	local u32 = p8 or {}
	local v33 = validateRouteConfigMap(Array.reduce(p7, foldToRoutes, {}))
	local v34 = u32.order or Array.map(p7, mapToRouteName)
	local t1 = {}

	for _, v37 in v34 do
		local v38 = v33[v37]
		local v39 = if type(v38) ~= "table" or not v38.screen then v38 else v38.screen

		if type(v39) == "table" and v39.router then
			t1[v37] = v39.router
		else
			t1[v37] = lib
		end
	end

	local initialRouteParams = u32.initialRouteParams
	local v41 = u32.getCustomActionCreators or v17
	local v42 = u32.initialRouteName or v34[1]
	local v43 = t1[v42]

	if Array.indexOf(v34, v42) < 1 then
		local s1 = ""

		for _, v46 in v34 do
			s1 ..= v46 .. ","
		end

		error(string.format("Invalid initialRouteName '%s'. Must be one of [%s]", v42, s1), 2)
	end

	local function getInitialState(p9) -- line: 97
		-- upvalues: t1 (copy), NavigationActions (copy), StackActions (copy), lib (copy), Object (copy), KeyGenerator (copy), v43 (copy), v42 (copy), initialRouteParams (copy), v33 (copy), u32 (ref)
		local t2 = {}
		local v57 = t1[p9.routeName]

		if (p9.type == NavigationActions.Navigate or p9.type == StackActions.Push) and v57 ~= nil then
			local t3 = {}

			if v57 ~= lib then
				local v59 = p9.action or NavigationActions.init({
					params = p9.params
				})

				t3 = v57.getStateForAction(v59)
			end

			return {
				key = "StackRouterRoot",
				isTransitioning = false,
				index = 1,
				routes = { Object.assign({
					params = p9.params
				}, t3, {
					key = p9.key or KeyGenerator.generateKey(),
					routeName = p9.routeName
				}) }
			}
		end

		if v43 ~= nil and v43 ~= lib then
			t2 = v43.getStateForAction(NavigationActions.navigate({
				routeName = v42,
				params = initialRouteParams
			}))
		end

		local v60 = v33[v42]
		local v61 = type(v60) == "table" and v60.params
		local v62 = (v61 or (t2.params or (p9.params or initialRouteParams))) and Object.assign(if not v61 then {} else table.clone(v61), t2.params or {}, p9.params or {}, initialRouteParams or {})
		local initialRouteKey = u32.initialRouteKey
		local v64 = Object.assign(table.clone(t2), {
			params = v62,
			routeName = v42,
			key = p9.key or (initialRouteKey or KeyGenerator.generateKey())
		})

		return {
			key = "StackRouterRoot",
			isTransitioning = false,
			index = 1,
			routes = { v64 }
		}
	end
	local function getParamsForRouteAndAction(p10, p11) -- line: 162
		-- upvalues: Object (copy), v33 (copy)
		if p11.params == Object.None then
			return nil
		end

		local v67 = v33[p10]

		if type(v67) == "table" and v67.params then
			return Object.assign(table.clone(v67.params), p11.params)
		end

		if p11.params then
			return Object.assign({}, p11.params)
		end

		return nil
	end

	local v49 = createPathParser(t1, v33, u32)
	local getPathAndParamsForRoute = v49.getPathAndParamsForRoute
	local getActionForPathAndParams = v49.getActionForPathAndParams
	local t4 = {}

	for v53, v54 in t1 do
		if v54 ~= lib then
			t4[v53] = v54
		end
	end

	return {
		childRouters = t4,
		_CHILD_IS_SCREEN = lib,
		getComponentForState = function(p12) -- line: 199
			-- upvalues: invariant (copy), t1 (copy), lib (copy), getScreenForRouteName (copy), v33 (copy)
			local v69 = p12.routes[p12.index] or {}
			local routeName = v69.routeName

			invariant(routeName, "There is no route defined for index '%d'. Make sure that you passed in a navigation state with a valid stack index.", p12.index)

			local v71 = t1[routeName]

			if v71 ~= nil and v71 ~= lib then
				return t1[routeName].getComponentForState(v69)
			end

			return getScreenForRouteName(v33, routeName)
		end,
		getComponentForRouteName = function(p13) -- line: 220
			-- upvalues: getScreenForRouteName (copy), v33 (copy)
			return getScreenForRouteName(v33, p13)
		end,
		getActionCreators = function(p14, p15) -- line: 224
			-- upvalues: Object (copy), v41 (copy), StackActions (copy), invariant (copy), NavigationActions (copy)
			return Object.assign(table.clone(v41(p14, p15)), {
				pop = function(p16, p17) -- line: 226
					-- upvalues: StackActions (copy), Object (copy)
					return StackActions.pop(Object.assign({
						n = p16
					}, p17 or {}))
				end,
				popToTop = function(p18) -- line: 229
					-- upvalues: StackActions (copy)
					return StackActions.popToTop(p18)
				end,
				push = function(p19, p20, p21) -- line: 232
					-- upvalues: StackActions (copy)
					return StackActions.push({
						routeName = p19,
						params = p20,
						action = p21
					})
				end,
				replace = function(p22, p23, p24, p25) -- line: 239
					-- upvalues: StackActions (copy), p14 (copy), invariant (copy)
					if type(p22) == "string" then
						return StackActions.replace({
							routeName = p22,
							params = p23,
							action = p24,
							key = p14.key,
							newKey = p25
						})
					end

					invariant(type(p22) == "table", "replaceWith must be a table or string")
					invariant(p23 == nil, "params must not be provided to .replace() when specifying a table")
					invariant(p24 == nil, "Child action must not be provided to .replace() when specifying a table")
					invariant(p25 == nil, "newKey must not be provided to .replace() when specifying a table")

					return StackActions.replace(p22)
				end,
				reset = function(p26, p27) -- line: 257
					-- upvalues: StackActions (copy), p15 (copy)
					if p27 == nil then
						p27 = #p26
					end

					return StackActions.reset({
						actions = p26,
						index = p27,
						key = p15
					})
				end,
				dismiss = function() -- line: 269
					-- upvalues: NavigationActions (copy), p15 (copy)
					return NavigationActions.back({
						key = p15
					})
				end
			})
		end,
		getStateForAction = function(p28, p29) -- line: 277
			-- upvalues: getInitialState (copy), StackActions (copy), NavigationActions (copy), t1 (copy), lib (copy), StateUtils (copy), Object (copy), invariant (copy), Array (copy), getParamsForRouteAndAction (copy), KeyGenerator (copy)
			if not p29 then
				return (getInitialState(p28))
			end

			local v77 = p29.routes[p29.index]

			if (p28.type ~= StackActions.Reset or p28.key ~= nil) and p28.type ~= NavigationActions.Navigate then
				local v78 = t1[v77.routeName]

				if v78 ~= nil and v78 ~= lib then
					local v79 = v78.getStateForAction(p28, v77)

					if v79 ~= nil and v79 ~= v77 then
						return StateUtils.replaceAt(p29, v77.key, v79, p28.type == NavigationActions.SetParams)
					end
				end
			elseif p28.type == NavigationActions.Navigate then
				for i = #p29.routes, 1, -1 do
					local v81 = p29.routes[i]
					local v82 = t1[v81.routeName]
					local v83 = p28

					if p28.routeName == v81.routeName and p28.action then
						v83 = p28.action
					end

					if v82 == nil or v82 == lib then
						continue
					end

					local v84 = v82.getStateForAction(v83, v81)

					if v84 == nil or v84 ~= v81 then
						local v85 = StateUtils.replaceAndPrune(p29, if not v84 then v81.key else v84.key, v84 or v81)
						local isTransitioning = p29.isTransitioning

						if p29.index ~= v85.index then
							isTransitioning = p28.immediate ~= true
						end

						return Object.assign(table.clone(v85), {
							isTransitioning = isTransitioning
						})
					end
				end
			end

			if (p28.type == NavigationActions.Navigate or p28.type == StackActions.Push) and t1[p28.routeName] ~= nil then
				local v87 = t1[p28.routeName]

				invariant(p28.type ~= StackActions.Push or p28.key == nil, "StackRouter does not support key on the push action")

				local function v88(p30) -- line: 349
					-- upvalues: p28 (copy)
					return p30.routeName == p28.routeName
				end

				if p28.key then
					function v88(p31) -- line: 353
						-- upvalues: p28 (copy)
						return p31.key == p28.key
					end
				end

				local v89 = Array.findIndex(p29.routes, v88)

				if p28.type ~= StackActions.Push and v89 > 0 then
					if v89 == p29.index and not p28.params then
						return nil
					end

					local v90 = Array.slice(p29.routes, 1, v89 + 1)

					if p28.params then
						local v91 = p29.routes[v89]

						v90[v89] = Object.assign(table.clone(v91), {
							params = if p28.params ~= Object.None then if v91.params then Object.assign(table.clone(v91.params), p28.params) else table.clone(p28.params) else Object.None
						})
					end

					local isTransitioning = p29.isTransitioning

					if v89 ~= p29.index then
						isTransitioning = p28.immediate ~= true
					end

					return Object.assign(table.clone(p29), {
						isTransitioning = isTransitioning,
						index = v89,
						routes = v90
					})
				end

				local v94

				if v87 ~= lib then
					local v93 = p28.action or NavigationActions.init({
						params = getParamsForRouteAndAction(p28.routeName, p28)
					})

					v94 = Object.assign({
						params = getParamsForRouteAndAction(p28.routeName, p28)
					}, v87.getStateForAction(v93), {
						routeName = p28.routeName,
						key = p28.key or KeyGenerator.generateKey()
					})
				else
					v94 = {
						params = getParamsForRouteAndAction(p28.routeName, p28),
						routeName = p28.routeName,
						key = p28.key or KeyGenerator.generateKey()
					}
				end

				return Object.assign(StateUtils.push(p29, v94), {
					isTransitioning = p28.immediate ~= true
				})
			end

			if p28.type == StackActions.Push and t1[p28.routeName] == nil then
				return p29
			end

			if p28.type == NavigationActions.Navigate or p28.type == StackActions.Push then
				for v95 in t1 do
					local v96 = t1[v95]

					if v96 == nil or v96 == lib then
						continue
					end

					local v97 = v96.getStateForAction(NavigationActions.init())
					local v98 = v96.getStateForAction(p28, v97)
					local v99 = nil

					if v98 == nil then
						v99 = v97
					elseif v98 ~= v97 then
						v99 = v98
					end

					if v99 then
						local v100 = Object.assign(table.clone(v99), {
							routeName = v95,
							key = p28.key or KeyGenerator.generateKey()
						})

						return Object.assign(StateUtils.push(p29, v100), {
							isTransitioning = p28.immediate ~= true
						})
					end
				end
			end

			if p28.type == StackActions.PopToTop then
				if p28.key and p29.key ~= p28.key then
					return p29
				end

				if p29.index > 1 then
					return Object.assign(table.clone(p29), {
						index = 1,
						isTransitioning = p28.immediate ~= true,
						routes = { p29.routes[1] }
					})
				end

				return p29
			end

			if p28.type == StackActions.Replace then
				local v101 = if p28.key ~= nil or not (#p29.routes > 0) then Array.findIndex(p29.routes, function(p32) -- line: 496
					-- upvalues: p28 (copy)
					return p32.key == p28.key
				end) else #p29.routes

				if v101 > 0 then
					local v102 = t1[p28.routeName]
					local t5 = {}

					if v102 ~= nil and v102 ~= lib then
						local v104 = p28.action or NavigationActions.init({
							params = getParamsForRouteAndAction(p28.routeName, p28)
						})

						t5 = v102.getStateForAction(v104)
					end

					local v105 = table.clone(p29.routes)

					v105[v101] = Object.assign({
						params = getParamsForRouteAndAction(p28.routeName, p28)
					}, t5, {
						routeName = p28.routeName,
						key = p28.newKey or KeyGenerator.generateKey()
					})

					return Object.assign(table.clone(p29), {
						routes = v105
					})
				end
			end

			if p28.type == StackActions.CompleteTransition and ((p28.key == nil or p28.key == p29.key) and p28.toChildKey == p29.routes[p29.index].key and p29.isTransitioning) then
				return Object.assign(table.clone(p29), {
					isTransitioning = false
				})
			end

			if p28.type == NavigationActions.SetParams then
				local key = p28.key
				local v107 = Array.findIndex(p29.routes, function(p33) -- line: 545
					-- upvalues: key (copy)
					return p33.key == key
				end)

				if v107 > 0 then
					local v108 = p29.routes[v107]
					local None = Object.None

					if p28.params ~= Object.None then
						None = if not v108.params or not p28.params then if not v108.params then if not p28.params then {} else table.clone(p28.params) else table.clone(v108.params) else Object.assign(table.clone(v108.params), p28.params)
					end

					local v110 = table.clone(p29.routes)

					v110[v107] = Object.assign(table.clone(v108), {
						params = None
					})

					return Object.assign(table.clone(p29), {
						routes = v110
					})
				end
			end

			if p28.type == StackActions.Reset then
				if p28.key ~= nil and p28.key ~= p29.key then
					return p29
				end

				local v111 = if not p28.actions then {} else Array.map(p28.actions, function(p34) -- line: 576
					-- upvalues: t1 (copy), lib (copy), NavigationActions (copy), getParamsForRouteAndAction (copy), Object (copy), KeyGenerator (copy)
					local v146 = t1[p34.routeName]
					local t6 = {}

					if v146 ~= nil and v146 ~= lib then
						local v148 = p34.action or NavigationActions.init({
							params = getParamsForRouteAndAction(p34.routeName, p34)
						})

						t6 = v146.getStateForAction(v148)
					end

					return Object.assign({
						params = getParamsForRouteAndAction(p34.routeName, p34)
					}, t6, {
						routeName = p34.routeName,
						key = p34.key or KeyGenerator.generateKey()
					})
				end)

				return Object.assign(table.clone(p29), {
					routes = v111,
					index = p28.index
				})
			end

			if p28.type == NavigationActions.Back or p28.type == StackActions.Pop then
				local key = p28.key
				local n = p28.n
				local immediate = p28.immediate
				local prune = p28.prune

				if p28.type == StackActions.Pop and prune == false and key then
					local v116 = Array.findIndex(p29.routes, function(p35) -- line: 617
						-- upvalues: key (copy)
						return p35.key == key
					end)

					if v116 > 0 then
						local v117 = math.max(v116 - (n or 1), 1)
						local v118 = Array.concat(Array.slice(p29.routes, 1, v117 + 1), Array.slice(p29.routes, v116 + 1))

						if #v118 > 0 then
							return Object.assign(table.clone(p29), {
								routes = v118,
								index = #v118,
								isTransitioning = immediate ~= true
							})
						end
					end
				else
					local index = p29.index

					if p28.type == StackActions.Pop and n ~= nil then
						index = math.max(2, p29.index - n + 1)
					elseif key then
						index = Array.findIndex(p29.routes, function(p36) -- line: 642
							-- upvalues: key (copy)
							return p36.key == key
						end)
					end

					if index > 1 then
						return Object.assign(table.clone(p29), {
							routes = Array.slice(p29.routes, 1, index),
							index = index - 1,
							isTransitioning = immediate ~= true
						})
					end
				end
			end

			local v120 = if not p28.key then nil else StateUtils.indexOf(p29, p28.key)

			for i = #p29.routes, 1, -1 do
				local v122 = p29.routes[i]

				if v122.key == v77.key or v120 ~= 1 and v122.key ~= p28.key then
					continue
				end

				local v123 = t1[v122.routeName]

				if v123 ~= nil and v123 ~= lib then
					local v124 = v123.getStateForAction(p28, v122)

					if v124 == nil then
						return p29
					end

					if v124 == v122 then
						continue
					end

					return StateUtils.replaceAt(p29, v122.key, v124, p28.preserveFocus)
				end
			end

			return p29
		end,
		getPathAndParamsForState = function(p37) -- line: 696
			-- upvalues: getPathAndParamsForRoute (copy)
			local v126 = p37.routes[p37.index]

			return getPathAndParamsForRoute(v126)
		end,
		getActionForPathAndParams = function(p38, p39) -- line: 701
			-- upvalues: getActionForPathAndParams (copy)
			return getActionForPathAndParams(p38, p39)
		end,
		getScreenOptions = createConfigGetter(v33, u32.defaultNavigationOptions)
	}
end
