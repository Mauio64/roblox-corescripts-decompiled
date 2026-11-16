local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PageLoadTracker/React")

local PageTrackerContext = require("@game/CorePackages/Workspace/Packages/_Index/PageLoadTracker/PageLoadTracker/PageTrackerContext")
require("@game/CorePackages/Workspace/Packages/_Index/PageLoadTracker/PageLoadTracker/createPageTracker")
local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/PageLoadTracker/AppCommonLib").Signal

local fFlagLuaAppEnableChatMilestones = require("@game/CorePackages/Workspace/Packages/_Workspace/PageLoadTracker/SharedFlags").FFlagLuaAppEnableChatMilestones

local function createNoOpTracker()
	return {
		pageName = "",
		startTime = 0,
		lastActivityTime = 0,
		timeoutThread = nil,
		isActive = false,
		numLoads = 0,
		onCompleteSignal = signal.new(),
		sentMilestones = {},
		start = function() end,
		logMilestone = function() end,
		stop = function() end,
		onComponentAdded = function() end,
		complete = function() end,
		sendMilestone = function() end
	}
end

local function usePageTracker()
	local v5 = React.useContext(PageTrackerContext)

	if v5 ~= nil then
		return v5
	end

	if fFlagLuaAppEnableChatMilestones then
		return React.useMemo(function()
			return createNoOpTracker()
		end, {})
	end

	error("usePageTracker must be used within a PageTrackerContext.Provider")

	return v5
end

return usePageTracker
