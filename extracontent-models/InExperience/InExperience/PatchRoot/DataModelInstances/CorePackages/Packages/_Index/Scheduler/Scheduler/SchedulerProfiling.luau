local ParentParent = script.Parent.Parent
local console = require(ParentParent.Shared).console
local t1 = {}

require(script.Parent.SchedulerPriorities)

local enableProfiling = require(script.Parent.SchedulerFeatureFlags).enableProfiling
local n1 = 0
local n2 = 0
local n3 = 0
local u8 = nil
local u9 = nil
local n4 = 1

local function logEvent(p1) -- line: 46
	-- upvalues: u9 (ref), n4 (ref), n3 (ref), console (copy), t1 (copy), u8 (ref)
	if u9 ~= nil then
		n4 += #p1

		if n4 + 1 > n3 then
			n3 *= 2

			if n3 > 524288 then
				console.error("Scheduler Profiling: Event log exceeded maximum size. Don't forget to call `stopLoggingProfilingEvents()`.")
				t1.stopLoggingProfilingEvents()

				return
			end

			local t2 = {}

			table.insert(t2, u9)
			u8 = t2
			u9 = t2
		end

		table.insert(u9, p1)
	end
end

function t1.startLoggingProfilingEvents() -- line: 70
	-- upvalues: n3 (ref), u8 (ref), u9 (ref), n4 (ref)
	n3 = 131072
	u8 = {}
	u9 = u8
	n4 = 1
end
function t1.stopLoggingProfilingEvents() -- line: 77
	-- upvalues: u8 (ref), n3 (ref), u9 (ref), n4 (ref)
	local v14 = u8

	n3 = 0
	u8 = nil
	u9 = nil
	n4 = 1

	return v14
end
function t1.markTaskStart(p2, n5: number) -- line: 87
	-- upvalues: enableProfiling (copy), u9 (ref), logEvent (copy)
	if enableProfiling and u9 ~= nil then
		logEvent({
			1,
			n5 * 1000,
			p2.id,
			p2.priorityLevel
		})
	end
end
function t1.markTaskCompleted(p3, n6: number) -- line: 98
	-- upvalues: enableProfiling (copy), u9 (ref), logEvent (copy)
	if enableProfiling and u9 ~= nil then
		logEvent({
			2,
			n6 * 1000,
			p3.id
		})
	end
end
function t1.markTaskCanceled(p4, n7: number) -- line: 109
	-- upvalues: enableProfiling (copy), u9 (ref), logEvent (copy)
	if enableProfiling and u9 ~= nil then
		logEvent({
			4,
			n7 * 1000,
			p4.id
		})
	end
end
function t1.markTaskErrored(p5, n8: number) -- line: 117
	-- upvalues: enableProfiling (copy), u9 (ref), logEvent (copy)
	if enableProfiling and u9 ~= nil then
		logEvent({
			3,
			n8 * 1000,
			p5.id
		})
	end
end
function t1.markTaskRun(p6, n9: number) -- line: 125
	-- upvalues: enableProfiling (copy), n1 (ref), u9 (ref), logEvent (copy)
	if enableProfiling then
		n1 += 1

		if u9 ~= nil then
			logEvent({
				5,
				n9 * 1000,
				p6.id,
				n1
			})
		end
	end
end
function t1.markTaskYield(p7, n10: number) -- line: 135
	-- upvalues: enableProfiling (copy), u9 (ref), logEvent (copy), n1 (ref)
	if enableProfiling and u9 ~= nil then
		logEvent({
			6,
			n10 * 1000,
			p7.id,
			n1
		})
	end
end
function t1.markSchedulerSuspended(n11: number) -- line: 143
	-- upvalues: enableProfiling (copy), n2 (ref), u9 (ref), logEvent (copy)
	if enableProfiling then
		n2 += 1

		if u9 ~= nil then
			logEvent({
				7,
				n11 * 1000,
				n2
			})
		end
	end
end
function t1.markSchedulerUnsuspended(n12: number) -- line: 153
	-- upvalues: enableProfiling (copy), u9 (ref), logEvent (copy), n2 (ref)
	if enableProfiling and u9 ~= nil then
		logEvent({
			8,
			n12 * 1000,
			n2
		})
	end
end

return t1
