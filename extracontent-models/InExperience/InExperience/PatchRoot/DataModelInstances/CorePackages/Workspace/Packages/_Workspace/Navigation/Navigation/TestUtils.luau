require(script.Parent.types)

local function createMockRouteState(routeName: string, params, routes, isTransitioning: boolean?) -- 2 equivalent calls inferred from this helper
	local mockRouteState = {
		key = routeName,
		routeName = routeName,
		params = params,
		isTransitioning = isTransitioning
	}

	if routes ~= nil then
		mockRouteState.routes = routes
		mockRouteState.index = #routes
	end

	return mockRouteState
end

local TestUtils = {}

function TestUtils.createMockStackState(routeName: string, routes)
	return createMockRouteState(routeName, nil, routes, false) -- inferred equivalent call
end

function TestUtils.createMockSwitchState(p: string, routes)
	return createMockRouteState(p, nil, routes) -- inferred equivalent call
end

function TestUtils.createMockScreenState(routeName: string, params)
	return { key = routeName, routeName = routeName, params = params, isTransitioning = nil }
end

function TestUtils.createMockNavigationObject(state)
	return {
		state = state,
		dispatch = function(): boolean
			return true
		end,
		getParam = function(...) end,
		addListener = function(_, _)
			return {
				remove = function() end
			}
		end,
		isFocused = function() end,
		getChildNavigation = function(_): nil
			return nil
		end,
		router = {
			getScreenOptions = function(_, _)
				return {}
			end,
			getStateForAction = function(_, p)
				return p
			end,
			getComponentForRouteName = function(_)
				return function(): nil
					return nil
				end
			end,
			getActionCreators = function()
				return {}
			end,
			childRouters = {}
		},
		_dangerouslyGetParent = function(): nil
			return nil
		end
	}
end

return TestUtils
