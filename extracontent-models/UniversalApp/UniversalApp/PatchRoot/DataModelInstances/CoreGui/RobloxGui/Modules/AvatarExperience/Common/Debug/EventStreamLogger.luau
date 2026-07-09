local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local NavigationEvents = require(CorePackages.Packages.RoactNavigation).NavigationEvents

local function EventStreamLogger(t1: {[any]: any}) -- line: 24
	-- upvalues: useRoactService (copy), RoactAnalytics (copy), React (copy), NavigationEvents (copy)
	local v9 = useRoactService(RoactAnalytics)

	local function sendEventLog() -- line: 27
		-- upvalues: v9 (copy), t1 (copy)
		v9.EventStream:sendEventDeferred(t1.eventContext, t1.eventName, t1.additionalArgs)
	end

	React.useEffect(function() -- line: 31
		-- upvalues: t1 (copy), v9 (copy)
		if t1.when == "OnMount" then
			v9.EventStream:sendEventDeferred(t1.eventContext, t1.eventName, t1.additionalArgs)
		end
	end, {})

	if t1.when == "OnFocus" then
		return React.createElement(NavigationEvents, {
			onDidFocus = sendEventLog
		})
	end

	return nil
end

return EventStreamLogger
