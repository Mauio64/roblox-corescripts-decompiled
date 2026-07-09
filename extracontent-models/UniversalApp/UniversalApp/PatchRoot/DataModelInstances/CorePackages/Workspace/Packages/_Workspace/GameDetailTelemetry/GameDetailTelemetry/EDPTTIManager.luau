local Parent = script:FindFirstAncestor("GameDetailTelemetry").Parent
local TimeToInteractiveTracker = require(Parent.TimeToInteractiveTracker).TimeToInteractiveTracker
local Milestone = TimeToInteractiveTracker.Milestone
local EDPTTIConstants = require(script.Parent.EDPTTIConstants)
local v5 = game:DefineFastFlag("EnableEDPTTIManagerColdWarmDetection", false)
local EDP_TTI_EVENT_NAME = EDPTTIConstants.EDP_TTI_EVENT_NAME
local u7 = false
local u8 = false

return {
	startTracking = function(s1: string) -- line: 18
		-- upvalues: u7 (ref), u8 (ref), TimeToInteractiveTracker (copy), EDP_TTI_EVENT_NAME (copy), v5 (copy)
		u7 = false
		u8 = false

		local v10 = TimeToInteractiveTracker.getEvents(false)[EDP_TTI_EVENT_NAME]

		if not v10 or not v10.startTime then
			TimeToInteractiveTracker.trackStart(EDP_TTI_EVENT_NAME, not not v5 or nil)
			TimeToInteractiveTracker.updateMetadata(EDP_TTI_EVENT_NAME, {
				page = s1
			})
		end
	end,
	setImplementation = function(s2: string) -- line: 35
		-- upvalues: TimeToInteractiveTracker (copy), EDP_TTI_EVENT_NAME (copy)
		TimeToInteractiveTracker.updateMetadata(EDP_TTI_EVENT_NAME, {
			category = s2
		})
	end,
	trackFunctionallyReady = function() -- line: 41
		-- upvalues: u7 (ref), TimeToInteractiveTracker (copy), EDP_TTI_EVENT_NAME (copy), Milestone (copy)
		if u7 then
			return
		end

		u7 = true

		if TimeToInteractiveTracker.trackMilestone then
			TimeToInteractiveTracker.trackMilestone(EDP_TTI_EVENT_NAME, Milestone.FunctionallyReady)
		end
	end,
	trackSurfaceReady = function(t1: {[any]: any}?) -- line: 52
		-- upvalues: u8 (ref), TimeToInteractiveTracker (copy), EDP_TTI_EVENT_NAME (copy), Milestone (copy)
		if u8 then
			return
		end

		u8 = true

		if t1 then
			TimeToInteractiveTracker.updateMetadata(EDP_TTI_EVENT_NAME, t1)
		end

		if TimeToInteractiveTracker.trackMilestone then
			TimeToInteractiveTracker.trackMilestone(EDP_TTI_EVENT_NAME, Milestone.SurfaceReady)
		end

		TimeToInteractiveTracker.trackEnd(EDP_TTI_EVENT_NAME)
	end
}
