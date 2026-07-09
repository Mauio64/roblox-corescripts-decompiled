local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local NavigationEvents = require(CorePackages.Packages.RoactNavigation).NavigationEvents
local useRouteName = require(CorePackages.Workspace.Packages.Navigation).useRouteName
local v5 = require(CorePackages.Workspace.Packages.AppDebug).LogTree.logger("ax.rn.events")

if not v5.active[v5.Levels.Debug] then
	return function() -- line: 11
	end
end

local function NavigationEventsLogger() -- line: 14
	-- upvalues: useRouteName (copy), v5 (copy), React (copy), NavigationEvents (copy)
	local v7 = useRouteName()

	local function logEvent(p1) -- line: 17
		-- upvalues: v5 (copy), v7 (copy)
		v5:debug("[{}] {}", v7, p1)
	end

	React.useEffect(function() -- line: 21
		-- upvalues: v5 (copy), v7 (copy)
		v5:debug("[{}] {}", v7, "didMount")

		return function() -- line: 23
			-- upvalues: v5 (copy), v7 (copy)
			v5:debug("[{}] {}", v7, "willUnmount")
		end
	end, {})

	return React.createElement(NavigationEvents, {
		onWillFocus = function() -- line: 29
			-- upvalues: v5 (copy), v7 (copy)
			v5:debug("[{}] {}", v7, "onWillFocus")
		end,
		onWillBlur = function() -- line: 32
			-- upvalues: v5 (copy), v7 (copy)
			v5:debug("[{}] {}", v7, "onWillBlur")
		end,
		onDidFocus = function() -- line: 35
			-- upvalues: v5 (copy), v7 (copy)
			v5:debug("[{}] {}", v7, "onDidFocus")
		end,
		onDidBlur = function() -- line: 38
			-- upvalues: v5 (copy), v7 (copy)
			v5:debug("[{}] {}", v7, "onDidBlur")
		end
	})
end

return NavigationEventsLogger
