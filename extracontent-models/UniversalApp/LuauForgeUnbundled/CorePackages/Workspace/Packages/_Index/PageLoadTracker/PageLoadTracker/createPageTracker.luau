local recordMilestone = require("@game/CorePackages/Workspace/Packages/_Index/PageLoadTracker/PageLoadTracker/recordMilestone")
local PageLoadConfig = require("@game/CorePackages/Workspace/Packages/_Index/PageLoadTracker/PageLoadTracker/PageLoadConfig")
require("@game/CorePackages/Workspace/Packages/_Index/PageLoadTracker/PageLoadTracker/PageLoadTypes")
local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/PageLoadTracker/AppCommonLib").Signal
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/PageLoadTracker/SharedFlags")
local isElementContentful = require("@game/CorePackages/Workspace/Packages/_Index/PageLoadTracker/PageLoadTracker/isElementContentful")

local IDLE_TIMEOUT_SECONDS = PageLoadConfig.IDLE_TIMEOUT_SECONDS

local function getGuiObjectArea(p2)
	return p2.AbsoluteSize.X * p2.AbsoluteSize.Y
end

local function createPageTracker()
	local pageTracker = {
		pageName = "",
		startTime = 0,
		lastActivityTime = 0,
		timeoutThread = nil,
		isActive = false,
		numLoads = 0,
		onCompleteSignal = signal.new(),
		sentMilestones = {}
	}

	function pageTracker:start(value)
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

	function pageTracker:sendMilestone(p2, p3)
		local v5

		if SharedFlags.FFlagLuaAppEnableContentfulPaintTracking then
			v5 = ((p3 or os.clock()) - self.startTime) * 1000
		else
			v5 = (os.clock() - self.startTime) * 1000
		end

		if SharedFlags.FFlagLuaAppEnableMilestoneDeduplication then
			if self.sentMilestones[p2] then
				return
			end

			self.sentMilestones[p2] = true
		end

		recordMilestone({
			app_page_name = self.pageName,
			milestone_name = p2,
			time_from_start = v5,
			first_load = self.numLoads == 1
		})
	end

	function pageTracker:onComponentAdded(p2)
		if not self.isActive then
			return
		end

		if SharedFlags.FFlagLuaAppEnableContentfulPaintTracking and isElementContentful(p2) then
			local v5 = p2.AbsoluteSize.X * p2.AbsoluteSize.Y

			if self.LCPCandidate.guiArea < v5 then
				self:sendMilestone("first_contentful_paint")
				self.LCPCandidate = { guiArea = v5, timestamp = os.clock() }
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
			local v5 = (self.lastActivityTime - self.startTime) * 1000
			recordMilestone({
				app_page_name = self.pageName,
				milestone_name = "initial_viewport_loaded",
				time_from_start = v5,
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
