local SduiPageAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiPageAnalytics")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiIntegrationTypes")

local fFlagLuaAppSduiStreamingFirstDataTiming = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagLuaAppSduiStreamingFirstDataTiming

local v5 = {
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
	createLoadTimer = function(p2, callback)
		local now = nil
		local now2 = nil

		local nows = {}
		local v6 = nil
		local v7 = "NotStarted"
		local v8 = nil
		local v9 = nil

		local function calculateDuration(p3, p4)
			local v10 = nows[p3]
			local v11 = nows[p4]

			if v10 and v11 then
				return (v11 - v10) * 1000
			end

			return nil
		end

		local function finish()
			if v7 ~= "Running" or now == nil then
				return
			end

			v7 = "Finished"
			now2 = os.clock()

			local v10 = (now2 - now) * 1000
			local v11

			if fFlagLuaAppSduiStreamingFirstDataTiming then
				local uiRequestQueued = nows.UiRequestQueued
				local uiStreamChunkReceived = nows.UiStreamChunkReceived
				local v12

				if uiRequestQueued and uiStreamChunkReceived then
					v12 = (uiStreamChunkReceived - uiRequestQueued) * 1000
				end

				local uiRequestQueued2 = nows.UiRequestQueued
				local uiResponseReceived = nows.UiResponseReceived
				local v13

				if uiRequestQueued2 and uiResponseReceived then
					v13 = (uiResponseReceived - uiRequestQueued2) * 1000
				end

				v11 = if v12 and v13 then math.min(v12, v13) else v12 or v13
			else
				local uiRequestQueued = nows.UiRequestQueued
				local uiResponseReceived = nows.UiResponseReceived

				if uiRequestQueued and uiResponseReceived then
					v11 = (uiResponseReceived - uiRequestQueued) * 1000
				end
			end

			local responseDecodeBegin = nows.ResponseDecodeBegin
			local responseDecodeEnd = nows.ResponseDecodeEnd
			local v12

			if responseDecodeBegin and responseDecodeEnd then
				v12 = (responseDecodeEnd - responseDecodeBegin) * 1000
			end

			local responseDataUpdateBegin = nows.ResponseDataUpdateBegin
			local responseDataUpdateEnd = nows.ResponseDataUpdateEnd
			local v13

			if responseDataUpdateBegin and responseDataUpdateEnd then
				v13 = (responseDataUpdateEnd - responseDataUpdateBegin) * 1000
			end

			local sduiTreeBuildBegin = nows.SduiTreeBuildBegin
			local sduiTreeBuildEnd = nows.SduiTreeBuildEnd

			local v14 = if sduiTreeBuildBegin and sduiTreeBuildEnd then (sduiTreeBuildEnd - sduiTreeBuildBegin) * 1000 else nil

			local v15 = {
				totalDurationMs = v10,
				uiRequestDurationMs = v11,
				responseDecodeDurationMs = v12,
				sduiTreeBuildDurationMs = v14,
				dataUpdateDurationMs = v13,
				netRoundTripTimeMs = v6 and v6.RoundTripTime and v6.RoundTripTime * 1000,
				netDurationReceiveResponseMs = v6 and v6.DurationReceiveResponse and v6.DurationReceiveResponse * 1000,
				requestStatus = v8,
				pageKey = p2,
				startSource = v9 or "unknown"
			}
			local sduiClientHintsBegin = nows.SduiClientHintsBegin
			local sduiClientHintsEnd = nows.SduiClientHintsEnd

			local v16 = if sduiClientHintsBegin and sduiClientHintsEnd then (sduiClientHintsEnd - sduiClientHintsBegin) * 1000 else nil

			v15.clientHintsDurationMs = v16

			if callback then
				callback(v15)
			else
				SduiPageAnalytics.sendLoadTimerEvent(v15)
			end
		end

		local function logTimestamp(p3)
			nows[p3] = os.clock()
		end

		return {
			start = function(p3)
				now = os.clock()
				v7 = "Running"
				v9 = p3
			end,
			logUiRequestQueued = function()
				if v7 == "NotStarted" then
					now = os.clock()
					v7 = "Running"
					v9 = "UiRequestQueued"
				end

				nows.UiRequestQueued = os.clock()
			end,
			logUiRequestSent = function()
				if v7 == "NotStarted" then
					now = os.clock()
					v7 = "Running"
					v9 = "UiRequestSent"
				end

				nows.UiRequestSent = os.clock()
			end,
			logUiResponseReceived = function()
				nows.UiResponseReceived = os.clock()
			end,
			logUiStreamChunkReceived = function()
				if fFlagLuaAppSduiStreamingFirstDataTiming and nows.UiStreamChunkReceived ~= nil then
					return
				end

				nows.UiStreamChunkReceived = os.clock()
			end,
			logResponseDecodeBegin = function()
				nows.ResponseDecodeBegin = os.clock()
			end,
			logResponseDecodeEnd = function()
				nows.ResponseDecodeEnd = os.clock()
			end,
			logResponseDataUpdateBegin = function()
				nows.ResponseDataUpdateBegin = os.clock()
			end,
			logResponseDataUpdateEnd = function()
				nows.ResponseDataUpdateEnd = os.clock()
			end,
			logSduiTreeBuildBegin = function()
				nows.SduiTreeBuildBegin = os.clock()
			end,
			logSduiTreeBuildEnd = function()
				nows.SduiTreeBuildEnd = os.clock()
			end,
			logSduiClientHintsBegin = function()
				nows.SduiClientHintsBegin = os.clock()
			end,
			logSduiClientHintsEnd = function()
				nows.SduiClientHintsEnd = os.clock()
			end,
			logComponentMounted = function()
				nows.SduiComponentMounted = os.clock()
			end,
			logComponentReady = function()
				nows.SduiComponentReady = os.clock()

				if v7 == "Running" then
					finish()
				end
			end,
			logRefreshComplete = function()
				nows.RefreshComplete = os.clock()

				if v7 == "Running" then
					finish()
				end
			end,
			logNetRequestStats = function(p3)
				v6 = p3
			end,
			updateRequestStatus = function(p3)
				v8 = p3
			end,
			finish = finish
		}
	end
}
