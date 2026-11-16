local CorePackages = game:GetService("CorePackages")

local CircularBuffer = require(script.Parent.Parent.Parent.CircularBuffer)
local Signal = require(script.Parent.Parent.Parent.Signal)
local VoiceDebugFieldMeta = require(script.Parent.VoiceDebugFieldMeta)
local VoiceDebugSource = require(script.Parent.VoiceDebugSource)

local VoiceChatService = game:GetService("VoiceChatService")

local fVariable = tonumber(settings():GetFVariable("NewDevConsoleMaxGraphCount")) or 60

local CrossExperienceVoice = require(CorePackages.Workspace.Packages.CrossExperienceVoice)
local default = CrossExperienceVoice.CrossExperienceVoiceManager.default

local InExperience = VoiceDebugSource.InExperience
local Party = VoiceDebugSource.Party

local GetFFlagVoiceDebugConsoleV2 = require(script.Parent.GetFFlagVoiceDebugConsoleV2)

local function parseCodecFromSdp(sdpPublishOffer: string?) -- 2 equivalent calls inferred from this helper
	if not sdpPublishOffer or sdpPublishOffer == "" then
		return nil
	end

	local _, v, v2, v3 = string.match(sdpPublishOffer, "a=rtpmap:(%d+) (%a+)/(%d+)/(%d+)")

	if v and v2 and v3 then
		return string.format("%s/%s/%s", v, v2, v3)
	end

	return nil
end

local function computeBitrateKbps(value: number?, value2: number?, value3: number?) -- 5 equivalent calls inferred from this helper
	if type(value) ~= "number" or type(value2) ~= "number" or type(value3) ~= "number" or value3 <= 0 then
		return nil
	end

	if value < value2 then
		return nil
	end

	return (value - value2) * 8 / value3 / 1000
end

local function computeSubscriptionBitrates(subscriptions, items, value: number?)
	local audioSsrcSet = {}

	for _, item in subscriptions do
		local audioSsrc = item.audioSsrc

		if not (type(audioSsrc) == "number" and audioSsrc == audioSsrc and audioSsrc % 1 == 0) then
			continue
		end

		audioSsrcSet[audioSsrc] = true
		local item2 = items[audioSsrc]
		local v = item2 ~= nil and item2.userId == item.userId

		item.incomingBitrateKbps = computeBitrateKbps(item.incomingBytes, v and item2.bytes or nil, value) -- inferred equivalent call
		items[audioSsrc] = { userId = item.userId, bytes = item.incomingBytes }
	end

	for k in items do
		if not audioSsrcSet[k] then
			items[k] = nil
		end
	end
end

local function computeLossPercent(value: number?, value2: number?) -- 2 equivalent calls inferred from this helper
	if type(value) ~= "number" or type(value2) ~= "number" then
		return nil
	end

	local v = value + value2

	if v <= 0 then
		return nil
	end

	return value2 / v * 100
end

local function deltaSince(value: number?, value2: number?) -- 4 equivalent calls inferred from this helper
	if type(value) == "number" and type(value2) == "number" and not (value < value2) then
		return value - value2
	end

	return nil
end

local function computeJitterBufferDelayMs(jitterBufferDelayMs: number?, value: number?, jitterBufferEmittedCount: number?, value2: number?) -- 2 equivalent calls inferred from this helper
	if
		type(jitterBufferDelayMs) ~= "number"
		or type(value) ~= "number"
		or type(jitterBufferEmittedCount) ~= "number"
		or type(value2) ~= "number"
	then
		return nil
	end

	local v = jitterBufferEmittedCount - value2
	local v2 = jitterBufferDelayMs - value

	if v <= 0 or v2 < 0 then
		return nil
	end

	return v2 * 1000 / v
end

local function nativeSecondsToWallClockSeconds(timestampSeconds: number, p: number, p2: number) -- 1 equivalent call inferred from this helper
	return p2 + (timestampSeconds - p)
end

local function formatWallClockTime(p: number) -- 1 equivalent call inferred from this helper
	return (os.date("%H:%M:%S", p))
end

local function decorateOperationEntries(list, nativeNowSeconds: number, now: number)
	local result = table.create(#list)

	for k, item in list do
		local timestampText

		if item.timestampSeconds then
			timestampText = formatWallClockTime(nativeSecondsToWallClockSeconds( -- inferred equivalent call
				item.timestampSeconds,
				nativeNowSeconds,
				now
			))
		end

		result[k] = {
			name = item.name,
			operationType = item.operationType,
			timestampSeconds = item.timestampSeconds,
			timestampText = timestampText
		}
	end

	return result
end

local function decorateRemoteOperationsPayload(data)
	local now = os.time()
	local nativeNowSeconds = data.nativeNowSeconds or 0
	return {
		sent = decorateOperationEntries(data.sent or {}, nativeNowSeconds, now),
		received = decorateOperationEntries(data.received or {}, nativeNowSeconds, now),
		operations = decorateOperationEntries(data.operations or {}, nativeNowSeconds, now),
		sentCaptureEnabled = data.sentCaptureEnabled == true,
		receivedCaptureEnabled = data.receivedCaptureEnabled == true,
		opQueueCaptureEnabled = data.opQueueCaptureEnabled == true
	}
end

local VoiceDebugData = {}
VoiceDebugData.__index = VoiceDebugData

function VoiceDebugData.new()
	local v = {}
	setmetatable(v, VoiceDebugData)

	v._statsUpdated = Signal.new()
	v._statsData = {}
	v._series = {}
	v._connectivityData = {}
	v._subscriptionsData = {}
	v._remoteOperationsData = {}
	v._prevSubscriptionBytesBySsrc = {}
	v._isRunning = false

	v._source = InExperience
	v._partyStatsData = {}
	v._partySeries = {}
	v._partyConnectivityData = {}
	v._partySubscriptionsData = {}
	v._partyRemoteOperationsData = {}
	v._isPartyActive = false
	v._partyPollTask = nil
	v._partyPollGeneration = 0
	v._prevPartyJitterBufferDelaySeconds = nil
	v._prevPartyJitterBufferEmittedCount = nil
	v._prevPartyIncomingBytes = nil
	v._prevPartyOutgoingBytes = nil

	v._prevPartySubscriptionBytesBySsrc = {}

	v._prevBytesClock = nil
	v._prevIncomingBytes = nil
	v._prevOutgoingBytes = nil
	v._prevIncomingPackets = nil
	v._prevIncomingPacketsLost = nil
	v._prevJitterBufferDelaySeconds = nil
	v._prevJitterBufferEmittedCount = nil

	return v
end

function VoiceDebugData:Signal()
	return self._statsUpdated
end

function VoiceDebugData:getCurrentData()
	if self._source == Party then
		return self._partyStatsData
	end

	return self._statsData
end

function VoiceDebugData:getSeries()
	if self._source == Party then
		return self._partySeries
	end

	return self._series
end

function VoiceDebugData:getSeriesSnapshot()
	local seriesSnapshot = {}

	for k, v in self:getSeries() do
		seriesSnapshot[k] = { max = v.max, min = v.min, dataSet = v.dataSet:clone() }
	end

	return seriesSnapshot
end

function VoiceDebugData:isRunning()
	return self._isRunning
end

function VoiceDebugData:getConnectivity()
	if self._source == Party then
		return self._partyConnectivityData
	end

	return self._connectivityData
end

function VoiceDebugData:getSource()
	return self._source
end

function VoiceDebugData:isPartyVoiceActive()
	return self._isPartyActive
end

function VoiceDebugData:setSource(source: string)
	if self._source == source then
		return
	end

	self._source = source
	self._statsUpdated:Fire(self:getCurrentData())
end

function VoiceDebugData:getSubscriptions()
	if self._source == Party then
		return self._partySubscriptionsData.subscriptions or {}
	end

	return self._subscriptionsData.subscriptions or {}
end

function VoiceDebugData:getRemoteOperations()
	if self._source == Party then
		return self._partyRemoteOperationsData
	end

	return self._remoteOperationsData
end

function VoiceDebugData:_updateSeriesValueInto(p, p2: string, min: number, time: number)
	if p[p2] then
		local v = p[p2]
		local v2 = v.max
		local v3 = v.min

		local push_back = v.dataSet:push_back({ value = min, time = time })

		if push_back and (v2 == push_back.value or v3 == push_back.value) then
			local iterator = v.dataSet:iterator()
			local v4 = iterator:next()
			local v5 = v4 and v4.value
			local v6 = if v4 then v4.value else v4

			while v4 do
				v5 = v4.value < v5 and v5 or v4.value
				v6 = v6 < v4.value and v6 or v4.value
				v4 = iterator:next()
			end

			if v2 == push_back.value then
				v2 = v5
			end

			if v3 == push_back.value then
				v3 = v6
			end
		end

		v.max = v2 < min and min or v2
		min = v3 < min and v3 or min
		v.min = min
	else
		local dataSet = CircularBuffer.new(fVariable)
		dataSet:push_back({ value = min, time = time })

		p[p2] = { max = min, min = min, dataSet = dataSet }
	end
end

function VoiceDebugData:_updateSeriesValue(p: string, p2: number, p3: number)
	self:_updateSeriesValueInto(self._series, p, p2, p3)
end

function VoiceDebugData:start()
	if VoiceChatService and not self._statsListenerConnection then
		self._statsListenerConnection = VoiceChatService.VoiceChatStatsCollected:Connect(function()
			self._statsData = VoiceChatService:lastVoiceChatStats()

			self._connectivityData = VoiceChatService:lastVoiceChatConnectivity()
			self._subscriptionsData = VoiceChatService:lastVoiceChatSubscriptions() or {}
			local v = VoiceChatService:lastVoiceChatRemoteOperations() or {}

			local now = os.time()

			if GetFFlagVoiceDebugConsoleV2() then
				if v.nativeNowSeconds then
					self._remoteOperationsData = decorateRemoteOperationsPayload(v)
				else
					self._remoteOperationsData = {}
				end

				local now2 = os.clock()
				local v2

				if self._prevBytesClock then
					v2 = now2 - self._prevBytesClock or nil
				end

				local statsData = self._statsData
				statsData.incomingBitrateKbps = computeBitrateKbps( -- inferred equivalent call
					self._statsData.incomingBytes,
					self._prevIncomingBytes,
					v2
				)
				local _statsData = self._statsData
				_statsData.outgoingBitrateKbps = computeBitrateKbps( -- inferred equivalent call
					self._statsData.outgoingBytes,
					self._prevOutgoingBytes,
					v2
				)
				self._prevIncomingBytes = self._statsData.incomingBytes
				self._prevOutgoingBytes = self._statsData.outgoingBytes
				self._prevBytesClock = now2

				local statsData2 = self._statsData
				statsData2.outgoingCodec = parseCodecFromSdp(self._connectivityData.sdpPublishOffer) -- inferred equivalent call

				local statsData3 = self._statsData
				statsData3.incomingLossPercent = computeLossPercent( -- inferred equivalent call
					deltaSince(self._statsData.incomingPackets, self._prevIncomingPackets), -- inferred equivalent call
					deltaSince(self._statsData.incomingPacketsLost, self._prevIncomingPacketsLost) -- inferred equivalent call
				)

				self._prevIncomingPackets = self._statsData.incomingPackets
				self._prevIncomingPacketsLost = self._statsData.incomingPacketsLost

				local jitterBufferDelayMs = self._statsData.jitterBufferDelayMs
				local jitterBufferEmittedCount = self._statsData.jitterBufferEmittedCount
				local statsData4 = self._statsData

				statsData4.jitterBufferDelayMs = computeJitterBufferDelayMs( -- inferred equivalent call
					jitterBufferDelayMs,
					self._prevJitterBufferDelaySeconds,
					jitterBufferEmittedCount,
					self._prevJitterBufferEmittedCount
				)

				self._prevJitterBufferDelaySeconds = jitterBufferDelayMs
				self._prevJitterBufferEmittedCount = jitterBufferEmittedCount

				computeSubscriptionBitrates(
					self._subscriptionsData.subscriptions or {},
					self._prevSubscriptionBytesBySsrc,
					v2
				)
			end

			for k, v2 in self._statsData do
				local v3 = VoiceDebugFieldMeta[k]

				if v3 and v3.plottable and type(v2) == "number" then
					self:_updateSeriesValue(k, v2, now)
				end
			end

			if self._source == InExperience then
				self._statsUpdated:Fire(self._statsData)
			end
		end)
		self._isRunning = true

		if GetFFlagVoiceDebugConsoleV2() then
			self:_startPartyPipeline()
		end
	end
end

function VoiceDebugData:_correctPartyJitterBufferDelay()
	local jitterBufferDelayMs = self._partyStatsData.jitterBufferDelayMs
	local jitterBufferEmittedCount = self._partyStatsData.jitterBufferEmittedCount
	local partyStatsData = self._partyStatsData

	partyStatsData.jitterBufferDelayMs = computeJitterBufferDelayMs( -- inferred equivalent call
		jitterBufferDelayMs,
		self._prevPartyJitterBufferDelaySeconds,
		jitterBufferEmittedCount,
		self._prevPartyJitterBufferEmittedCount
	)

	self._prevPartyJitterBufferDelaySeconds = jitterBufferDelayMs
	self._prevPartyJitterBufferEmittedCount = jitterBufferEmittedCount
end

function VoiceDebugData:_correctPartyAggregateStats(value: number?)
	if not GetFFlagVoiceDebugConsoleV2() then
		return
	end

	local partyStatsData = self._partyStatsData
	partyStatsData.incomingBitrateKbps = computeBitrateKbps( -- inferred equivalent call
		self._partyStatsData.incomingBytes,
		self._prevPartyIncomingBytes,
		value
	)
	local _partyStatsData = self._partyStatsData
	_partyStatsData.outgoingBitrateKbps = computeBitrateKbps( -- inferred equivalent call
		self._partyStatsData.outgoingBytes,
		self._prevPartyOutgoingBytes,
		value
	)
	self._prevPartyIncomingBytes = self._partyStatsData.incomingBytes
	self._prevPartyOutgoingBytes = self._partyStatsData.outgoingBytes

	local partyStatsData2 = self._partyStatsData
	partyStatsData2.outgoingCodec = parseCodecFromSdp(self._partyConnectivityData.sdpPublishOffer) -- inferred equivalent call

	local partyStatsData3 = self._partyStatsData
	partyStatsData3.incomingLossPercent = computeLossPercent( -- inferred equivalent call
		deltaSince(self._partyStatsData.incomingPackets, self._prevPartyIncomingPackets), -- inferred equivalent call
		deltaSince(self._partyStatsData.incomingPacketsLost, self._prevPartyIncomingPacketsLost) -- inferred equivalent call
	)

	self._prevPartyIncomingPackets = self._partyStatsData.incomingPackets
	self._prevPartyIncomingPacketsLost = self._partyStatsData.incomingPacketsLost
end

function VoiceDebugData:_startPartyPipeline()
	if self._partyPollTask then
		return
	end

	self._partyPollGeneration += 1
	local partyPollGeneration = self._partyPollGeneration

	self._partyPollTask = task.spawn(function()
		local v = nil

		while self._isRunning and partyPollGeneration == self._partyPollGeneration do
			local v2, v3

			if game:GetEngineFeature("CEVGetBackgroundState") then
				v2, v3 = default:getIsBackgroundDMActive():await()
			else
				v2 = false
				v3 = false
			end

			if not self._isRunning or partyPollGeneration ~= self._partyPollGeneration then
				break
			end

			self._isPartyActive = v2 and v3 == true

			local now = os.clock()

			if self._isPartyActive and (not v or now - v >= 30) then
				local v4, v5 = default:getPartyVoiceDebugStats():await()

				if not self._isRunning or partyPollGeneration ~= self._partyPollGeneration then
					break
				end

				if v4 and v5 then
					local now2 = os.clock()
					local v6

					if v then
						v6 = now2 - v or nil
					end

					self._partyStatsData = v5.stats or {}
					self._partyConnectivityData = v5.connectivity or {}
					self._partySubscriptionsData = v5.subscriptions or {}
					local remoteOperations = v5.remoteOperations or {}
					self._partyRemoteOperationsData = remoteOperations.nativeNowSeconds
						and decorateRemoteOperationsPayload(remoteOperations)
						or {}
					self:_correctPartyJitterBufferDelay()
					self:_correctPartyAggregateStats(v6)
					computeSubscriptionBitrates(
						self._partySubscriptionsData.subscriptions or {},
						self._prevPartySubscriptionBytesBySsrc,
						v6
					)

					local now3 = os.time()
					v = now2

					for k, v7 in self._partyStatsData do
						local v8 = VoiceDebugFieldMeta[k]

						if v8 and v8.plottable and type(v7) == "number" then
							self:_updateSeriesValueInto(self._partySeries, k, v7, now3)
						end
					end

					if self._source == Party then
						self._statsUpdated:Fire(self._partyStatsData)
					end
				end
			end

			task.wait(1)
		end
	end)
end

function VoiceDebugData:stop()
	self._isRunning = false

	if self._statsListenerConnection then
		self._statsListenerConnection:Disconnect()
		self._statsListenerConnection = nil
	end

	self._partyPollTask = nil
	self._partyPollGeneration += 1

	self._prevBytesClock = nil
	self._prevIncomingBytes = nil
	self._prevOutgoingBytes = nil
	self._prevIncomingPackets = nil
	self._prevIncomingPacketsLost = nil
	self._prevJitterBufferDelaySeconds = nil
	self._prevJitterBufferEmittedCount = nil
	self._prevSubscriptionBytesBySsrc = {}

	self._prevPartyIncomingBytes = nil
	self._prevPartyOutgoingBytes = nil
	self._prevPartyIncomingPackets = nil
	self._prevPartyIncomingPacketsLost = nil
	self._prevPartyJitterBufferDelaySeconds = nil
	self._prevPartyJitterBufferEmittedCount = nil
	self._prevPartySubscriptionBytesBySsrc = {}
end

VoiceDebugData._parseCodecFromSdp = parseCodecFromSdp
VoiceDebugData._computeBitrateKbps = computeBitrateKbps
VoiceDebugData._computeLossPercent = computeLossPercent
VoiceDebugData._deltaSince = deltaSince
VoiceDebugData._computeJitterBufferDelayMs = computeJitterBufferDelayMs
VoiceDebugData._computeSubscriptionBitrates = computeSubscriptionBitrates
VoiceDebugData._nativeSecondsToWallClockSeconds = nativeSecondsToWallClockSeconds
VoiceDebugData._formatWallClockTime = formatWallClockTime
VoiceDebugData._decorateOperationEntries = decorateOperationEntries
VoiceDebugData._decorateRemoteOperationsPayload = decorateRemoteOperationsPayload

return VoiceDebugData
