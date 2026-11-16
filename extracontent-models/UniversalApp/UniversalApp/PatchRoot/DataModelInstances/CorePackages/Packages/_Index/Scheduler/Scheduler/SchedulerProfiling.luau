local parent = script.Parent.Parent

local Shared = require(parent.Shared)
local console = Shared.console
local SchedulerProfiling = {}

require(script.Parent.SchedulerPriorities)

local SchedulerFeatureFlags = require(script.Parent.SchedulerFeatureFlags)
local enableProfiling = SchedulerFeatureFlags.enableProfiling

local count = 0
local count2 = 0

local v = 0
local v2 = nil
local lists = nil
local total = 1

local function logEvent(list)
	if lists ~= nil then
		total += #list
		local v3 = total + 1

		if v < v3 then
			v *= 2

			if v > 524288 then
				console.error("Scheduler Profiling: Event log exceeded maximum size. Don't forget to call `stopLoggingProfilingEvents()`.")

				SchedulerProfiling.stopLoggingProfilingEvents()
				return
			else
				local v4 = {}
				table.insert(v4, lists)
				v2 = v4
				lists = v4
			end
		end

		table.insert(lists, list)
	end
end

function SchedulerProfiling.startLoggingProfilingEvents()
	v = 131072
	v2 = {}
	lists = v2
	total = 1
end

function SchedulerProfiling.stopLoggingProfilingEvents()
	local v3 = v2
	v = 0

	v2 = nil
	lists = nil
	total = 1
	return v3
end

function SchedulerProfiling.markTaskStart(p, p2: number)
	if enableProfiling and lists ~= nil then
		logEvent({
			1,
			p2 * 1000,
			p.id,
			p.priorityLevel
		})
	end
end

function SchedulerProfiling.markTaskCompleted(p, p2: number)
	if enableProfiling and lists ~= nil then
		logEvent({ 2, p2 * 1000, p.id })
	end
end

function SchedulerProfiling.markTaskCanceled(p, p2: number)
	if enableProfiling and lists ~= nil then
		logEvent({ 4, p2 * 1000, p.id })
	end
end

function SchedulerProfiling.markTaskErrored(p, p2: number)
	if enableProfiling and lists ~= nil then
		logEvent({ 3, p2 * 1000, p.id })
	end
end

function SchedulerProfiling.markTaskRun(p, p2: number)
	if enableProfiling then
		count += 1

		if lists ~= nil then
			logEvent({
				5,
				p2 * 1000,
				p.id,
				count
			})
		end
	end
end

function SchedulerProfiling.markTaskYield(p, p2: number)
	if enableProfiling and lists ~= nil then
		logEvent({
			6,
			p2 * 1000,
			p.id,
			count
		})
	end
end

function SchedulerProfiling.markSchedulerSuspended(p: number)
	if enableProfiling then
		count2 += 1

		if lists ~= nil then
			logEvent({ 7, p * 1000, count2 })
		end
	end
end

function SchedulerProfiling.markSchedulerUnsuspended(p: number)
	if enableProfiling and lists ~= nil then
		logEvent({ 8, p * 1000, count2 })
	end
end

return SchedulerProfiling
