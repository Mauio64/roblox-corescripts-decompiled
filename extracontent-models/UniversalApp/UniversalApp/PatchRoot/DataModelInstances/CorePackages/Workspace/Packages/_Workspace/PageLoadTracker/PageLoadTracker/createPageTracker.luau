local recordMilestone = require(script.Parent.recordMilestone)
local PageLoadConfig = require(script.Parent.PageLoadConfig)

require(script.Parent.PageLoadTypes)

local Signal = require(script.Parent.Parent.AppCommonLib).Signal
local SharedFlags = require(script.Parent.Parent.SharedFlags)
local isElementContentful = require(script.Parent.isElementContentful)
local IDLE_TIMEOUT_SECONDS = PageLoadConfig.IDLE_TIMEOUT_SECONDS

local function getGuiObjectArea(p1) -- line: 30
	return p1.AbsoluteSize.X * p1.AbsoluteSize.Y
end
local function createPageTracker() -- line: 34
	-- upvalues: Signal (copy), SharedFlags (copy), IDLE_TIMEOUT_SECONDS (copy), recordMilestone (copy), isElementContentful (copy)
	return {
		pageName = "",
		startTime = 0,
		lastActivityTime = 0,
		timeoutThread = nil,
		isActive = false,
		numLoads = 0,
		onCompleteSignal = Signal.new(),
		sentMilestones = {},
		start = function(t1: {[any]: any}, s1: string) -- line: 46
			-- upvalues: SharedFlags (copy), IDLE_TIMEOUT_SECONDS (copy)
			if t1.isActive then
				return
			end

			t1.pageName = s1 or "UnknownPage"
			t1.startTime = os.clock()
			t1.lastActivityTime = t1.startTime
			t1.isActive = true
			t1.numLoads = t1.numLoads + 1
			t1.sentMilestones = {}

			if SharedFlags.FFlagLuaAppEnableContentfulPaintTracking then
				if SharedFlags.FFlagLuaAppLCPTimingFix then
					t1.LCPCandidate = {
						guiArea = 0,
						timestamp = t1.startTime
					}
				else
					t1.LCPCandidate = {
						guiArea = 0,
						timestamp = 0
					}
				end
			end

			t1.timeoutThread = task.delay(IDLE_TIMEOUT_SECONDS, function() -- line: 71
				-- upvalues: t1 (copy)
				t1:complete()
			end)
		end,
		logMilestone = function(p2) -- line: 76
			-- upvalues: IDLE_TIMEOUT_SECONDS (copy)
			if not p2.isActive then
				return
			end

			p2.lastActivityTime = os.clock()

			if p2.timeoutThread then
				task.cancel(p2.timeoutThread)
			end

			p2.timeoutThread = task.delay(IDLE_TIMEOUT_SECONDS, function() -- line: 89
				-- upvalues: p2 (copy)
				p2:complete()
			end)
		end,
		sendMilestone = function(t2: {[any]: any}, s2: string, n1: number?) -- line: 94
			-- upvalues: SharedFlags (copy), recordMilestone (copy)
			local v16 = if not SharedFlags.FFlagLuaAppEnableContentfulPaintTracking then (os.clock() - t2.startTime) * 1000 else ((n1 or os.clock()) - t2.startTime) * 1000

			if SharedFlags.FFlagLuaAppEnableMilestoneDeduplication then
				if t2.sentMilestones[s2] then
					return
				end

				t2.sentMilestones[s2] = true
			end

			local t3 = {
				app_page_name = t2.pageName,
				milestone_name = s2,
				time_from_start = v16,
				first_load = t2.numLoads == 1
			}

			recordMilestone(t3)
		end,
		onComponentAdded = function(t4: {[any]: any}, p3) -- line: 116
			-- upvalues: SharedFlags (copy), isElementContentful (copy)
			if not t4.isActive then
				return
			end

			if SharedFlags.FFlagLuaAppEnableContentfulPaintTracking and isElementContentful(p3) then
				local v20 = p3.AbsoluteSize.X * p3.AbsoluteSize.Y

				if v20 > t4.LCPCandidate.guiArea then
					t4:sendMilestone("first_contentful_paint")
					t4.LCPCandidate = {
						guiArea = v20,
						timestamp = os.clock()
					}
				end
			end

			t4:logMilestone()
		end,
		stop = function(p4) -- line: 135
			-- upvalues: SharedFlags (copy)
			if not p4.isActive then
				return
			end

			if p4.timeoutThread then
				task.cancel(p4.timeoutThread)
				p4.timeoutThread = nil
			end

			p4.isActive = false

			if SharedFlags.FFlagPageLoadAllowImprovedDisconnectTiming then
				p4.onCompleteSignal:fire()
			end
		end,
		complete = function(p5) -- line: 151
			-- upvalues: SharedFlags (copy), recordMilestone (copy)
			if not p5.isActive then
				return
			end

			if not SharedFlags.FFlagLuaAppEnableContentfulPaintTracking then
				p5.isActive = false
			end

			p5.timeoutThread = nil

			if SharedFlags.FFlagLuaAppEnableContentfulPaintTracking then
				p5:sendMilestone("initial_viewport_loaded", p5.lastActivityTime)

				if SharedFlags.FFlagLuaAppLCPTimingFix then
					if p5.LCPCandidate.guiArea > 0 then
						p5:sendMilestone("largest_contentful_paint", p5.LCPCandidate.timestamp)
					end
				else
					p5:sendMilestone("largest_contentful_paint", p5.LCPCandidate.timestamp)
				end
			else
				local v23 = (p5.lastActivityTime - p5.startTime) * 1000
				local t5 = {
					milestone_name = "initial_viewport_loaded",
					app_page_name = p5.pageName,
					time_from_start = v23,
					first_load = p5.numLoads == 1
				}

				recordMilestone(t5)
			end

			if SharedFlags.FFlagPageLoadAllowImprovedDisconnectTiming then
				p5.onCompleteSignal:fire()
			end
		end
	}
end

return createPageTracker
