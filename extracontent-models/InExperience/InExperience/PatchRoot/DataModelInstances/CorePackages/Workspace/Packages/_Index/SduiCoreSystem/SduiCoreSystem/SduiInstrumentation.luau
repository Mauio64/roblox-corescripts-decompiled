local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local DiscoveryAppLaunchTracker = require(SduiCoreSystemParent.AppLaunchTracker).DiscoveryAppLaunchTracker

require(SduiCoreSystem.SduiBuilderTypes)

local SduiErrors = require(SduiCoreSystem.SduiErrors)
local v5 = game:DefineFastInt("DiscoverySduiInstrumentationHundredthsPercent", 0) >= math.random(10000)
local t1 = {}

t1.__index = t1

function t1.new(n1: number?, b1: boolean?) -- line: 43
	-- upvalues: v5 (copy), t1 (copy)
	local t2 = {
		startTime = 0,
		openTimerCount = 0,
		isFlushScheduled = false,
		openTimers = {},
		closedTimers = {},
		flushDelay = n1 or 0.1,
		enabled = b1 or v5
	}

	setmetatable(t2, t1)

	return t2
end
function t1.startTimerFlow(p1, s1: string) -- line: 57
	if not p1.enabled then
		return
	end

	local v12 = 1000 * os.clock()

	if p1.openTimerCount == 0 then
		p1.startTime = v12
	end

	p1.openTimerCount = p1.openTimerCount + 1

	local v13 = p1.openTimers[s1]

	if v13 then
		if v13.openCount == 0 then
			v13.startTime = v12
		end

		v13.count = v13.count + 1
		v13.openCount = v13.openCount + 1

		return
	end

	p1.openTimers[s1] = {
		failed = 0,
		count = 1,
		openCount = 1,
		startTime = v12
	}
end
function t1.stopTimerFlow(p2, s2: string, p3, b2: boolean?) -- line: 90
	-- upvalues: SduiErrors (copy), DiscoveryAppLaunchTracker (copy)
	if not p2.enabled then
		return
	end

	p2.openTimerCount = p2.openTimerCount - 1

	local v18 = p2.openTimers[s2]

	if not v18 then
		p3.dependencies.logger.reportError(SduiErrors.SduiErrorType.NilInstrumentationTimer, {
			message = "Failed to find timer when calling stopTimer",
			name = s2
		}, p3.appPage)

		return
	end

	if b2 then
		v18.failed = v18.failed + 1
	end

	v18.openCount = v18.openCount - 1

	if v18.openCount == 0 then
		local v19 = 1000 * os.clock()
		local v20 = v19 - v18.startTime

		p2:aggregateClosedTimer(s2, v18.count, v18.failed, v20)
		p2.openTimers[s2] = nil

		if p2.openTimerCount == 0 then
			p2:scheduleFlush(p3)

			local v21 = v19 - p2.startTime

			if DiscoveryAppLaunchTracker.isEnabled() and DiscoveryAppLaunchTracker.default then
				DiscoveryAppLaunchTracker.default:trackSduiDuration(v21)

				return
			end
		elseif p2.openTimerCount < 1 then
			p3.dependencies.logger.reportError(SduiErrors.SduiErrorType.ImbalancedStartStopTimer, {
				name = s2,
				message = `Negative timer count when stopping timer { p2.openTimerCount }`
			}, p3.appPage)
		end
	end
end
function t1.aggregateClosedTimer(p4, s3: string, n2: number, n3: number, n4: number) -- line: 137
	local v27 = p4.closedTimers[s3]

	if v27 then
		v27.failed = v27.failed + n3
		v27.count = v27.count + n2
		v27.durationMs = v27.durationMs + n4

		return
	end

	p4.closedTimers[s3] = {
		failed = n3,
		count = n2,
		durationMs = n4
	}
end
function t1.scheduleFlush(p5, p6) -- line: 158
	if p5.enabled and not p5.isFlushScheduled then
		task.delay(p5.flushDelay, function() -- line: 160
			-- upvalues: p5 (copy), p6 (copy)
			p5.isFlushScheduled = false
			p5:reportTimers(p6)
		end)
		p5.isFlushScheduled = true
	end
end
function t1.reportTimers(p7, p8) -- line: 168
	if p7.enabled then
		p8.dependencies.logger.reportTimers(p7.closedTimers, p8.appPage)
		p7.closedTimers = {}
	end
end

return t1
