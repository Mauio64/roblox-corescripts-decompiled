require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/types")

local function createMockRouteState(p2, p3, routes, p4)
	local mockRouteState = {
		key = p2,
		routeName = p2,
		params = p3,
		isTransitioning = p4
	}

	if routes ~= nil then
		mockRouteState.routes = routes
		mockRouteState.index = #routes
	end

	return mockRouteState
end

return {
	createMockStackState = function(p2, routes)
		local mockStackState = {
			key = p2,
			routeName = p2,
			params = nil,
			isTransitioning = false
		}

		if routes ~= nil then
			mockStackState.routes = routes
			mockStackState.index = #routes
		end

		return mockStackState
	end,
	createMockSwitchState = function(p2, routes)
		local mockSwitchState = {
			key = p2,
			routeName = p2,
			params = nil,
			isTransitioning = nil
		}

		if routes ~= nil then
			mockSwitchState.routes = routes
			mockSwitchState.index = #routes
		end

		return mockSwitchState
	end,
	createMockScreenState = function(p2, p3)
		return { key = p2, routeName = p2, params = p3, isTransitioning = nil }
	end,
	createMockNavigationObject = function(p2)
		return {
			state = p2,
			dispatch = function(): boolean
				return true
			end,
			getParam = function(...) end,
			addListener = function(p3, p4)
				return {
					remove = function() end
				}
			end,
			isFocused = function() end,
			getChildNavigation = function(p3): nil
				return nil
			end,
			router = {
				getScreenOptions = function(p3, p4)
					return {}
				end,
				getStateForAction = function(p3, p4)
					return p4
				end,
				getComponentForRouteName = function(p3)
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
}
