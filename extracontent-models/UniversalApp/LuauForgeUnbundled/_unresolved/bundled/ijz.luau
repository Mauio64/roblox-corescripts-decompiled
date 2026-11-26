local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TelemetryService = game:GetService("TelemetryService")

local module = require("@luauforge/bundled/ijA")
local module2 = require("@luauforge/bundled/ijB")

local defineFastInt = game:DefineFastInt("PresenceRefetchTelemetryThrottleHundredthsPercent", 10000)

local v5 = {
	eventName = "PresenceRefetchComparison",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 9, 16 },
	description = "Logs cached and refetched online-friend presences plus the count of friends cached on the client"
}

local v6 = {
	eventName = "PresenceRefetchComparisonTotal",
	backends = { "RobloxTelemetryCounter" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 9, 22 },
	description = "Increments by fetched friends count for each presence refetch comparison"
}

local v7 = {
	eventName = "PresenceRefetchComparisonMismatch",
	backends = { "RobloxTelemetryCounter" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 9, 22 },
	description = "Increments labeled presence-type or in-game location mismatches from a presence refetch comparison"
}

local v8 = {
	eventName = "PresenceRefetchComparisonCount",
	backends = { "RobloxTelemetryCounter" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 9, 22 },
	description = "Increments once for each presence refetch comparison"
}

local v9 = {
	eventName = "PresenceRefetchComparisonHasMismatch",
	backends = { "RobloxTelemetryCounter" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 9, 22 },
	description = "Increments once when a presence refetch comparison has at least one mismatch"
}

local function isInGame(p2): boolean
	return p2.userPresenceType == "InGame"
end

local function gameInfoEqual(data, data2): boolean
	return data.universeId == data2.universeId
		and data.placeId == data2.placeId
		and data.gameId == data2.gameId
end

local function countMismatchKinds(items, items2)
	local v10 = {}

	for k, item in items do
		v10[item.userId] = item
	end

	local userIdSet = {}
	local count = 0
	local count2 = 0

	for k, item in items2 do
		userIdSet[item.userId] = true
		local v11 = v10[item.userId]

		if v11 == nil or v11.userPresenceType ~= item.userPresenceType then
			count += 1
		elseif v11.userPresenceType == "InGame" and item.userPresenceType == "InGame" then
			local v12

			if v11.universeId == item.universeId and v11.placeId == item.placeId then
				v12 = v11.gameId == item.gameId
			else
				v12 = false
			end

			if not v12 then
				count2 += 1
			end
		end
	end

	for k, item in items do
		if not userIdSet[item.userId] then
			count += 1
		end
	end

	return count, count2
end

local class = {}
class.__index = class

function class.new(options)
	local v10 = options or {}
	return (setmetatable({
		_expectedComparisonsPerHour = v10.expectedComparisonsPerHour or module,
		_random = v10.random or math.random,
		_delay = v10.delay or task.delay,
		_cancel = v10.cancel or task.cancel,
		_nowMs = v10.nowMs or function()
			return DateTime.now().UnixTimestampMillis
		end,
		_telemetryService = v10.telemetryService or TelemetryService,
		_getUserId = v10.getUserId or function()
			local localPlayer = Players.LocalPlayer

			if localPlayer then
				return localPlayer.UserId
			end

			return nil
		end,
		_refetchRequested = Instance.new("BindableEvent"),
		_pendingTask = nil,
		_started = false
	}, class))
end

function class:_scheduleNext()
	local v10 = -math.log((math.max(self._random(), 1e-12))) * 3600 / self._expectedComparisonsPerHour

	self._pendingTask = self._delay(v10, function()
		if not self._started then
			return
		end

		self._refetchRequested:Fire()
		self:_scheduleNext()
	end)
end

function class:start()
	if self._started or self._expectedComparisonsPerHour <= 0 then
		return
	end

	self._started = true
	self:_scheduleNext()
end

function class:stop()
	self._started = false

	if self._pendingTask then
		self._cancel(self._pendingTask)
		self._pendingTask = nil
	end
end

function class:subscribe(callback)
	return self._refetchRequested.Event:Connect(function()
		callback()
	end)
end

function class:snapshotPresences(items)
	local result = {}

	if items then
		for k, item in items do
			local presence = item.presence or {}
			table.insert(result, {
				userId = tostring(item.id),
				universeId = presence.universeId,
				placeId = presence.placeId,
				gameId = presence.gameId,
				userPresenceType = presence.userPresenceType
			})
		end
	end

	table.sort(result, function(a, b): boolean
		return a.userId < b.userId
	end)

	return result
end

function class:reportComparison(p2, p3, p4)
	pcall(function()
		self._telemetryService:LogEvent(v5, {
			eventContext = "presenceRefetchTelemetry",
			standardizedFields = {
				"addUserId",
				"addSessionInfo",
				"addSessionId",
				"addOSInfo"
			},
			customFields = {
				userId = self._getUserId(),
				comparisonTimestampMs = self._nowMs(),
				fetchedFriendsCount = p4,
				oldOnlinePresences = HttpService:JSONEncode(p2),
				newOnlinePresences = HttpService:JSONEncode(p3)
			}
		})

		if module2 and p4 ~= nil then
			self._telemetryService:LogCounter(v6, {}, p4)
			self._telemetryService:LogCounter(v8, {}, 1)

			local v10, v11 = countMismatchKinds(p2, p3)

			if v10 > 0 then
				self._telemetryService:LogCounter(v7, {
					customFields = { mismatchKind = "presenceTypeMismatch" }
				}, v10)
			end

			if v11 > 0 then
				self._telemetryService:LogCounter(v7, {
					customFields = { mismatchKind = "gameInfoMismatch" }
				}, v11)
			end

			if v10 > 0 or v11 > 0 then
				self._telemetryService:LogCounter(v9, {}, 1)
			end
		end
	end)
end

function class:destroy()
	self:stop()
	self._refetchRequested:Destroy()
end

local v10 = class.new()
return {
	get = function()
		return v10
	end,
	new = class.new,
	countKnownFriendsUnion = function(items, items2)
		if items == nil and items2 == nil then
			return nil
		end

		local set = {}
		local count = 0
		local function addIds(items3)
			if items3 == nil then
				return
			end

			for k in items3 do
				if set[k] then
					continue
				end

				set[k] = true
				count += 1
			end
		end

		if items ~= nil then
			for k in items do
				if set[k] then
					continue
				end

				set[k] = true
				count += 1
			end
		end

		if items2 == nil then
			return count
		end

		for k in items2 do
			if set[k] then
				continue
			end

			set[k] = true
			count += 1
		end

		return count
	end
}
