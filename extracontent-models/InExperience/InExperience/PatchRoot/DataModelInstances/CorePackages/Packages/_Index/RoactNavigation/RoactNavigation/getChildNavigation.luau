local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local getEventManager = require(script.Parent.getEventManager)
local getChildRouter = require(script.Parent.getChildRouter)
local getNavigationActionCreators = require(script.Parent.routers.getNavigationActionCreators)
local getChildrenNavigationCache = require(script.Parent.getChildrenNavigationCache)

local function createParamGetter(route) -- 2 equivalent calls inferred from this helper
	return function(p, p2)
		local params = route.params

		if params and params[p] ~= nil then
			return params[p]
		end

		return p2
	end
end

local function getChildNavigation(data, p, fn)
	local childrenNavigationCache = getChildrenNavigationCache(data)

	local index = Array.findIndex(data.state.routes, function(p2): boolean
		return p2.key == p
	end)

	if index < 1 then
		return nil
	end

	local route = data.state.routes[index]

	local v = childrenNavigationCache[p]

	if v and v.state == route then
		return v
	end

	local childRouter = getChildRouter(data.router, route.routeName)
	local v2

	if route.routes and type(route.index) == "number" then
		v2 = route.routes[route.index]
	end

	local v3 = childRouter and childRouter.getActionCreators(v2, route.key) or {}

	local actions = Object.assign(
		not data.actions and {} or table.clone(data.actions),
		data.router.getActionCreators(route, data.state.key) or {},
		v3 or {},
		getNavigationActionCreators(route) or {}
	)

	local v4 = {}

	for k, v5 in actions do
		v4[k] = function(...)
			local v6 = v5(...)
			return data.dispatch(v6)
		end
	end

	local v5 = fn()

	local v6 = not v5 or Array.indexOf(v5.state.routes, route) == 1

	if v and v.isFirstRouteInParent() == v6 then
		local v7 = nil
		v7 = Object.assign(table.clone(v), v4, {
			state = route,
			router = childRouter,
			actions = actions,
			getParam = createParamGetter(route), -- inferred equivalent call
			getChildNavigation = function(p2)
				return getChildNavigation(v7, p2, function()
					local v8 = fn()

					if v8 then
						return (v8.getChildNavigation(p))
					end

					return nil
				end)
			end
		})

		childrenNavigationCache[p] = v7

		return v7
	else
		local eventManager = getEventManager(p)

		local v7 = nil
		v7 = Object.assign(table.clone(v4), {
			state = route,
			router = childRouter,
			actions = actions,
			getParam = createParamGetter(route), -- inferred equivalent call
			getChildNavigation = function(p2)
				return getChildNavigation(v7, p2, function()
					local v8 = fn()

					if v8 then
						return (v8.getChildNavigation(p))
					end

					return nil
				end)
			end,
			isFocused = function(): boolean
				local v8 = fn()

				if not (v8 and v8.isFocused()) then
					return false
				end

				local state = v8.state
				return state.routes[state.index].key == p
			end,
			isFirstRouteInParent = function()
				return v6
			end,
			dispatch = data.dispatch,
			getScreenProps = data.getScreenProps,
			_dangerouslyGetParent = fn,
			addListener = eventManager.addListener,
			emit = eventManager.emit
		})

		childrenNavigationCache[p] = v7

		return v7
	end
end

return getChildNavigation
