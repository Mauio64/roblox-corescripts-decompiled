local Parent = script:FindFirstAncestor("RobloxAppNavigationCore").Parent
local inspectRouteEntry = require(Parent.Navigation).inspectRouteEntry
local RoactNavigation = require(Parent.RoactNavigation)
local createConfigGetter = RoactNavigation.createConfigGetter
local getScreenForRouteName = RoactNavigation.getScreenForRouteName
local validateRouteConfigMap = RoactNavigation.validateRouteConfigMap
local LuauPolyfill = require(Parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local StateUtils = require(script.Parent.StateUtils)
local __DEV__ = _G.__DEV__
local t1 = {
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
local str = tostring(math.random(100000, 1000000))
local n1 = 0

local function generateKey() -- line: 131
	-- upvalues: n1 (ref), str (copy)
	n1 += 1

	return `id-{ str }-{ tostring(n1) }`
end
local function isResetToRootStack(p1) -- line: 136
	-- upvalues: t1 (copy)
	return p1.type == t1.Reset and p1.key == nil
end
local function getParamsForAction(t2: {[any]: any}) -- line: 140
	-- upvalues: Object (copy)
	if t2.params == Object.None then
		return nil
	end

	return t2.params
end

return function(p2, p3) -- line: 154
	-- upvalues: Array (copy), inspectRouteEntry (copy), __DEV__ (copy), validateRouteConfigMap (copy), getScreenForRouteName (copy), t1 (copy), n1 (ref), str (copy), RoactNavigation (copy), Object (copy), StateUtils (copy), createConfigGetter (copy)
	local v22 = Array.map(p2, function(p4) -- line: 160
		-- upvalues: inspectRouteEntry (copy)
		return (inspectRouteEntry(p4))
	end)
	local v23 = Array.reduce(p2, function(p5, p6) -- line: 167
		-- upvalues: inspectRouteEntry (copy)
		local v33, v34 = inspectRouteEntry(p6)

		p5[v33] = v34

		return p5
	end, {})

	if __DEV__ then
		validateRouteConfigMap(v23)
	end

	local v24 = p3 or {}
	local v25 = v24.initialRouteName or v22[1]

	if __DEV__ and v23[v25] == nil then
		local v26 = table.concat(v22, ", ")

		error(`Invalid initialRouteName: '{ v25 }'. Should be one of: { v26 }`)
	end

	local t3 = {}

	local function getChildRouter(s1: string) -- line: 191
		-- upvalues: t3 (copy), v23 (copy), getScreenForRouteName (copy)
		if t3[s1] == nil and v23[s1] ~= nil then
			local v36 = getScreenForRouteName(v23, s1)

			if typeof(v36) == "table" and v36.router then
				t3[s1] = v36.router
			else
				t3[s1] = false
			end
		end

		return t3[s1]
	end
	local function getInitialState(p7) -- line: 206
		-- upvalues: t1 (copy), v23 (copy), n1 (ref), str (copy), t3 (copy), getScreenForRouteName (copy), RoactNavigation (copy), Object (copy), v25 (copy)
		if (p7.type == t1.Navigate or p7.type == t1.Push) and v23[p7.routeName] ~= nil then
			local t4 = {}
			local key = p7.key

			if not key then
				n1 += 1
				key = `id-{ str }-{ tostring(n1) }`
			end

			t4.key = key
			t4.routeName = p7.routeName
			t4.params = p7.params

			local routeName = p7.routeName

			if t3[routeName] == nil and v23[routeName] ~= nil then
				local v41 = getScreenForRouteName(v23, routeName)

				if typeof(v41) == "table" and v41.router then
					t3[routeName] = v41.router
				else
					t3[routeName] = false
				end
			end

			local v42 = t3[routeName]

			if v42 then
				local v43 = p7.action or RoactNavigation.Actions.init()
				local v44 = v42.getStateForAction(v43)

				t4 = Object.assign(table.clone(v44), t4)
			end

			return {
				key = "StackRouterRoot",
				index = 1,
				isTransitioning = false,
				routes = { t4 }
			}
		end

		local t5 = {}

		n1 += 1
		t5.key = `id-{ str }-{ tostring(n1) }`
		t5.routeName = v25

		local v46 = v25

		if t3[v46] == nil and v23[v46] ~= nil then
			local v47 = getScreenForRouteName(v23, v46)

			if typeof(v47) == "table" and v47.router then
				t3[v46] = v47.router
			else
				t3[v46] = false
			end
		end

		local v48 = t3[v46]

		if v48 then
			local v49 = RoactNavigation.Actions.init()
			local v50 = v48.getStateForAction(v49)

			t5 = Object.assign(table.clone(v50), t5)
		end

		return {
			key = "StackRouterRoot",
			index = 1,
			isTransitioning = false,
			routes = { t5 }
		}
	end

	return {
		childRouters = t3,
		getStateForAction = function(p8, p9) -- line: 253
			-- upvalues: getInitialState (copy), t1 (copy), t3 (copy), v23 (copy), getScreenForRouteName (copy), StateUtils (copy), Object (copy), __DEV__ (copy), Array (copy), RoactNavigation (copy), n1 (ref), str (copy)
			local v53 = p9 or getInitialState(p8)

			if not p9 then
				return v53
			end

			local v54 = v53.routes[v53.index]

			if (p8.type ~= t1.Reset or p8.key ~= nil) and p8.type ~= t1.Navigate then
				local routeName = v54.routeName

				if t3[routeName] == nil and v23[routeName] ~= nil then
					local v56 = getScreenForRouteName(v23, routeName)

					if typeof(v56) == "table" and v56.router then
						t3[routeName] = v56.router
					else
						t3[routeName] = false
					end
				end

				local v57 = t3[routeName]

				if v57 then
					local v58 = v57.getStateForAction(p8, v54)

					if v58 ~= nil and v58 ~= v54 then
						return StateUtils.replaceAt(v53, v54.key, v58, p8.type == t1.SetParams)
					end
				end
			elseif p8.type == t1.Navigate then
				for i = #v53.routes, 1, -1 do
					local v60 = v53.routes[i]
					local routeName = v60.routeName

					if t3[routeName] == nil and v23[routeName] ~= nil then
						local v62 = getScreenForRouteName(v23, routeName)

						if typeof(v62) == "table" and v62.router then
							t3[routeName] = v62.router
						else
							t3[routeName] = false
						end
					end

					local v63 = t3[routeName]
					local v64 = p8

					if p8.routeName == v60.routeName and p8.action then
						v64 = p8.action
					end

					if not v63 then
						continue
					end

					local v65 = v63.getStateForAction(v64, v60)

					if v65 == nil or v65 ~= v60 then
						local v66 = StateUtils.replaceAndPrune(v53, if not v65 then v60.key else v65.key, v65 or v60)
						local isTransitioning = v53.isTransitioning

						if v53.index ~= v66.index then
							isTransitioning = p8.immediate ~= true
						end

						return Object.assign(table.clone(v66), {
							isTransitioning = isTransitioning
						})
					end
				end
			end

			if (p8.type == t1.Navigate or p8.type == t1.Push) and v23[p8.routeName] ~= nil then
				local routeName = p8.routeName

				if t3[routeName] == nil and v23[routeName] ~= nil then
					local v69 = getScreenForRouteName(v23, routeName)

					if typeof(v69) == "table" and v69.router then
						t3[routeName] = v69.router
					else
						t3[routeName] = false
					end
				end

				local v70 = t3[routeName]

				if __DEV__ then
					assert(p8.type ~= t1.Push or p8.key == nil, "StackRouter does not support key on the push action")
				end

				local function v71(p10) -- line: 336
					-- upvalues: p8 (copy)
					return p10.routeName == p8.routeName
				end

				if p8.key then
					function v71(p11) -- line: 340
						-- upvalues: p8 (copy)
						return p11.key == p8.key
					end
				end

				local v72 = Array.findIndex(v53.routes, v71)

				if p8.type ~= t1.Push and v72 > 0 then
					if v72 == v53.index and not p8.params then
						return nil
					end

					local v73 = Array.slice(v53.routes, 1, v72 + 1)

					if p8.params then
						local v74 = v53.routes[v72]

						v73[v72] = Object.assign(table.clone(v74), {
							params = if p8.params ~= Object.None then if v74.params then Object.assign(table.clone(v74.params), p8.params) else table.clone(p8.params) else Object.None
						})
					end

					local isTransitioning = v53.isTransitioning

					if v72 ~= v53.index then
						isTransitioning = p8.immediate ~= true
					end

					return Object.assign(table.clone(v53), {
						isTransitioning = isTransitioning,
						index = v72,
						routes = v73
					})
				end

				local v82

				if v70 then
					local v76 = p8.action or RoactNavigation.Actions.init({
						params = if p8.params ~= Object.None then p8.params else nil
					})
					local assign = Object.assign
					local t6 = {
						params = if p8.params ~= Object.None then p8.params else nil
					}
					local v79 = v70.getStateForAction(v76)
					local t7 = {
						routeName = p8.routeName
					}
					local key = p8.key

					if not key then
						n1 += 1
						key = `id-{ str }-{ tostring(n1) }`
					end

					t7.key = key
					v82 = assign(t6, v79, t7)
				else
					v82 = {
						params = if p8.params ~= Object.None then p8.params else nil,
						routeName = p8.routeName
					}

					local key = p8.key

					if not key then
						n1 += 1
						key = `id-{ str }-{ tostring(n1) }`
					end

					v82.key = key
				end

				return Object.assign(StateUtils.push(v53, v82), {
					isTransitioning = p8.immediate ~= true
				})
			end

			if p8.type == t1.Push and v23[p8.routeName] == nil then
				return v53
			end

			if p8.type == t1.Navigate or p8.type == t1.Push then
				for v84 in v23 do
					if t3[v84] == nil and v23[v84] ~= nil then
						local v85 = getScreenForRouteName(v23, v84)

						if typeof(v85) == "table" and v85.router then
							t3[v84] = v85.router
						else
							t3[v84] = false
						end
					end

					local v86 = t3[v84]

					if not v86 then
						continue
					end

					local v87 = v86.getStateForAction(RoactNavigation.Actions.init())
					local v88 = v86.getStateForAction(p8, v87)
					local v89 = nil

					if v88 == nil then
						v89 = v87
					elseif v88 ~= v87 then
						v89 = v88
					end

					if v89 then
						local assign = Object.assign
						local v91 = table.clone(v89)
						local t8 = {
							routeName = v84
						}
						local key = p8.key

						if not key then
							n1 += 1
							key = `id-{ str }-{ tostring(n1) }`
						end

						t8.key = key

						local v94 = assign(v91, t8)

						return Object.assign(StateUtils.push(v53, v94), {
							isTransitioning = p8.immediate ~= true
						})
					end
				end
			end

			if p8.type == t1.PopToTop then
				if p8.key and v53.key ~= p8.key then
					return v53
				end

				if v53.index > 1 then
					return Object.assign(table.clone(v53), {
						index = 1,
						isTransitioning = p8.immediate ~= true,
						routes = { v53.routes[1] }
					})
				end

				return v53
			end

			if p8.type == t1.Replace then
				local v95 = if p8.key ~= nil or not (#v53.routes > 0) then Array.findIndex(v53.routes, function(p12) -- line: 481
					-- upvalues: p8 (copy)
					return p12.key == p8.key
				end) else #v53.routes

				if v95 > 0 then
					local routeName = p8.routeName

					if t3[routeName] == nil and v23[routeName] ~= nil then
						local v97 = getScreenForRouteName(v23, routeName)

						if typeof(v97) == "table" and v97.router then
							t3[routeName] = v97.router
						else
							t3[routeName] = false
						end
					end

					local v98 = t3[routeName]
					local t9 = {}

					if v98 then
						local v100 = p8.action or RoactNavigation.Actions.init({
							params = if p8.params ~= Object.None then p8.params else nil
						})

						t9 = v98.getStateForAction(v100)
					end

					local v101 = table.clone(v53.routes)
					local assign = Object.assign
					local t10 = {
						params = if p8.params ~= Object.None then p8.params else nil
					}
					local t11 = {
						routeName = p8.routeName
					}
					local newKey = p8.newKey

					if not newKey then
						n1 += 1
						newKey = `id-{ str }-{ tostring(n1) }`
					end

					t11.key = newKey
					v101[v95] = assign(t10, t9, t11)

					return Object.assign(table.clone(v53), {
						routes = v101
					})
				end
			end

			if p8.type == t1.CompleteTransition and ((p8.key == nil or p8.key == v53.key) and p8.toChildKey == v53.routes[v53.index].key and v53.isTransitioning) then
				return Object.assign(table.clone(v53), {
					isTransitioning = false
				})
			end

			if p8.type == t1.SetParams then
				local key = p8.key
				local v107 = Array.findIndex(v53.routes, function(p13) -- line: 528
					-- upvalues: key (copy)
					return p13.key == key
				end)

				if v107 > 0 then
					local v108 = v53.routes[v107]
					local None = Object.None

					if p8.params ~= Object.None then
						None = if not v108.params or not p8.params then if not v108.params then if not p8.params then {} else table.clone(p8.params) else table.clone(v108.params) else Object.assign(table.clone(v108.params), p8.params)
					end

					local v110 = table.clone(v53.routes)

					v110[v107] = Object.assign(table.clone(v108), {
						params = None
					})

					return Object.assign(table.clone(v53), {
						routes = v110
					})
				end
			end

			if p8.type == t1.Reset then
				if p8.key ~= nil and p8.key ~= v53.key then
					return v53
				end

				local v111 = if not p8.actions then {} else Array.map(p8.actions, function(p14) -- line: 559
					-- upvalues: t3 (copy), v23 (copy), getScreenForRouteName (copy), RoactNavigation (copy), Object (copy), n1 (ref), str (copy)
					local routeName = p14.routeName

					if t3[routeName] == nil and v23[routeName] ~= nil then
						local v138 = getScreenForRouteName(v23, routeName)

						if typeof(v138) == "table" and v138.router then
							t3[routeName] = v138.router
						else
							t3[routeName] = false
						end
					end

					local v139 = t3[routeName]
					local t12 = {}

					if v139 then
						local v141 = p14.action or RoactNavigation.Actions.init({
							params = if p14.params ~= Object.None then p14.params else nil
						})

						t12 = v139.getStateForAction(v141)
					end

					local assign = Object.assign
					local t13 = {
						params = if p14.params ~= Object.None then p14.params else nil
					}
					local t14 = {
						routeName = p14.routeName
					}
					local key = p14.key

					if not key then
						n1 += 1
						key = `id-{ str }-{ tostring(n1) }`
					end

					t14.key = key

					return assign(t13, t12, t14)
				end)

				return Object.assign(table.clone(v53), {
					routes = v111,
					index = p8.index
				})
			end

			if p8.type == t1.Back or p8.type == t1.Pop then
				local key = p8.key
				local n = p8.n
				local immediate = p8.immediate
				local prune = p8.prune

				if p8.type == t1.Pop and prune == false and key then
					local v116 = Array.findIndex(v53.routes, function(p15) -- line: 598
						-- upvalues: key (copy)
						return p15.key == key
					end)

					if v116 > 0 then
						local v117 = math.max(v116 - (n or 1), 1)
						local v118 = Array.concat(Array.slice(v53.routes, 1, v117 + 1), Array.slice(v53.routes, v116 + 1))

						if #v118 > 0 then
							return Object.assign(table.clone(v53), {
								routes = v118,
								index = #v118,
								isTransitioning = immediate ~= true
							})
						end
					end
				else
					local index = v53.index

					if p8.type == t1.Pop and n ~= nil then
						index = math.max(2, v53.index - n + 1)
					elseif key then
						index = Array.findIndex(v53.routes, function(p16) -- line: 623
							-- upvalues: key (copy)
							return p16.key == key
						end)
					end

					if index > 1 then
						return Object.assign(table.clone(v53), {
							routes = Array.slice(v53.routes, 1, index),
							index = index - 1,
							isTransitioning = immediate ~= true
						})
					end
				end
			end

			local key = p8.key
			local v121 = if not key then nil else StateUtils.indexOf(v53, key)

			for i = #v53.routes, 1, -1 do
				local v123 = v53.routes[i]

				if v123.key == v54.key or v121 ~= 1 and key ~= v123.key then
					continue
				end

				local routeName = v123.routeName

				if t3[routeName] == nil and v23[routeName] ~= nil then
					local v125 = getScreenForRouteName(v23, routeName)

					if typeof(v125) == "table" and v125.router then
						t3[routeName] = v125.router
					else
						t3[routeName] = false
					end
				end

				local v126 = t3[routeName]

				if not v126 then
					continue
				end

				local v127 = v126.getStateForAction(p8, v123)

				if v127 == nil then
					return v53
				end

				if v127 ~= v123 then
					return StateUtils.replaceAt(v53, v123.key, v127, p8.preserveFocus)
				end
			end

			return v53
		end,
		getComponentForRouteName = function(s2: string) -- line: 678
			-- upvalues: getScreenForRouteName (copy), v23 (copy)
			return getScreenForRouteName(v23, s2)
		end,
		getActionCreators = function(p17, s3: string) -- line: 682
			-- upvalues: v24 (copy), Object (copy), RoactNavigation (copy), __DEV__ (copy)
			local v131 = v24.getCustomActionCreators or function() -- line: 684
				return {}
			end

			return Object.assign(table.clone(v131(p17, s3)), {
				pop = function(p18, p19) -- line: 688
					-- upvalues: RoactNavigation (copy), Object (copy)
					return RoactNavigation.StackActions.pop(Object.assign({
						n = p18
					}, p19 or {}))
				end,
				popToTop = function(p20) -- line: 691
					-- upvalues: RoactNavigation (copy)
					return RoactNavigation.StackActions.popToTop(p20)
				end,
				push = function(p21, p22, p23) -- line: 694
					-- upvalues: RoactNavigation (copy)
					return RoactNavigation.StackActions.push({
						routeName = p21,
						params = p22,
						action = p23
					})
				end,
				replace = function(p24, p25, p26, p27) -- line: 701
					-- upvalues: RoactNavigation (copy), p17 (copy), __DEV__ (copy)
					if typeof(p24) == "string" then
						return RoactNavigation.StackActions.replace({
							routeName = p24,
							params = p25,
							action = p26,
							key = p17.key,
							newKey = p27
						})
					end

					if __DEV__ then
						assert(typeof(p24) == "table", "replaceWith must be a table or string")
						assert(p25 == nil, "params must not be provided to .replace() when specifying a table")
						assert(p26 == nil, "Child action must not be provided to .replace() when specifying a table")
						assert(p27 == nil, "newKey must not be provided to .replace() when specifying a table")
					end

					return RoactNavigation.StackActions.replace(p24)
				end,
				reset = function(p28, p29) -- line: 721
					-- upvalues: RoactNavigation (copy), s3 (copy)
					if p29 == nil then
						p29 = #p28
					end

					return RoactNavigation.StackActions.reset({
						actions = p28,
						index = p29,
						key = s3
					})
				end,
				dismiss = function() -- line: 733
					-- upvalues: RoactNavigation (copy), s3 (copy)
					return RoactNavigation.Actions.back({
						key = s3
					})
				end
			})
		end,
		getScreenOptions = createConfigGetter(v23, v24.defaultNavigationOptions)
	}
end
