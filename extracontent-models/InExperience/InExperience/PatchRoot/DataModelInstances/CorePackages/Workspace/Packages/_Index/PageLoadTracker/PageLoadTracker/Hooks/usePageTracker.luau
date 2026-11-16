local parent = script:FindFirstAncestor("PageLoadTracker").Parent
local React = require(parent.React)

local PageTrackerContext = require(script.Parent.Parent.PageTrackerContext)
require(script.Parent.Parent.createPageTracker)
local AppCommonLib = require(script.Parent.Parent.Parent.AppCommonLib)
local Signal = AppCommonLib.Signal

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEnableChatMilestones = SharedFlags.FFlagLuaAppEnableChatMilestones

local function createNoOpTracker()
	return {
		pageName = "",
		startTime = 0,
		lastActivityTime = 0,
		timeoutThread = nil,
		isActive = false,
		numLoads = 0,
		onCompleteSignal = Signal.new(),
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
	local v = React.useContext(PageTrackerContext)

	if v ~= nil then
		return v
	end

	if FFlagLuaAppEnableChatMilestones then
		return React.useMemo(function()
			return createNoOpTracker()
		end, {})
	end

	error("usePageTracker must be used within a PageTrackerContext.Provider")

	return v
end

return usePageTracker
