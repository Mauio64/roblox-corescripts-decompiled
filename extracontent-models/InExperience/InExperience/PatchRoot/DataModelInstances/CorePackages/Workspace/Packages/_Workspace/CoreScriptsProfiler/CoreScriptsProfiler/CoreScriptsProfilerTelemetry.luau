local CoreScriptsProfiler = require(script.Parent.CoreScriptsProfiler)
local ProfilerDataParser = require(script.Parent.ProfilerDataParser)
local TelemetryService = game:GetService("TelemetryService")

local parent = script:FindFirstAncestor("CoreScriptsProfiler").Parent
local Devices = require(parent.Devices)
local DeviceTier = Devices.DeviceTier

game:DefineFastInt("CoreScriptsProfilerSamplingHundredthsPercentv1", 0)

local defineFastInt = game:DefineFastInt("CoreScriptsProfilerDelaySeconds", 5)
local defineFastInt2 = game:DefineFastInt("CoreScriptsProfilerDurationSeconds", 10)
local defineFastInt3 = game:DefineFastInt("CoreScriptsProfilerTelemetryLimit", 20)

if not (math.random(0, 10000) <= game:GetFastInt("CoreScriptsProfilerSamplingHundredthsPercentv1")) then
	return nil
end

local v = {
	eventName = "CorescriptPackageStats",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 2025, 11, 25 },
	description = "Task stats for each corescript package, all in milliseconds",
	links = "https://roblox.atlassian.net/wiki/spaces/APEX/pages/4084400405/Lua+time+break-down+CoreScriptsProfiler"
}

local class = {}
class.__index = class

function class.new(context: string?)
	return (setmetatable({ profiler = nil, profilingActive = false, context = context }, class))
end

function class:start()
	self.profiler = CoreScriptsProfiler.new(function(_: boolean, p: string)
		self:reportResults(p)

		self:cleanup()
	end)

	task.delay(defineFastInt, function()
		self:startProfilingSession()
	end)
end

function class:startProfilingSession()
	if self.profilingActive or not self.profiler then
		return
	end

	self.profilingActive = true
	self.profiler:ClientStart()

	task.delay(defineFastInt2, function()
		self:stopProfilingSession()
	end)
end

function class:stopProfilingSession()
	if not (self.profilingActive and self.profiler) then
		return
	end

	self.profiler:ClientStop()
	self.profilingActive = false
end

local function sortPackageStatsByDuration(packageStatistics)
	local result = {}

	for k, item in packageStatistics do
		table.insert(result, {
			packageName = k,
			count = item.count,
			totalDuration = item.totalDuration
		})
	end

	table.sort(result, function(a, b): boolean
		return a.totalDuration > b.totalDuration
	end)

	return result
end

function class:reportResults(p: string)
	local v2 = sortPackageStatsByDuration(ProfilerDataParser.new(p):getPackageStatistics())

	local v3 = math.min(#v2, defineFastInt3)

	local deviceMemoryTier = DeviceTier.GetDeviceMemoryTier()

	for i = 1, v3 do
		local v4 = v2[i]

		local customFields = { packageName = v4.packageName, context = self.context }

		customFields.deviceTier = deviceMemoryTier

		TelemetryService:LogStat(v, { customFields = customFields }, v4.totalDuration * 1000)
	end
end

function class:cleanup()
	if self.profiler then
		self.profiler:Disconnect()
		self.profiler = nil
		self.profilingActive = false
	end
end

local v2 = nil

return function(p: string?)
	if not v2 then
		v2 = class.new(p)
	end

	return v2
end
