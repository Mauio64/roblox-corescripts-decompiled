local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local SduiSharedUtilitiesParent = SduiSharedUtilities.Parent
local SduiPageAnalytics = require(SduiSharedUtilities.SduiPageAnalytics)

require(SduiSharedUtilities.SduiIntegrationTypes)

local FFlagSduiGameIconSupport = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiGameIconSupport
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
	createLoadTimer = function(s1: string, p1: ((...any) -> ...any)?) -- line: 85
		-- upvalues: FFlagSduiGameIconSupport (copy), SduiPageAnalytics (copy)
		local elapsed = nil
		local elapsed2 = nil
		local t1 = {}
		local u11 = nil
		local s2 = "NotStarted"
		local u13 = nil
		local u14 = nil

		local function calculateDuration(s3: string, s4: string) -- line: 99
			-- upvalues: t1 (copy)
			local v20 = t1[s3]
			local v21 = t1[s4]

			if v20 and v21 then
				return (v21 - v20) * 1000
			end

			return nil
		end
		local function finish() -- line: 116
			-- upvalues: s2 (ref), elapsed (ref), elapsed2 (ref), t1 (copy), u11 (ref), u13 (ref), s1 (copy), u14 (ref), FFlagSduiGameIconSupport (copy), p1 (copy), SduiPageAnalytics (copy)
			if s2 ~= "Running" or elapsed == nil then
				return
			end

			s2 = "Finished"
			elapsed2 = os.clock()

			local v23 = (elapsed2 - elapsed) * 1000
			local UiRequestQueued = t1.UiRequestQueued
			local UiResponseReceived = t1.UiResponseReceived
			local v26 = if not UiRequestQueued or not UiResponseReceived then nil else (UiResponseReceived - UiRequestQueued) * 1000
			local ResponseDecodeBegin = t1.ResponseDecodeBegin
			local ResponseDecodeEnd = t1.ResponseDecodeEnd
			local v29 = if not ResponseDecodeBegin or not ResponseDecodeEnd then nil else (ResponseDecodeEnd - ResponseDecodeBegin) * 1000
			local ResponseDataUpdateBegin = t1.ResponseDataUpdateBegin
			local ResponseDataUpdateEnd = t1.ResponseDataUpdateEnd
			local v32 = if not ResponseDataUpdateBegin or not ResponseDataUpdateEnd then nil else (ResponseDataUpdateEnd - ResponseDataUpdateBegin) * 1000
			local SduiTreeBuildBegin = t1.SduiTreeBuildBegin
			local SduiTreeBuildEnd = t1.SduiTreeBuildEnd
			local v35 = if not SduiTreeBuildBegin or not SduiTreeBuildEnd then nil else (SduiTreeBuildEnd - SduiTreeBuildBegin) * 1000
			local v36 = u11 and (u11.RoundTripTime and u11.RoundTripTime * 1000)
			local v37 = u11 and (u11.DurationReceiveResponse and u11.DurationReceiveResponse * 1000)
			local t2 = {
				totalDurationMs = v23,
				uiRequestDurationMs = v26,
				responseDecodeDurationMs = v29,
				sduiTreeBuildDurationMs = v35,
				dataUpdateDurationMs = v32,
				netRoundTripTimeMs = v36,
				netDurationReceiveResponseMs = v37,
				requestStatus = u13,
				pageKey = s1,
				startSource = u14 or "unknown"
			}

			if FFlagSduiGameIconSupport then
				local SduiClientHintsBegin = t1.SduiClientHintsBegin
				local SduiClientHintsEnd = t1.SduiClientHintsEnd

				t2.clientHintsDurationMs = if not SduiClientHintsBegin or not SduiClientHintsEnd then nil else (SduiClientHintsEnd - SduiClientHintsBegin) * 1000
			end

			if p1 then
				p1(t2)

				return
			end

			SduiPageAnalytics.sendLoadTimerEvent(t2)
		end
		local function logTimestamp(s5: string) -- line: 164
			-- upvalues: t1 (copy)
			t1[s5] = os.clock()
		end

		return {
			start = function(s6: string) -- line: 109
				-- upvalues: elapsed (ref), s2 (ref), u14 (ref)
				elapsed = os.clock()
				s2 = "Running"
				u14 = s6
			end,
			logUiRequestQueued = function() -- line: 174
				-- upvalues: s2 (ref), elapsed (ref), u14 (ref), t1 (copy)
				if s2 == "NotStarted" then
					elapsed = os.clock()
					s2 = "Running"
					u14 = "UiRequestQueued"
				end

				t1.UiRequestQueued = os.clock()
			end,
			logUiRequestSent = function() -- line: 182
				-- upvalues: s2 (ref), elapsed (ref), u14 (ref), t1 (copy)
				if s2 == "NotStarted" then
					elapsed = os.clock()
					s2 = "Running"
					u14 = "UiRequestSent"
				end

				t1.UiRequestSent = os.clock()
			end,
			logUiResponseReceived = function() -- line: 190
				-- upvalues: t1 (copy)
				t1.UiResponseReceived = os.clock()
			end,
			logUiStreamChunkReceived = function() -- line: 194
				-- upvalues: t1 (copy)
				t1.UiStreamChunkReceived = os.clock()
			end,
			logResponseDecodeBegin = function() -- line: 199
				-- upvalues: t1 (copy)
				t1.ResponseDecodeBegin = os.clock()
			end,
			logResponseDecodeEnd = function() -- line: 204
				-- upvalues: t1 (copy)
				t1.ResponseDecodeEnd = os.clock()
			end,
			logResponseDataUpdateBegin = function() -- line: 209
				-- upvalues: t1 (copy)
				t1.ResponseDataUpdateBegin = os.clock()
			end,
			logResponseDataUpdateEnd = function() -- line: 214
				-- upvalues: t1 (copy)
				t1.ResponseDataUpdateEnd = os.clock()
			end,
			logSduiTreeBuildBegin = function() -- line: 219
				-- upvalues: t1 (copy)
				t1.SduiTreeBuildBegin = os.clock()
			end,
			logSduiTreeBuildEnd = function() -- line: 224
				-- upvalues: t1 (copy)
				t1.SduiTreeBuildEnd = os.clock()
			end,
			logSduiClientHintsBegin = function() -- line: 229
				-- upvalues: t1 (copy)
				t1.SduiClientHintsBegin = os.clock()
			end,
			logSduiClientHintsEnd = function() -- line: 234
				-- upvalues: t1 (copy)
				t1.SduiClientHintsEnd = os.clock()
			end,
			logComponentMounted = function() -- line: 239
				-- upvalues: t1 (copy)
				t1.SduiComponentMounted = os.clock()
			end,
			logComponentReady = function() -- line: 245
				-- upvalues: t1 (copy), s2 (ref), finish (copy)
				t1.SduiComponentReady = os.clock()

				if s2 == "Running" then
					finish()
				end
			end,
			logRefreshComplete = function() -- line: 254
				-- upvalues: t1 (copy), s2 (ref), finish (copy)
				t1.RefreshComplete = os.clock()

				if s2 == "Running" then
					finish()
				end
			end,
			logNetRequestStats = function(t3: {[any]: any}) -- line: 169
				-- upvalues: u11 (ref)
				u11 = t3
			end,
			updateRequestStatus = function(p2) -- line: 262
				-- upvalues: u13 (ref)
				u13 = p2
			end,
			finish = finish
		}
	end
}
