local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Object = require(scriptParentParent.LuauPolyfill).Object
local Events = require(scriptParent.Events)
local getNavigationActionCreators = require(scriptParent.routers.getNavigationActionCreators)
local getChildNavigation = require(scriptParent.getChildNavigation)
local getChildrenNavigationCache = require(scriptParent.getChildrenNavigationCache)

return function(p1, p2, p3, p4, p5, p6) -- line: 13
	-- upvalues: getChildrenNavigationCache (copy), getChildNavigation (copy), Events (copy), Object (copy), getNavigationActionCreators (copy)
	local v14 = p1.getActionCreators(p2, nil)
	local t1 = {
		actions = v14,
		router = p1,
		state = p2,
		dispatch = p3,
		getScreenProps = p5,
		_dangerouslyGetParent = function() -- line: 24
			return nil
		end,
		isFirstRouteInParent = function() -- line: 27
			return true
		end,
		_childrenNavigation = getChildrenNavigationCache(p6())
	}

	function t1.getChildNavigation(p7) -- line: 33
		-- upvalues: getChildNavigation (copy), t1 (copy), p6 (copy)
		return getChildNavigation(t1, p7, p6)
	end
	function t1.isFocused(p8) -- line: 37
		-- upvalues: p6 (copy)
		local state = p6().state
		local routes = state.routes
		local index = state.index

		return p8 == nil or p8 == routes[index].key
	end
	function t1.addListener(p9, p10) -- line: 45
		-- upvalues: Events (copy), p4 (copy)
		if p9 ~= Events.Action then
			return {
				remove = function() -- line: 47
				end
			}
		end

		p4[p10] = true

		return {
			remove = function() -- line: 51
				-- upvalues: p4 (copy), p10 (copy)
				p4[p10] = nil
			end
		}
	end

	local v16 = Object.assign(getNavigationActionCreators(t1.state), v14)

	for v17, _ in v16 do
		t1[v17] = function(...) -- line: 61
			-- upvalues: t1 (copy), v16 (copy), v17 (copy)
			t1.dispatch(v16[v17](...))
		end
	end

	return t1
end
