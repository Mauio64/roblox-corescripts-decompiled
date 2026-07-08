local Parent = script:FindFirstAncestor("PageLoadTracker").Parent
local React = require(Parent.React)
local PageTrackerContext = require(script.Parent.Parent.PageTrackerContext)

require(script.Parent.Parent.createPageTracker)

local Signal = require(script.Parent.Parent.Parent.AppCommonLib).Signal
local FFlagLuaAppEnableChatMilestones = require(Parent.SharedFlags).FFlagLuaAppEnableChatMilestones

local function createNoOpTracker() -- line: 11
	-- upvalues: Signal (copy)
	return {
		pageName = "",
		startTime = 0,
		lastActivityTime = 0,
		timeoutThread = nil,
		isActive = false,
		numLoads = 0,
		onCompleteSignal = Signal.new(),
		sentMilestones = {},
		start = function() -- line: 22
		end,
		logMilestone = function() -- line: 23
		end,
		stop = function() -- line: 24
		end,
		onComponentAdded = function() -- line: 25
		end,
		complete = function() -- line: 26
		end,
		sendMilestone = function() -- line: 27
		end
	}
end
local function usePageTracker() -- line: 31
	-- upvalues: React (copy), PageTrackerContext (copy), FFlagLuaAppEnableChatMilestones (copy), createNoOpTracker (copy)
	local v8 = React.useContext(PageTrackerContext)

	if v8 == nil then
		if FFlagLuaAppEnableChatMilestones then
			return React.useMemo(function() -- line: 36
				-- upvalues: createNoOpTracker (copy)
				return (createNoOpTracker())
			end, {})
		end

		error("usePageTracker must be used within a PageTrackerContext.Provider")
	end

	return v8
end

return usePageTracker
