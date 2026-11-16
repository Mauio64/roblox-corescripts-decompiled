local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local React = require(parent.React)

local DictationMode = require(script.Parent.DictationMode)
local DictationAnalytics = require(script.Parent.DictationAnalytics)
require(script.Parent.requestMicPermission)

local FFlagExpChatDictationGrafanaMetrics = require(ExpChat.Flags.FFlagExpChatDictationGrafanaMetrics)

local function useDictationTelemetry()
	local ref = React.useRef(nil)

	return {
		logMicClick = React.useCallback(function(p, p2)
			DictationAnalytics.fire(DictationAnalytics.Events.MicClick, {
				[DictationAnalytics.Properties.SttMode] = p,
				[DictationAnalytics.Properties.EntryPoint] = p2
			})

			if FFlagExpChatDictationGrafanaMetrics then
				DictationAnalytics.reportStartedCounter(p, p2)
			end
		end, {}),
		logPermissionResolved = React.useCallback(function(p, p2)
			DictationAnalytics.fire(DictationAnalytics.Events.PermissionPrompt, {
				[DictationAnalytics.Properties.SttMode] = p,
				[DictationAnalytics.Properties.Status] = p2
			})

			if FFlagExpChatDictationGrafanaMetrics then
				DictationAnalytics.reportPermissionCounter(p, p2)
			end
		end, {}),
		logRecordingStart = React.useCallback(function(p, p2)
			DictationAnalytics.fire(DictationAnalytics.Events.RecordingStart, {
				[DictationAnalytics.Properties.SttMode] = p,
				[DictationAnalytics.Properties.TriggerType] = p2
			})
		end, {}),
		logRecordingStop = React.useCallback(function(p, p2, p3: number, p4: number?)
			DictationAnalytics.fire(DictationAnalytics.Events.RecordingStop, {
				[DictationAnalytics.Properties.SttMode] = p,
				[DictationAnalytics.Properties.TriggerType] = p2,
				[DictationAnalytics.Properties.DurationSeconds] = p3,
				[DictationAnalytics.Properties.CharCount] = p4
			})

			if FFlagExpChatDictationGrafanaMetrics and p2 ~= DictationAnalytics.TriggerTypes.AutoChunk then
				DictationAnalytics.reportEndedCounter(p, p2)
			end
		end, {}),
		logSpeechStarted = React.useCallback(function()
			ref.current = os.clock()
			DictationAnalytics.fire(DictationAnalytics.Events.RecordingStart, {
				[DictationAnalytics.Properties.SttMode] = DictationMode.Continuous,
				[DictationAnalytics.Properties.TriggerType] = DictationAnalytics.TriggerTypes.AutoChunk
			})
		end, {}),
		logTranscription = React.useCallback(function(list: string, p, flag: boolean)
			local count = #list

			if p == DictationMode.Continuous then
				local current = ref.current
				local fire = DictationAnalytics.fire
				local recordingStop = DictationAnalytics.Events.RecordingStop
				local v = {
					[DictationAnalytics.Properties.SttMode] = DictationMode.Continuous,
					[DictationAnalytics.Properties.TriggerType] = DictationAnalytics.TriggerTypes.AutoChunk,
					[DictationAnalytics.Properties.CharCount] = count
				}
				local durationSeconds = DictationAnalytics.Properties.DurationSeconds
				local v2

				if current then
					v2 = os.clock() - current
				end

				v[durationSeconds] = v2
				fire(recordingStop, v)

				ref.current = nil
			end

			DictationAnalytics.fire(DictationAnalytics.Events.TranscriptionDone, {
				[DictationAnalytics.Properties.SttMode] = p,
				[DictationAnalytics.Properties.Success] = flag,
				[DictationAnalytics.Properties.CharCount] = count
			})

			if FFlagExpChatDictationGrafanaMetrics then
				DictationAnalytics.reportTranscriptionCounter(p, flag)
			end
		end, {}),
		logTranscriptionFailed = React.useCallback(function(p)
			DictationAnalytics.fire(DictationAnalytics.Events.TranscriptionDone, {
				[DictationAnalytics.Properties.SttMode] = p,
				[DictationAnalytics.Properties.Success] = false
			})

			if FFlagExpChatDictationGrafanaMetrics then
				DictationAnalytics.reportTranscriptionCounter(p, false)
			end
		end, {}),
		logMicToastShown = React.useCallback(function(p, flag: boolean)
			DictationAnalytics.fire(DictationAnalytics.Events.MicToastShown, {
				[DictationAnalytics.Properties.SttMode] = p,
				[DictationAnalytics.Properties.CanDeepLink] = flag
			})
		end, {}),
		logMicToastActivated = React.useCallback(function(p, flag: boolean)
			DictationAnalytics.fire(DictationAnalytics.Events.MicToastActivated, {
				[DictationAnalytics.Properties.SttMode] = p,
				[DictationAnalytics.Properties.CanDeepLink] = flag
			})
		end, {}),
		logMicToastDismissed = React.useCallback(function(p, p2)
			DictationAnalytics.fire(DictationAnalytics.Events.MicToastDismiss, {
				[DictationAnalytics.Properties.SttMode] = p,
				[DictationAnalytics.Properties.DismissReason] = p2
			})
		end, {})
	}
end

return useDictationTelemetry
