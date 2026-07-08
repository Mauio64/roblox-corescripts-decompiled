local CoreScriptsProfiler = require(script.Parent.CoreScriptsProfiler)
local ProfilerDataParser = require(script.Parent.ProfilerDataParser)
local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("CoreScriptsProfiler").Parent
local DeviceTier = require(Parent.Devices).DeviceTier

game:DefineFastInt("CoreScriptsProfilerSamplingHundredthsPercentv1", 0)

local v6 = game:DefineFastInt("CoreScriptsProfilerDelaySeconds", 5)
local v7 = game:DefineFastInt("CoreScriptsProfilerDurationSeconds", 10)
local v8 = game:DefineFastInt("CoreScriptsProfilerTelemetryLimit", 20)

if not (math.random(0, 10000) <= game:GetFastInt("CoreScriptsProfilerSamplingHundredthsPercentv1")) then
	return nil
end

local t1 = {
	eventName = "CorescriptPackageStats",
	description = "Task stats for each corescript package, all in milliseconds",
	links = "https://roblox.atlassian.net/wiki/spaces/APEX/pages/4084400405/Lua+time+break-down+CoreScriptsProfiler",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = {
		2025,
		11,
		25
	}
}
local t2 = {}

t2.__index = t2

function t2.new(s1: string?) -- line: 50
	-- upvalues: t2 (copy)
	return (setmetatable({
		profiler = nil,
		profilingActive = false,
		context = s1
	}, t2))
end
function t2.start(p1) -- line: 61
	-- upvalues: CoreScriptsProfiler (copy), v6 (copy)
	p1.profiler = CoreScriptsProfiler.new(function(_: boolean, s2: string) -- line: 63
		-- upvalues: p1 (copy)
		p1:reportResults(s2)
		p1:cleanup()
	end)
	task.delay(v6, function() -- line: 69
		-- upvalues: p1 (copy)
		p1:startProfilingSession()
	end)
end
function t2.startProfilingSession(p2) -- line: 74
	-- upvalues: v7 (copy)
	if p2.profilingActive then
		return
	end

	if not p2.profiler then
		return
	end

	p2.profilingActive = true
	p2.profiler:ClientStart()
	task.delay(v7, function() -- line: 86
		-- upvalues: p2 (copy)
		p2:stopProfilingSession()
	end)
end
function t2.stopProfilingSession(p3) -- line: 92
	if not p3.profilingActive then
		return
	end

	if not p3.profiler then
		return
	end

	p3.profiler:ClientStop()
	p3.profilingActive = false
end

local function sortPackageStatsByDuration(t3: {[any]: any}) -- line: 107
	local t4 = {}

	for v19, v20 in t3 do
		table.insert(t4, {
			packageName = v19,
			count = v20.count,
			totalDuration = v20.totalDuration
		})
	end

	table.sort(t4, function(p4, p5) -- line: 120
		return p4.totalDuration > p5.totalDuration
	end)

	return t4
end

function t2.reportResults(t5: {[any]: any}, s3: string) -- line: 128
	-- upvalues: ProfilerDataParser (copy), sortPackageStatsByDuration (copy), v8 (copy), DeviceTier (copy), TelemetryService (copy), t1 (copy)
	local v23 = ProfilerDataParser.new(s3):getPackageStatistics()
	local v24 = sortPackageStatsByDuration(v23)
	local v25 = math.min(#v24, v8)
	local v26 = DeviceTier.GetDeviceMemoryTier()

	for i = 1, v25 do
		local v28 = v24[i]
		local t6 = {
			packageName = v28.packageName,
			context = t5.context,
			deviceTier = v26
		}

		TelemetryService:LogStat(t1, {
			customFields = t6
		}, v28.totalDuration * 1000)
	end
end
function t2.cleanup(p6) -- line: 157
	if p6.profiler then
		p6.profiler:Disconnect()
		p6.profiler = nil
		p6.profilingActive = false
	end
end

local u12 = nil

return function(s4: string?) -- line: 167
	-- upvalues: u12 (ref), t2 (copy)
	if not u12 then
		u12 = t2.new(s4)
	end

	return u12
end
