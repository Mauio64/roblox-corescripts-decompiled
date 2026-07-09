local Parent = script:FindFirstAncestor("RobloxAppNavigationCore").Parent
local Cryo = require(Parent.Cryo)

require(Parent.Navigation)

local createLazyStackRouter = require(script.Parent.createLazyStackRouter)
local LuaAppNavigationActions = require(script.Parent.LuaAppNavigationActions)

return function(p1, p2) -- line: 10
	-- upvalues: Cryo (copy), LuaAppNavigationActions (copy), createLazyStackRouter (copy)
	local v7 = Cryo.Dictionary.join(p2 or {}, {
		getCustomActionCreators = function(_, _) -- line: 12
			-- upvalues: LuaAppNavigationActions (copy)
			return {
				clearAppScreens = LuaAppNavigationActions.clearAppScreens
			}
		end
	})
	local v8 = createLazyStackRouter(p1, v7)
	local getStateForAction = v8.getStateForAction

	function v8.getStateForAction(p5, p6) -- line: 21
		-- upvalues: LuaAppNavigationActions (copy), Cryo (copy), getStateForAction (copy)
		if p5.type == LuaAppNavigationActions.ClearAppScreensAction then
			local v14 = Cryo.List.toSet(p5.routeNames)
			local v15 = Cryo.List.filter(p6.routes, function(p7) -- line: 24
				-- upvalues: v14 (copy)
				return not v14[p7.routeName]
			end)

			return (Cryo.Dictionary.join(p6, {
				routes = v15,
				index = #v15
			}))
		end

		return getStateForAction(p5, p6)
	end

	return v8
end
