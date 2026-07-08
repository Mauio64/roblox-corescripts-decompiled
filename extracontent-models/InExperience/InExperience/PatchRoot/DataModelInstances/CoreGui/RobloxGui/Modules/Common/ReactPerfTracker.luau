local v1 = game:DefineFastInt("ReactPerfTrackerKibana", 0)

function applicationId() -- line: 47
	local AppStorageService = game:GetService("AppStorageService")

	if not AppStorageService then
		return nil
	end

	local Item = AppStorageService:GetItem("AppInstallationId")
	local v12 = typeof(Item)

	if v12 == "number" then
		return tonumber(Item) or nil
	end

	if v12 == "string" then
		if string.len(Item) <= 0 then
			return nil
		end

		return (tonumber((string.sub(Item, -string.len((tostring(1000)))))))
	end

	return nil
end

if not (v1 > 0) then
	return nil
end

local v2 = math.random(0, 1000)
local v3 = applicationId()

if v3 ~= nil then
	v2 = (v3 + 327) % 1000
end

if not (v2 < v1) then
	v1 = 0
end

if not (v1 > 0) then
	return nil
end

local CorePackages = game:GetService("CorePackages")
local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local t1 = {
	eventName = "ReactCoreScriptPerformance",
	throttlingPercentage = 10000,
	description = "Reporting the time utilization of React in CoreScripts",
	links = "",
	backends = { LoggingProtocol.TelemetryBackends.Points },
	lastUpdated = {
		24,
		10,
		4
	}
}
local t2 = {}

t2.__index = t2

function t2.new() -- line: 117
	-- upvalues: LoggingProtocol (copy), t2 (copy)
	return (setmetatable({
		totalTime = 0,
		componentTotalTime = {},
		componentMaxTime = {},
		componentCount = {},
		sampleCount = 0,
		loggingProtocol = LoggingProtocol.default,
		outgoingEvents = {},
		nextSendTime = 0,
		previousSendTime = 0
	}, t2))
end
function t2.start(p1) -- line: 132
	-- upvalues: t1 (copy), ReactRoblox (copy)
	p1.eventSender = coroutine.create(function() -- line: 134
		-- upvalues: p1 (copy), t1 (copy)
		while true do
			local v20 = table.remove(p1.outgoingEvents, 1)

			if v20 then
				wait()
				p1.loggingProtocol:logRobloxTelemetryEvent(t1, {}, v20)
			else
				coroutine.yield()
			end
		end
	end)
	ReactRoblox.robloxReactProfiling.startTimerSampling(function(t3: {[any]: any}) -- line: 147
		-- upvalues: p1 (copy)
		local id = t3.id
		local v23 = (t3.endTime - t3.startTime) * 1000

		if not p1.componentTotalTime[id] then
			p1.componentTotalTime[id] = 0
			p1.componentMaxTime[id] = 0
			p1.componentCount[id] = 0
		end

		local componentTotalTime = p1.componentTotalTime

		componentTotalTime[id] = componentTotalTime[id] + v23

		local componentCount = p1.componentCount

		componentCount[id] = componentCount[id] + 1

		local v26 = p1

		v26.sampleCount = v26.sampleCount + 1

		local v27 = p1

		v27.totalTime = v27.totalTime + v23
		p1.componentMaxTime[id] = math.max(p1.componentMaxTime[id], v23)

		if t3.startTime >= p1.nextSendTime then
			if p1.nextSendTime > 0 then
				p1:sendEvents()
			end

			p1.previousSendTime = p1.nextSendTime

			if p1.previousSendTime == 0 then
				p1.previousSendTime = t3.startTime
			end

			p1.nextSendTime = t3.startTime + 30
		end
	end)
end
function t2.genEvents(p2) -- line: 180
	-- upvalues: RbxAnalyticsService (copy)
	local n1 = 0

	for v16, _ in p2.componentCount do
		n1 += 1
		table.insert(p2.outgoingEvents, {
			sessionid = not RbxAnalyticsService and "" or RbxAnalyticsService:GetSessionId(),
			component = v16,
			time_ms_max = p2.componentMaxTime[v16],
			time_ms_avg = p2.componentTotalTime[v16] / p2.componentCount[v16],
			total_time_ms = p2.componentTotalTime[v16],
			total_time_pct = p2.componentTotalTime[v16] / p2.totalTime,
			count = p2.componentCount[v16],
			count_pct = p2.componentCount[v16] / p2.sampleCount
		})
	end

	table.insert(p2.outgoingEvents, 1, {
		summary_sessionid = not RbxAnalyticsService and "" or RbxAnalyticsService:GetSessionId(),
		summary_total_time_ms = p2.totalTime,
		summary_sample_time_s = p2.nextSendTime - p2.previousSendTime,
		summary_num_components = n1,
		summary_sample_count = p2.sampleCount
	})
end
function t2.sendEvents(p3) -- line: 206
	if p3.sampleCount == 0 then
		return
	end

	p3:genEvents()
	p3:resetCounts()
	coroutine.resume(p3.eventSender)
end
function t2.resetCounts(p4) -- line: 218
	p4.componentTotalTime = {}
	p4.componentMaxTime = {}
	p4.componentCount = {}
	p4.sampleCount = 0
	p4.totalTime = 0
end

return t2
