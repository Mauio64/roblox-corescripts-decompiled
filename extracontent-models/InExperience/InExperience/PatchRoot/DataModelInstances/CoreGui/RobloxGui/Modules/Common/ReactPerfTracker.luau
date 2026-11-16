local defineFastInt = game:DefineFastInt("ReactPerfTrackerKibana", 0)

function applicationId()
	local AppStorageService = game:GetService("AppStorageService")

	if not AppStorageService then
		return nil
	end

	local item = AppStorageService:GetItem("AppInstallationId")
	local typeName = typeof(item)

	if typeName == "number" then
		return tonumber(item) or nil
	end

	if typeName ~= "string" or string.len(item) <= 0 then
		return nil
	end

	return (tonumber((string.sub(item, -string.len((tostring(1000)))))))
end

if not (defineFastInt > 0) then
	return nil
end

local v = math.random(0, 1000)
local v2 = applicationId()

if v2 ~= nil then
	v = (v2 + 327) % 1000
end

if not ((not (v < defineFastInt) and 0 or defineFastInt) > 0) then
	return nil
end

local CorePackages = game:GetService("CorePackages")
local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local v3 = {
	eventName = "ReactCoreScriptPerformance",
	backends = { LoggingProtocol.TelemetryBackends.Points },
	throttlingPercentage = 10000,
	lastUpdated = { 24, 10, 4 },
	description = "Reporting the time utilization of React in CoreScripts",
	links = ""
}

local ReactPerfTracker = {}
ReactPerfTracker.__index = ReactPerfTracker

function ReactPerfTracker.new()
	return (setmetatable({
		totalTime = 0,
		componentTotalTime = {},
		componentMaxTime = {},
		componentCount = {},
		sampleCount = 0,
		["loggingProtocol"] = LoggingProtocol.default,
		outgoingEvents = {},
		nextSendTime = 0,
		previousSendTime = 0
	}, ReactPerfTracker))
end

function ReactPerfTracker:start()
	self.eventSender = coroutine.create(function()
		while true do
			local v4 = table.remove(self.outgoingEvents, 1)

			if v4 then
				wait()
				self.loggingProtocol:logRobloxTelemetryEvent(v3, {}, v4)
			else
				coroutine.yield()
			end
		end
	end)

	ReactRoblox.robloxReactProfiling.startTimerSampling(function(data)
		local id = data.id
		local v4 = (data.endTime - data.startTime) * 1000

		if not self.componentTotalTime[id] then
			self.componentTotalTime[id] = 0
			self.componentMaxTime[id] = 0
			self.componentCount[id] = 0
		end

		self.componentTotalTime[id] += v4
		self.componentCount[id] += 1
		self.sampleCount += 1
		self.totalTime += v4
		self.componentMaxTime[id] = math.max(self.componentMaxTime[id], v4)

		if data.startTime >= self.nextSendTime then
			if self.nextSendTime > 0 then
				self:sendEvents()
			end

			self.previousSendTime = self.nextSendTime

			if self.previousSendTime == 0 then
				self.previousSendTime = data.startTime
			end

			self.nextSendTime = data.startTime + 30
		end
	end)
end

function ReactPerfTracker:genEvents()
	local count = 0

	for k, _ in self.componentCount do
		count += 1
		table.insert(self.outgoingEvents, {
			sessionid = not RbxAnalyticsService and "" or RbxAnalyticsService:GetSessionId(),
			component = k,
			time_ms_max = self.componentMaxTime[k],
			time_ms_avg = self.componentTotalTime[k] / self.componentCount[k],
			total_time_ms = self.componentTotalTime[k],
			total_time_pct = self.componentTotalTime[k] / self.totalTime,
			count = self.componentCount[k],
			count_pct = self.componentCount[k] / self.sampleCount
		})
	end

	table.insert(self.outgoingEvents, 1, {
		summary_sessionid = not RbxAnalyticsService and "" or RbxAnalyticsService:GetSessionId(),
		summary_total_time_ms = self.totalTime,
		summary_sample_time_s = self.nextSendTime - self.previousSendTime,
		summary_num_components = count,
		summary_sample_count = self.sampleCount
	})
end

function ReactPerfTracker:sendEvents()
	if self.sampleCount == 0 then
		return
	end

	self:genEvents()
	self:resetCounts()

	coroutine.resume(self.eventSender)
end

function ReactPerfTracker:resetCounts()
	self.componentTotalTime = {}
	self.componentMaxTime = {}
	self.componentCount = {}
	self.sampleCount = 0
	self.totalTime = 0
end

return ReactPerfTracker
