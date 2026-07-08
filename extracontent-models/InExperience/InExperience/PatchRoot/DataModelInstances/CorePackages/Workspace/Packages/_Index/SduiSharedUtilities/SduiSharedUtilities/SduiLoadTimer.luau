local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local SduiPageAnalytics = require(SduiSharedUtilities.SduiPageAnalytics)

require(SduiSharedUtilities.SduiIntegrationTypes)

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
	SduiComponentMounted = "SduiComponentMounted",
	SduiComponentReady = "SduiComponentReady",
	RefreshComplete = "RefreshComplete"
}

return {
	createLoadTimer = function(s1: string, p1: ((...any) -> ...any)?) -- line: 77
		-- upvalues: SduiPageAnalytics (copy)
		local elapsed = nil
		local elapsed2 = nil
		local t1 = {}
		local u9 = nil
		local s2 = "NotStarted"
		local u11 = nil
		local u12 = nil

		local function calculateDuration(s3: string, s4: string) -- line: 91
			-- upvalues: t1 (copy)
			local v18 = t1[s3]
			local v19 = t1[s4]

			if v18 and v19 then
				return (v19 - v18) * 1000
			end

			return nil
		end
		local function finish() -- line: 108
			-- upvalues: s2 (ref), elapsed (ref), elapsed2 (ref), t1 (copy), u9 (ref), u11 (ref), s1 (copy), u12 (ref), p1 (copy), SduiPageAnalytics (copy)
			if s2 ~= "Running" or elapsed == nil then
				return
			end

			s2 = "Finished"
			elapsed2 = os.clock()

			local v21 = (elapsed2 - elapsed) * 1000
			local UiRequestQueued = t1.UiRequestQueued
			local UiResponseReceived = t1.UiResponseReceived
			local v24 = if not UiRequestQueued or not UiResponseReceived then nil else (UiResponseReceived - UiRequestQueued) * 1000
			local ResponseDecodeBegin = t1.ResponseDecodeBegin
			local ResponseDecodeEnd = t1.ResponseDecodeEnd
			local v27 = if not ResponseDecodeBegin or not ResponseDecodeEnd then nil else (ResponseDecodeEnd - ResponseDecodeBegin) * 1000
			local ResponseDataUpdateBegin = t1.ResponseDataUpdateBegin
			local ResponseDataUpdateEnd = t1.ResponseDataUpdateEnd
			local v30 = if not ResponseDataUpdateBegin or not ResponseDataUpdateEnd then nil else (ResponseDataUpdateEnd - ResponseDataUpdateBegin) * 1000
			local SduiTreeBuildBegin = t1.SduiTreeBuildBegin
			local SduiTreeBuildEnd = t1.SduiTreeBuildEnd
			local v33 = if not SduiTreeBuildBegin or not SduiTreeBuildEnd then nil else (SduiTreeBuildEnd - SduiTreeBuildBegin) * 1000
			local v34 = u9 and (u9.RoundTripTime and u9.RoundTripTime * 1000)
			local v35 = u9 and (u9.DurationReceiveResponse and u9.DurationReceiveResponse * 1000)
			local t2 = {
				totalDurationMs = v21,
				uiRequestDurationMs = v24,
				responseDecodeDurationMs = v27,
				sduiTreeBuildDurationMs = v33,
				dataUpdateDurationMs = v30,
				netRoundTripTimeMs = v34,
				netDurationReceiveResponseMs = v35,
				requestStatus = u11,
				pageKey = s1,
				startSource = u12 or "unknown"
			}

			if p1 then
				p1(t2)

				return
			end

			SduiPageAnalytics.sendLoadTimerEvent(t2)
		end
		local function logTimestamp(s5: string) -- line: 150
			-- upvalues: t1 (copy)
			t1[s5] = os.clock()
		end

		return {
			start = function(s6: string) -- line: 101
				-- upvalues: elapsed (ref), s2 (ref), u12 (ref)
				elapsed = os.clock()
				s2 = "Running"
				u12 = s6
			end,
			logUiRequestQueued = function() -- line: 160
				-- upvalues: s2 (ref), elapsed (ref), u12 (ref), t1 (copy)
				if s2 == "NotStarted" then
					elapsed = os.clock()
					s2 = "Running"
					u12 = "UiRequestQueued"
				end

				t1.UiRequestQueued = os.clock()
			end,
			logUiRequestSent = function() -- line: 168
				-- upvalues: s2 (ref), elapsed (ref), u12 (ref), t1 (copy)
				if s2 == "NotStarted" then
					elapsed = os.clock()
					s2 = "Running"
					u12 = "UiRequestSent"
				end

				t1.UiRequestSent = os.clock()
			end,
			logUiResponseReceived = function() -- line: 176
				-- upvalues: t1 (copy)
				t1.UiResponseReceived = os.clock()
			end,
			logUiStreamChunkReceived = function() -- line: 180
				-- upvalues: t1 (copy)
				t1.UiStreamChunkReceived = os.clock()
			end,
			logResponseDecodeBegin = function() -- line: 185
				-- upvalues: t1 (copy)
				t1.ResponseDecodeBegin = os.clock()
			end,
			logResponseDecodeEnd = function() -- line: 190
				-- upvalues: t1 (copy)
				t1.ResponseDecodeEnd = os.clock()
			end,
			logResponseDataUpdateBegin = function() -- line: 195
				-- upvalues: t1 (copy)
				t1.ResponseDataUpdateBegin = os.clock()
			end,
			logResponseDataUpdateEnd = function() -- line: 200
				-- upvalues: t1 (copy)
				t1.ResponseDataUpdateEnd = os.clock()
			end,
			logSduiTreeBuildBegin = function() -- line: 205
				-- upvalues: t1 (copy)
				t1.SduiTreeBuildBegin = os.clock()
			end,
			logSduiTreeBuildEnd = function() -- line: 210
				-- upvalues: t1 (copy)
				t1.SduiTreeBuildEnd = os.clock()
			end,
			logComponentMounted = function() -- line: 215
				-- upvalues: t1 (copy)
				t1.SduiComponentMounted = os.clock()
			end,
			logComponentReady = function() -- line: 221
				-- upvalues: t1 (copy), s2 (ref), finish (copy)
				t1.SduiComponentReady = os.clock()

				if s2 == "Running" then
					finish()
				end
			end,
			logRefreshComplete = function() -- line: 230
				-- upvalues: t1 (copy), s2 (ref), finish (copy)
				t1.RefreshComplete = os.clock()

				if s2 == "Running" then
					finish()
				end
			end,
			logNetRequestStats = function(t3: {[any]: any}) -- line: 155
				-- upvalues: u9 (ref)
				u9 = t3
			end,
			updateRequestStatus = function(p2) -- line: 238
				-- upvalues: u11 (ref)
				u11 = p2
			end,
			finish = finish
		}
	end
}
