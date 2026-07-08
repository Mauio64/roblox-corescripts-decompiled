local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local getEventManager = require(script.Parent.getEventManager)
local getChildRouter = require(script.Parent.getChildRouter)
local getNavigationActionCreators = require(script.Parent.routers.getNavigationActionCreators)
local getChildrenNavigationCache = require(script.Parent.getChildrenNavigationCache)

local function createParamGetter(p1) -- line: 12
	return function(p2, p3) -- line: 13
		-- upvalues: p1 (copy)
		local params = p1.params

		if params and params[p2] ~= nil then
			return params[p2]
		end

		return p3
	end
end
local function getChildNavigation(p4, p5, p6) -- line: 24
	-- upvalues: getChildrenNavigationCache (copy), Array (copy), getChildRouter (copy), Object (copy), getNavigationActionCreators (copy), getChildNavigation (copy), getEventManager (copy)
	local v15 = getChildrenNavigationCache(p4)
	local v16 = Array.findIndex(p4.state.routes, function(p7) -- line: 27
		-- upvalues: p5 (copy)
		return p7.key == p5
	end)

	if v16 < 1 then
		return nil
	end

	local v17 = p4.state.routes[v16]
	local v18 = v15[p5]

	if v18 and v17 == v18.state then
		return v18
	end

	local v19 = getChildRouter(p4.router, v17.routeName)
	local v20 = nil

	if v17.routes and type(v17.index) == "number" then
		v20 = v17.routes[v17.index]
	end

	local v21 = v19 and v19.getActionCreators(v20, v17.key) or {}
	local v22 = Object.assign(if not p4.actions then {} else table.clone(p4.actions), p4.router.getActionCreators(v17, p4.state.key) or {}, v21 or {}, getNavigationActionCreators(v17) or {})
	local t1 = {}

	for v24, v25 in v22 do
		t1[v24] = function(...) -- line: 66
			-- upvalues: v25 (copy), p4 (copy)
			local v35 = v25(...)

			return p4.dispatch(v35)
		end
	end

	local u26 = true
	local v27 = p6()

	if v27 then
		u26 = Array.indexOf(v27.state.routes, v17) == 1
	end

	if v18 and v18.isFirstRouteInParent() == u26 then
		local u28 = nil

		u28 = Object.assign(table.clone(v18), t1, {
			state = v17,
			router = v19,
			actions = v22,
			getParam = function(p8, p9) -- line: 13
				-- upvalues: v17 (copy)
				local params = v17.params

				if params and params[p8] ~= nil then
					return params[p8]
				end

				return p9
			end,
			getChildNavigation = function(p10) -- line: 88
				-- upvalues: getChildNavigation (copy), u28 (ref), p6 (copy), p5 (copy)
				return getChildNavigation(u28, p10, function() -- line: 89
					-- upvalues: p6 (copy), p5 (copy)
					local v46 = p6()

					if v46 then
						return (v46.getChildNavigation(p5))
					end

					return nil
				end)
			end
		})
		v15[p5] = u28

		return u28
	end

	local v29 = getEventManager(p5)
	local u30 = nil

	u30 = Object.assign(table.clone(t1), {
		state = v17,
		router = v19,
		actions = v22,
		getParam = function(p11, p12) -- line: 13
			-- upvalues: v17 (copy)
			local params = v17.params

			if params and params[p11] ~= nil then
				return params[p11]
			end

			return p12
		end,
		getChildNavigation = function(p13) -- line: 109
			-- upvalues: getChildNavigation (copy), u30 (ref), p6 (copy), p5 (copy)
			return getChildNavigation(u30, p13, function() -- line: 110
				-- upvalues: p6 (copy), p5 (copy)
				local v47 = p6()

				if v47 then
					return (v47.getChildNavigation(p5))
				end

				return nil
			end)
		end,
		isFocused = function() -- line: 115
			-- upvalues: p6 (copy), p5 (copy)
			local v44 = p6()

			if not v44 then
				return false
			end

			if not v44.isFocused() then
				return false
			end

			local state = v44.state

			if state.routes[state.index].key == p5 then
				return true
			end

			return false
		end,
		isFirstRouteInParent = function() -- line: 135
			-- upvalues: u26 (ref)
			return u26
		end,
		dispatch = p4.dispatch,
		getScreenProps = p4.getScreenProps,
		_dangerouslyGetParent = p6,
		addListener = v29.addListener,
		emit = v29.emit
	})
	v15[p5] = u30

	return u30
end

return getChildNavigation
