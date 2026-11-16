local recordMilestone = require(script.Parent.recordMilestone)
local PageLoadConfig = require(script.Parent.PageLoadConfig)
require(script.Parent.PageLoadTypes)
local AppCommonLib = require(script.Parent.Parent.AppCommonLib)
local Signal = AppCommonLib.Signal
local SharedFlags = require(script.Parent.Parent.SharedFlags)
local isElementContentful = require(script.Parent.isElementContentful)

local IDLE_TIMEOUT_SECONDS = PageLoadConfig.IDLE_TIMEOUT_SECONDS

local function getGuiObjectArea(p) -- 1 equivalent call inferred from this helper
	return p.AbsoluteSize.X * p.AbsoluteSize.Y
end

local function createPageTracker()
	local pageTracker = {
		pageName = "",
		startTime = 0,
		lastActivityTime = 0,
		timeoutThread = nil,
		isActive = false,
		numLoads = 0,
		onCompleteSignal = Signal.new(),
		sentMilestones = {}
	}

	function pageTracker:start(value: string)
		if self.isActive then
			return
		end

		self.pageName = value or "UnknownPage"
		self.startTime = os.clock()
		self.lastActivityTime = self.startTime
		self.isActive = true
		self.numLoads += 1
		self.sentMilestones = {}

		if SharedFlags.FFlagLuaAppEnableContentfulPaintTracking then
			if SharedFlags.FFlagLuaAppLCPTimingFix then
				self.LCPCandidate = { guiArea = 0, timestamp = self.startTime }
			else
				self.LCPCandidate = { guiArea = 0, timestamp = 0 }
			end
		end

		self.timeoutThread = task.delay(IDLE_TIMEOUT_SECONDS, function()
			self:complete()
		end)
	end

	function pageTracker:logMilestone()
		if not self.isActive then
			return
		end

		self.lastActivityTime = os.clock()

		if self.timeoutThread then
			task.cancel(self.timeoutThread)
		end

		self.timeoutThread = task.delay(IDLE_TIMEOUT_SECONDS, function()
			self:complete()
		end)
	end

	function pageTracker:sendMilestone(milestone_name: string, p: number?)
		local time_from_start

		if SharedFlags.FFlagLuaAppEnableContentfulPaintTracking then
			time_from_start = ((p or os.clock()) - self.startTime) * 1000
		else
			time_from_start = (os.clock() - self.startTime) * 1000
		end

		if SharedFlags.FFlagLuaAppEnableMilestoneDeduplication then
			if self.sentMilestones[milestone_name] then
				return
			end

			self.sentMilestones[milestone_name] = true
		end

		recordMilestone({
			app_page_name = self.pageName,
			milestone_name = milestone_name,
			time_from_start = time_from_start,
			first_load = self.numLoads == 1
		})
	end

	function pageTracker:onComponentAdded(p)
		if not self.isActive then
			return
		end

		if SharedFlags.FFlagLuaAppEnableContentfulPaintTracking and isElementContentful(p) then
			local guiObjectArea = getGuiObjectArea(p) -- inferred equivalent call

			if self.LCPCandidate.guiArea < guiObjectArea then
				self:sendMilestone("first_contentful_paint")
				self.LCPCandidate = { guiArea = guiObjectArea, timestamp = os.clock() }
			end
		end

		self:logMilestone()
	end

	function pageTracker:stop()
		if not self.isActive then
			return
		end

		if self.timeoutThread then
			task.cancel(self.timeoutThread)
			self.timeoutThread = nil
		end

		self.isActive = false

		if SharedFlags.FFlagPageLoadAllowImprovedDisconnectTiming then
			self.onCompleteSignal:fire()
		end
	end

	function pageTracker:complete()
		if not self.isActive then
			return
		end

		if not SharedFlags.FFlagLuaAppEnableContentfulPaintTracking then
			self.isActive = false
		end

		self.timeoutThread = nil

		if SharedFlags.FFlagLuaAppEnableContentfulPaintTracking then
			self:sendMilestone("initial_viewport_loaded", self.lastActivityTime)

			if SharedFlags.FFlagLuaAppLCPTimingFix then
				if self.LCPCandidate.guiArea > 0 then
					self:sendMilestone("largest_contentful_paint", self.LCPCandidate.timestamp)
				end
			else
				self:sendMilestone("largest_contentful_paint", self.LCPCandidate.timestamp)
			end
		else
			local time_from_start = (self.lastActivityTime - self.startTime) * 1000
			recordMilestone({
				app_page_name = self.pageName,
				milestone_name = "initial_viewport_loaded",
				time_from_start = time_from_start,
				first_load = self.numLoads == 1
			})
		end

		if SharedFlags.FFlagPageLoadAllowImprovedDisconnectTiming then
			self.onCompleteSignal:fire()
		end
	end

	return pageTracker
end

return createPageTracker
