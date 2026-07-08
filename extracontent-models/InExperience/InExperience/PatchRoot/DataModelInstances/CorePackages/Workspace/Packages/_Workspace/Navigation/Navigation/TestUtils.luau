require(script.Parent.types)

local function createMockRouteState(s1: string, p1, t1: {[any]: any}?, b1: boolean?) -- line: 8
	local t2 = {
		key = s1,
		routeName = s1,
		params = p1,
		isTransitioning = b1
	}

	if t1 ~= nil then
		t2.routes = t1
		t2.index = #t1
	end

	return t2
end

return {
	createMockStackState = function(s2: string, t3: {[any]: any}) -- line: 27
		local t4 = {
			params = nil,
			isTransitioning = false,
			key = s2,
			routeName = s2
		}

		if t3 ~= nil then
			t4.routes = t3
			t4.index = #t3
		end

		return t4
	end,
	createMockSwitchState = function(s3: string, t5: {[any]: any}) -- line: 31
		local t6 = {
			params = nil,
			isTransitioning = nil,
			key = s3,
			routeName = s3
		}

		if t5 ~= nil then
			t6.routes = t5
			t6.index = #t5
		end

		return t6
	end,
	createMockScreenState = function(s4: string, p2) -- line: 35
		return {
			isTransitioning = nil,
			key = s4,
			routeName = s4,
			params = p2
		}
	end,
	createMockNavigationObject = function(p3) -- line: 39
		return {
			state = p3,
			dispatch = function() -- line: 42
				return true
			end,
			getParam = function(...) -- line: 45
			end,
			addListener = function(_, _) -- line: 48
				return {
					remove = function() -- line: 49
					end
				}
			end,
			isFocused = function() -- line: 51
			end,
			getChildNavigation = function(_) -- line: 52
				return nil
			end,
			router = {
				getScreenOptions = function(_, _) -- line: 56
					return {}
				end,
				getStateForAction = function(_, p10) -- line: 59
					return p10
				end,
				getComponentForRouteName = function(_) -- line: 62
					return function() -- line: 63
						return nil
					end
				end,
				getActionCreators = function() -- line: 67
					return {}
				end,
				childRouters = {}
			},
			_dangerouslyGetParent = function() -- line: 72
				return nil
			end
		}
	end
}
