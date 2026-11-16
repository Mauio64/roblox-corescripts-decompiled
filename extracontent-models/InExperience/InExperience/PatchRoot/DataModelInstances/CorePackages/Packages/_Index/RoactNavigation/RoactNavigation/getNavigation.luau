local parent = script.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Object = LuauPolyfill.Object

local Events = require(parent.Events)
local getNavigationActionCreators = require(parent.routers.getNavigationActionCreators)
local getChildNavigation = require(parent.getChildNavigation)
local getChildrenNavigationCache = require(parent.getChildrenNavigationCache)

return function(router, state2, dispatch, p, getScreenProps, callback)
	local actionCreators = router.getActionCreators(state2, nil)

	local result = {
		actions = actionCreators,
		router = router,
		state = state2,
		dispatch = dispatch,
		getScreenProps = getScreenProps,
		_dangerouslyGetParent = function(): nil
			return nil
		end,
		isFirstRouteInParent = function(): boolean
			return true
		end,
		_childrenNavigation = getChildrenNavigationCache(callback())
	}

	function result.getChildNavigation(p2)
		return getChildNavigation(result, p2, callback)
	end

	function result.isFocused(p2): boolean
		local state = callback().state
		local routes = state.routes
		local index = state.index

		return p2 == nil or routes[index].key == p2
	end

	function result.addListener(p2, p3)
		if p2 ~= Events.Action then
			return {
				remove = function() end
			}
		end

		p[p3] = true
		return {
			remove = function()
				p[p3] = nil
			end
		}
	end

	local v = Object.assign(getNavigationActionCreators(result.state), actionCreators)

	for k, _ in v do
		result[k] = function(...)
			result.dispatch(v[k](...))
		end
	end

	return result
end
