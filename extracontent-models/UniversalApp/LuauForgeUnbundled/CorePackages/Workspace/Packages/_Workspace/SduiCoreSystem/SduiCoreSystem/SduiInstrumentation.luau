local discoveryAppLaunchTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/AppLaunchTracker").DiscoveryAppLaunchTracker

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
local SduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors")

local v5 = game:DefineFastInt("DiscoverySduiInstrumentationHundredthsPercent", 0) >= math.random(10000)

local class = {}
class.__index = class

function class.new(value, p2)
	local v6 = {
		startTime = 0,
		openTimerCount = 0,
		openTimers = {},
		closedTimers = {},
		isFlushScheduled = false,
		flushDelay = value or 0.1,
		enabled = p2 or v5
	}

	setmetatable(v6, class)
	return v6
end

function class:startTimerFlow(p2)
	if not self.enabled then
		return
	end

	local v6 = 1000 * os.clock()

	if self.openTimerCount == 0 then
		self.startTime = v6
	end

	self.openTimerCount += 1

	local openTimer = self.openTimers[p2]

	if not openTimer then
		self.openTimers[p2] = { startTime = v6, failed = 0, count = 1, openCount = 1 }

		return
	end

	if openTimer.openCount == 0 then
		openTimer.startTime = v6
	end

	openTimer.count += 1
	openTimer.openCount += 1
end

function class:stopTimerFlow(p2, p3, p4)
	if not self.enabled then
		return
	end

	self.openTimerCount -= 1

	local openTimer = self.openTimers[p2]

	if not openTimer then
		p3.dependencies.logger.reportError(
			SduiErrors.SduiErrorType.NilInstrumentationTimer,
			{ name = p2, message = "Failed to find timer when calling stopTimer" },
			p3.appPage
		)
		return
	end

	if p4 then
		openTimer.failed += 1
	end

	openTimer.openCount -= 1

	if openTimer.openCount == 0 then
		local v6 = 1000 * os.clock()
		local v7 = v6 - openTimer.startTime
		self:aggregateClosedTimer(p2, openTimer.count, openTimer.failed, v7)
		self.openTimers[p2] = nil

		if self.openTimerCount == 0 then
			self:scheduleFlush(p3)
			local v8 = v6 - self.startTime

			if discoveryAppLaunchTracker.isEnabled() and discoveryAppLaunchTracker.default then
				discoveryAppLaunchTracker.default:trackSduiDuration(v8)
			end
		elseif self.openTimerCount < 1 then
			p3.dependencies.logger.reportError(
				SduiErrors.SduiErrorType.ImbalancedStartStopTimer,
				{
					name = p2,
					message = `Negative timer count when stopping timer {self.openTimerCount}`
				},
				p3.appPage
			)
		end
	end
end

function class:aggregateClosedTimer(p3, p4, p5, p6)
	local closedTimer = self.closedTimers[p3]

	if not closedTimer then
		self.closedTimers[p3] = { failed = p5, count = p4, durationMs = p6 }

		return
	end

	closedTimer.failed += p5
	closedTimer.count += p4
	closedTimer.durationMs += p6
end

function class:scheduleFlush(p2)
	if self.enabled and not self.isFlushScheduled then
		task.delay(self.flushDelay, function()
			self.isFlushScheduled = false
			self:reportTimers(p2)
		end)
		self.isFlushScheduled = true
	end
end

function class:reportTimers(p2)
	if self.enabled then
		p2.dependencies.logger.reportTimers(self.closedTimers, p2.appPage)
		self.closedTimers = {}
	end
end

return class
