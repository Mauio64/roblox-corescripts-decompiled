local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent

local AppLaunchTracker = require(parent.AppLaunchTracker)
local DiscoveryAppLaunchTracker = AppLaunchTracker.DiscoveryAppLaunchTracker

require(SduiCoreSystem.SduiBuilderTypes)
local SduiErrors = require(SduiCoreSystem.SduiErrors)

local v = game:DefineFastInt("DiscoverySduiInstrumentationHundredthsPercent", 0) >= math.random(10000)

local SduiInstrumentation = {}
SduiInstrumentation.__index = SduiInstrumentation

function SduiInstrumentation.new(value: number?, flag: boolean?)
	local v2 = {
		startTime = 0,
		openTimerCount = 0,
		openTimers = {},
		closedTimers = {},
		isFlushScheduled = false,
		flushDelay = value or 0.1,
		enabled = flag or v
	}

	setmetatable(v2, SduiInstrumentation)
	return v2
end

function SduiInstrumentation:startTimerFlow(p: string)
	if not self.enabled then
		return
	end

	local startTime = 1000 * os.clock()

	if self.openTimerCount == 0 then
		self.startTime = startTime
	end

	self.openTimerCount += 1

	local openTimer = self.openTimers[p]

	if not openTimer then
		self.openTimers[p] = { startTime = startTime, failed = 0, count = 1, openCount = 1 }

		return
	end

	if openTimer.openCount == 0 then
		openTimer.startTime = startTime
	end

	openTimer.count += 1
	openTimer.openCount += 1
end

function SduiInstrumentation:stopTimerFlow(name: string, p, flag: boolean?)
	if not self.enabled then
		return
	end

	self.openTimerCount -= 1

	local openTimer = self.openTimers[name]

	if not openTimer then
		p.dependencies.logger.reportError(
			SduiErrors.SduiErrorType.NilInstrumentationTimer,
			{ name = name, message = "Failed to find timer when calling stopTimer" },
			p.appPage
		)
		return
	end

	if flag then
		openTimer.failed += 1
	end

	openTimer.openCount -= 1

	if openTimer.openCount == 0 then
		local v2 = 1000 * os.clock()
		local v3 = v2 - openTimer.startTime
		self:aggregateClosedTimer(name, openTimer.count, openTimer.failed, v3)
		self.openTimers[name] = nil

		if self.openTimerCount == 0 then
			self:scheduleFlush(p)
			local v4 = v2 - self.startTime

			if DiscoveryAppLaunchTracker.isEnabled() and DiscoveryAppLaunchTracker.default then
				DiscoveryAppLaunchTracker.default:trackSduiDuration(v4)
			end
		elseif self.openTimerCount < 1 then
			p.dependencies.logger.reportError(
				SduiErrors.SduiErrorType.ImbalancedStartStopTimer,
				{
					name = name,
					message = `Negative timer count when stopping timer {self.openTimerCount}`
				},
				p.appPage
			)
		end
	end
end

function SduiInstrumentation:aggregateClosedTimer(p: string, count: number, failed: number, durationMs: number)
	local closedTimer = self.closedTimers[p]

	if not closedTimer then
		self.closedTimers[p] = { failed = failed, count = count, durationMs = durationMs }

		return
	end

	closedTimer.failed += failed
	closedTimer.count += count
	closedTimer.durationMs += durationMs
end

function SduiInstrumentation:scheduleFlush(p)
	if self.enabled and not self.isFlushScheduled then
		task.delay(self.flushDelay, function()
			self.isFlushScheduled = false
			self:reportTimers(p)
		end)
		self.isFlushScheduled = true
	end
end

function SduiInstrumentation:reportTimers(p)
	if self.enabled then
		p.dependencies.logger.reportTimers(self.closedTimers, p.appPage)
		self.closedTimers = {}
	end
end

return SduiInstrumentation
