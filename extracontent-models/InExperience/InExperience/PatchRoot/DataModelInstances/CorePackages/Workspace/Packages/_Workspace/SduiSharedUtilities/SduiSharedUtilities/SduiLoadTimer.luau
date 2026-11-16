local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local parent = SduiSharedUtilities.Parent

local SduiPageAnalytics = require(SduiSharedUtilities.SduiPageAnalytics)
require(SduiSharedUtilities.SduiIntegrationTypes)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppSduiStreamingFirstDataTiming = SharedFlags.FFlagLuaAppSduiStreamingFirstDataTiming

local _ = {
	UiRequestSent = "UiRequestSent",
	UiRequestQueued = "UiRequestQueued",
	UiResponseReceived = "UiResponseReceived",
	UiStreamChunkReceived = "UiStreamChunkReceived",
	ResponseDecodeBegin = "ResponseDecodeBegin",
	ResponseDecodeEnd = "ResponseDecodeEnd",
	ResponseDataUpdateBegin = "ResponseDataUpdateBegin",
	ResponseDataUpdateEnd = "ResponseDataUpdateEnd",
	SduiTreeBuildBegin = "SduiTreeBuildBegin",
	SduiTreeBuildEnd = "SduiTreeBuildEnd",
	SduiClientHintsBegin = "SduiClientHintsBegin",
	SduiClientHintsEnd = "SduiClientHintsEnd",
	SduiComponentMounted = "SduiComponentMounted",
	SduiComponentReady = "SduiComponentReady",
	RefreshComplete = "RefreshComplete"
}

return {
	createLoadTimer = function(pageKey: string, callback)
		local now = nil
		local now2 = nil

		local nows = {}
		local v = nil
		local v2 = "NotStarted"
		local requestStatus = nil
		local v3 = nil

		local function calculateDuration(p: string, p2: string) -- 7 equivalent calls inferred from this helper
			local v4 = nows[p]
			local v5 = nows[p2]

			if v4 and v5 then
				return (v5 - v4) * 1000
			end

			return nil
		end

		local function start(p: string) -- 2 equivalent calls inferred from this helper
			now = os.clock()
			v2 = "Running"
			v3 = p
		end

		local function finish()
			if v2 ~= "Running" or now == nil then
				return
			end

			v2 = "Finished"
			now2 = os.clock()

			local totalDurationMs = (now2 - now) * 1000
			local uiRequestDurationMs

			if FFlagLuaAppSduiStreamingFirstDataTiming then
				local duration = calculateDuration("UiRequestQueued", "UiStreamChunkReceived") -- inferred equivalent call
				local duration2 = calculateDuration("UiRequestQueued", "UiResponseReceived") -- inferred equivalent call

				if duration and duration2 then
					uiRequestDurationMs = math.min(duration, duration2)
				else
					uiRequestDurationMs = duration or duration2
				end
			else
				uiRequestDurationMs = calculateDuration("UiRequestQueued", "UiResponseReceived") -- inferred equivalent call
			end

			local responseDecodeDurationMs = calculateDuration("ResponseDecodeBegin", "ResponseDecodeEnd") -- inferred equivalent call
			local dataUpdateDurationMs = calculateDuration("ResponseDataUpdateBegin", "ResponseDataUpdateEnd") -- inferred equivalent call
			local sduiTreeBuildDurationMs = calculateDuration("SduiTreeBuildBegin", "SduiTreeBuildEnd") -- inferred equivalent call
			local v4 = {
				totalDurationMs = totalDurationMs,
				uiRequestDurationMs = uiRequestDurationMs,
				responseDecodeDurationMs = responseDecodeDurationMs,
				sduiTreeBuildDurationMs = sduiTreeBuildDurationMs,
				dataUpdateDurationMs = dataUpdateDurationMs,
				netRoundTripTimeMs = v and v.RoundTripTime and v.RoundTripTime * 1000,
				netDurationReceiveResponseMs = v and v.DurationReceiveResponse and v.DurationReceiveResponse * 1000,
				requestStatus = requestStatus,
				pageKey = pageKey,
				startSource = v3 or "unknown"
			}
			v4.clientHintsDurationMs = calculateDuration("SduiClientHintsBegin", "SduiClientHintsEnd") -- inferred equivalent call

			if callback then
				callback(v4)
			else
				SduiPageAnalytics.sendLoadTimerEvent(v4)
			end
		end

		local function logTimestamp(p: string) -- 15 equivalent calls inferred from this helper
			nows[p] = os.clock()
		end

		return {
			start = start,
			logUiRequestQueued = function()
				if v2 == "NotStarted" then
					start("UiRequestQueued") -- inferred equivalent call
				end

				logTimestamp("UiRequestQueued") -- inferred equivalent call
			end,
			logUiRequestSent = function()
				if v2 == "NotStarted" then
					start("UiRequestSent") -- inferred equivalent call
				end

				logTimestamp("UiRequestSent") -- inferred equivalent call
			end,
			logUiResponseReceived = function()
				logTimestamp("UiResponseReceived") -- inferred equivalent call
			end,
			logUiStreamChunkReceived = function()
				if FFlagLuaAppSduiStreamingFirstDataTiming and nows.UiStreamChunkReceived ~= nil then
					return
				end

				logTimestamp("UiStreamChunkReceived") -- inferred equivalent call
			end,
			logResponseDecodeBegin = function()
				logTimestamp("ResponseDecodeBegin") -- inferred equivalent call
			end,
			logResponseDecodeEnd = function()
				logTimestamp("ResponseDecodeEnd") -- inferred equivalent call
			end,
			logResponseDataUpdateBegin = function()
				logTimestamp("ResponseDataUpdateBegin") -- inferred equivalent call
			end,
			logResponseDataUpdateEnd = function()
				logTimestamp("ResponseDataUpdateEnd") -- inferred equivalent call
			end,
			logSduiTreeBuildBegin = function()
				logTimestamp("SduiTreeBuildBegin") -- inferred equivalent call
			end,
			logSduiTreeBuildEnd = function()
				logTimestamp("SduiTreeBuildEnd") -- inferred equivalent call
			end,
			logSduiClientHintsBegin = function()
				logTimestamp("SduiClientHintsBegin") -- inferred equivalent call
			end,
			logSduiClientHintsEnd = function()
				logTimestamp("SduiClientHintsEnd") -- inferred equivalent call
			end,
			logComponentMounted = function()
				logTimestamp("SduiComponentMounted") -- inferred equivalent call
			end,
			logComponentReady = function()
				logTimestamp("SduiComponentReady") -- inferred equivalent call

				if v2 == "Running" then
					finish()
				end
			end,
			logRefreshComplete = function()
				logTimestamp("RefreshComplete") -- inferred equivalent call

				if v2 == "Running" then
					finish()
				end
			end,
			logNetRequestStats = function(p)
				v = p
			end,
			updateRequestStatus = function(p)
				requestStatus = p
			end,
			finish = finish
		}
	end
}
