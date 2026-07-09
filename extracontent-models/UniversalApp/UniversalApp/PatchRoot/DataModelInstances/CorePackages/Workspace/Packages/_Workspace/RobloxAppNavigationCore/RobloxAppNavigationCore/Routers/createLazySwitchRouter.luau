local Parent = script:FindFirstAncestor("RobloxAppNavigationCore").Parent
local inspectRouteEntry = require(Parent.Navigation).inspectRouteEntry
local RoactNavigation = require(Parent.RoactNavigation)
local createConfigGetter = RoactNavigation.createConfigGetter
local getScreenForRouteName = RoactNavigation.getScreenForRouteName
local validateRouteConfigMap = RoactNavigation.validateRouteConfigMap
local StackActions = RoactNavigation.StackActions
local BackBehavior = RoactNavigation.BackBehavior
local LuauPolyfill = require(Parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local FFlagFixInactiveChildStateForwarding = require(Parent.SharedFlags).FFlagFixInactiveChildStateForwarding
local __DEV__ = _G.__DEV__
local t1 = {
	Init = RoactNavigation.Actions.Init,
	Back = RoactNavigation.Actions.Back,
	Navigate = RoactNavigation.Actions.Navigate,
	SetParams = RoactNavigation.Actions.SetParams
}

return function(p1, p2) -- line: 64
	-- upvalues: Array (copy), inspectRouteEntry (copy), __DEV__ (copy), validateRouteConfigMap (copy), BackBehavior (copy), getScreenForRouteName (copy), RoactNavigation (copy), Object (copy), t1 (copy), StackActions (copy), FFlagFixInactiveChildStateForwarding (copy), createConfigGetter (copy)
	local v17 = Array.map(p1, function(p3) -- line: 70
		-- upvalues: inspectRouteEntry (copy)
		return (inspectRouteEntry(p3))
	end)
	local v18 = Array.reduce(v17, function(t2: {[any]: any}, s1: string, n1: number) -- line: 77
		t2[s1] = n1

		return t2
	end, {})
	local v19 = Array.reduce(p1, function(p4, p5) -- line: 86
		-- upvalues: inspectRouteEntry (copy)
		local v36, v37 = inspectRouteEntry(p5)

		p4[v36] = v37

		return p4
	end, {})

	if __DEV__ then
		validateRouteConfigMap(v19)
	end

	local v20 = p2 or {}
	local v21 = v20.initialRouteName or v17[1]
	local v22 = v20.backBehavior or BackBehavior.None

	if __DEV__ and v19[v21] == nil then
		local v23 = table.concat(v17, ", ")

		error(`Invalid initialRouteName: '{ v21 }'. Should be one of: { v23 }`)
	end

	local t3 = {}

	local function getChildRouter(p6) -- line: 111
		-- upvalues: t3 (copy), v19 (copy), getScreenForRouteName (copy)
		if t3[p6] == nil and v19[p6] ~= nil then
			local v39 = getScreenForRouteName(v19, p6)

			if typeof(v39) == "table" and v39.router then
				t3[p6] = v39.router
			else
				t3[p6] = false
			end
		end

		return t3[p6]
	end
	local function initializeChildRoute(s2: string) -- line: 126
		-- upvalues: t3 (copy), v19 (copy), getScreenForRouteName (copy), RoactNavigation (copy), Object (copy)
		local t4 = {
			key = s2,
			routeName = s2
		}

		if t3[s2] == nil and v19[s2] ~= nil then
			local v42 = getScreenForRouteName(v19, s2)

			if typeof(v42) == "table" and v42.router then
				t3[s2] = v42.router
			else
				t3[s2] = false
			end
		end

		local v43 = t3[s2]

		if v43 then
			local v44 = RoactNavigation.Actions.init()
			local v45 = v43.getStateForAction(v44)

			t4 = Object.assign(table.clone(v45), t4)
		end

		return t4
	end
	local function getInitialState() -- line: 142
		-- upvalues: initializeChildRoute (copy), v21 (copy)
		return {
			index = 1,
			routes = { (initializeChildRoute(v21)) }
		}
	end
	local function getNextState(p7, p8, p9) -- line: 149
		-- upvalues: v22 (copy), BackBehavior (copy), t1 (copy), Object (copy)
		if v22 ~= BackBehavior.History or p8 and p8.routes[p8.index].key == p9.routes[p9.index].key then
			return p9
		end

		local v49 = p8 and p8.routeKeyHistory or {}

		if p7.type == t1.Init then
			v49 = { p9.routes[p9.index].key }
		elseif p7.type == t1.Navigate then
			local key = p9.routes[p9.index].key

			v49 = table.clone(v49)
			table.insert(v49, key)
		elseif p7.type == t1.Back then
			v49 = table.clone(v49)
			table.remove(v49)
		end

		return Object.assign(table.clone(p9), {
			routeKeyHistory = v49
		})
	end
	local function sortRoutes(t5: {[any]: any}, s3: string) -- line: 178
		-- upvalues: v18 (copy), Array (copy)
		table.sort(t5, function(p10, p11) -- line: 179
			-- upvalues: v18 (copy)
			return v18[p10.routeName] < v18[p11.routeName]
		end)

		return Array.findIndex(t5, function(p12) -- line: 182
			-- upvalues: s3 (copy)
			return p12.key == s3
		end)
	end

	return {
		childRouters = t3,
		getStateForAction = function(p13, p14) -- line: 187
			-- upvalues: initializeChildRoute (copy), v21 (copy), t1 (copy), getNextState (copy), t3 (copy), v19 (copy), getScreenForRouteName (copy), Object (copy), v22 (copy), BackBehavior (copy), v17 (copy), Array (copy), sortRoutes (copy), StackActions (copy), FFlagFixInactiveChildStateForwarding (copy)
			local v55 = p14 or {
				index = 1,
				routes = { (initializeChildRoute(v21)) }
			}

			if p13.type == t1.Init then
				return getNextState(p13, p14, v55)
			end

			local v56 = v55.routes[v55.index]
			local routeName = v56.routeName

			if t3[routeName] == nil and v19[routeName] ~= nil then
				local v58 = getScreenForRouteName(v19, routeName)

				if typeof(v58) == "table" and v58.router then
					t3[routeName] = v58.router
				else
					t3[routeName] = false
				end
			end

			local v59 = t3[routeName]

			if v59 then
				local v60 = v59.getStateForAction(p13, v56)

				if v60 == nil then
					if p14 == nil then
						return getNextState(p13, p14, v55)
					end

					return nil
				end

				if v60 ~= v56 then
					local v61 = table.clone(v55.routes)

					v61[v55.index] = v60

					local v62 = Object.assign(table.clone(v55), {
						routes = v61
					})

					return getNextState(p13, p14, v62)
				end
			end

			if p13.type == t1.Back then
				local v63 = v55.routes[v55.index]

				if p13.key == nil or p13.key == v63.key then
					local key = v63.key

					if v22 == BackBehavior.InitialRoute then
						key = v21
					elseif v22 == BackBehavior.Order then
						key = v17[math.max(1, table.find(v17, key) - 1)]
					elseif v22 == BackBehavior.History then
						local routeKeyHistory = v55.routeKeyHistory

						if #routeKeyHistory > 1 then
							key = routeKeyHistory[#routeKeyHistory - 1]
						end
					end

					if key ~= v63.key then
						local v66 = Array.findIndex(v55.routes, function(p15) -- line: 246
							-- upvalues: key (ref)
							return p15.key == key
						end)

						if v66 > 0 then
							local v67 = Object.assign(table.clone(v55), {
								index = v66
							})

							return getNextState(p13, p14, v67)
						end

						local v68 = table.clone(v55.routes)

						table.insert(v68, (initializeChildRoute(key)))

						local v69 = Object.assign(table.clone(v55), {
							routes = v68,
							index = sortRoutes(v68, key)
						})

						return getNextState(p13, p14, v69)
					end
				end
			end

			if p13.type == t1.Navigate then
				local routeName2 = p13.routeName

				if v19[routeName2] ~= nil then
					local v71 = Array.findIndex(v55.routes, function(p16) -- line: 271
						-- upvalues: routeName2 (copy)
						return p16.routeName == routeName2
					end)
					local v72 = v55.routes[v71]
					local v73 = v72

					if v71 < 0 then
						v73 = initializeChildRoute(routeName2)
					end

					if p13.action then
						if t3[routeName2] == nil and v19[routeName2] ~= nil then
							local v74 = getScreenForRouteName(v19, routeName2)

							if typeof(v74) == "table" and v74.router then
								t3[routeName2] = v74.router
							else
								t3[routeName2] = false
							end
						end

						local v75 = t3[routeName2]

						if v75 then
							local v76 = v75.getStateForAction(p13.action, v73)

							if v76 then
								v73 = v76
							end
						end
					end

					if p13.params then
						v73 = Object.assign(table.clone(v73), {
							params = if p13.params ~= Object.None then if not v73.params then p13.params else Object.assign(table.clone(v73.params), p13.params) else Object.None
						})
					end

					if v71 < 0 then
						local v77 = table.clone(v55.routes)

						table.insert(v77, v73)

						local v78 = Object.assign(table.clone(v55), {
							routes = v77,
							index = sortRoutes(v77, routeName2)
						})

						return getNextState(p13, p14, v78)
					end

					if v72 ~= v73 then
						local v79 = table.clone(v55.routes)

						v79[v71] = v73

						local v80 = Object.assign(table.clone(v55), {
							routes = v79,
							index = v71
						})

						return getNextState(p13, p14, v80)
					end

					if v71 ~= v55.index then
						local v81 = Object.assign(table.clone(v55), {
							index = v71
						})

						return getNextState(p13, p14, v81)
					end

					if p14 == nil then
						return getNextState(p13, p14, v55)
					end

					return nil
				end
			end

			if p13.type == t1.SetParams then
				local v82 = Array.findIndex(v55.routes, function(p17) -- line: 330
					-- upvalues: p13 (copy)
					return p17.key == p13.key
				end)

				if v82 > 0 then
					local v83 = v55.routes[v82]
					local None = Object.None

					if p13.params ~= Object.None then
						None = if not v83.params or not p13.params then p13.params or (v83.params or {}) else Object.assign(table.clone(v83.params), p13.params)
					end

					local v85 = table.clone(v55.routes)

					v85[v82] = Object.assign(table.clone(v83), {
						params = None
					})

					local v86 = Object.assign(table.clone(v55), {
						routes = v85
					})

					return getNextState(p13, p14, v86)
				end
			end

			if p13.type ~= t1.Back and (p13.type ~= StackActions.Pop and p13.type ~= StackActions.PopToTop) or p13.type == t1.Back and p13.key ~= nil then
				local index = v55.index
				local routes = v55.routes
				local routeName3 = routes[index].routeName
				local v90 = Array.reduce(routes, function(t6: {[any]: any}, p18, p19) -- line: 370
					t6[p18.routeName] = p19

					return t6
				end, {})

				for _, v92 in v17 do
					if v92 == routeName3 then
						continue
					end

					if t3[v92] == nil and v19[v92] ~= nil then
						local v93 = getScreenForRouteName(v19, v92)

						if typeof(v93) == "table" and v93.router then
							t3[v92] = v93.router
						else
							t3[v92] = false
						end
					end

					local v94 = t3[v92]

					if not v94 then
						continue
					end

					local v95 = v90[v92]

					if v95 == nil then
						local v96 = initializeChildRoute(v92)
						local v97 = v94.getStateForAction(p13, v96)

						if not v97 then
							routes = table.clone(routes)
							table.insert(routes, v96)
							index = sortRoutes(routes, v92)

							break
						end

						if v97 == v96 then
							continue
						end

						routes = table.clone(routes)
						table.insert(routes, v97)
						index = sortRoutes(routes, v92)

						break
					end

					local v98 = routes[v95]
					local v99 = v94.getStateForAction(p13, v98)

					if not v99 then
						index = v95

						break
					end

					if v99 ~= v98 then
						routes = table.clone(routes)
						routes[v95] = if not FFlagFixInactiveChildStateForwarding then v98 else v99
						index = v95

						break
					end
				end

				if p13.preserveFocus then
					index = v55.index
				end

				if index ~= v55.index or routes ~= v55.routes then
					local v100 = Object.assign(table.clone(v55), {
						index = index,
						routes = routes
					})

					return getNextState(p13, p14, v100)
				end
			end

			return v55
		end,
		getComponentForRouteName = function(s4: string) -- line: 440
			-- upvalues: getScreenForRouteName (copy), v19 (copy)
			return getScreenForRouteName(v19, s4)
		end,
		getActionCreators = function(p20, s5: string) -- line: 444
			-- upvalues: v20 (copy)
			return (v20.getCustomActionCreators or function() -- line: 446
				return {}
			end)(p20, s5)
		end,
		getScreenOptions = createConfigGetter(v19, v20.defaultNavigationOptions)
	}
end
