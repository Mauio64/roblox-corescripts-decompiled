local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local navigationEvents = RoactNavigation.NavigationEvents
local useRouteName = require("@game/CorePackages/Workspace/Packages/Navigation").useRouteName

local logger = require("@game/CorePackages/Workspace/Packages/AppDebug").LogTree.logger("ax.rn.events")

if not logger.active[logger.Levels.Debug] then
	return function() end
end

local function NavigationEventsLogger()
	local v5 = useRouteName()

	local function logEvent(p2)
		logger:debug("[{}] {}", v5, p2)
	end

	React.useEffect(function()
		logger:debug("[{}] {}", v5, "didMount")

		return function()
			logger:debug("[{}] {}", v5, "willUnmount")
		end
	end, {})

	return React.createElement(navigationEvents, {
		onWillFocus = function()
			logger:debug("[{}] {}", v5, "onWillFocus")
		end,
		onWillBlur = function()
			logger:debug("[{}] {}", v5, "onWillBlur")
		end,
		onDidFocus = function()
			logger:debug("[{}] {}", v5, "onDidFocus")
		end,
		onDidBlur = function()
			logger:debug("[{}] {}", v5, "onDidBlur")
		end
	})
end

return NavigationEventsLogger
