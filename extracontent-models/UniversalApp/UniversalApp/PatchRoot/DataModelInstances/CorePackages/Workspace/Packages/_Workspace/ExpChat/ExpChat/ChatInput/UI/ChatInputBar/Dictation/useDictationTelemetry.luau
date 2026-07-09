local Parent = script:FindFirstAncestor("ExpChat").Parent
local React = require(Parent.React)
local DictationMode = require(script.Parent.DictationMode)
local DictationAnalytics = require(script.Parent.DictationAnalytics)

require(script.Parent.requestMicPermission)

local function useDictationTelemetry() -- line: 28
	-- upvalues: React (copy), DictationAnalytics (copy), DictationMode (copy)
	local v6 = React.useRef(nil)
	local v7 = React.useCallback(function(p1, p2) -- line: 31
		-- upvalues: DictationAnalytics (copy)
		DictationAnalytics.fire(DictationAnalytics.Events.MicClick, {
			[DictationAnalytics.Properties.SttMode] = p1,
			[DictationAnalytics.Properties.EntryPoint] = p2
		})
	end, {})
	local v8 = React.useCallback(function(p3, p4) -- line: 38
		-- upvalues: DictationAnalytics (copy)
		DictationAnalytics.fire(DictationAnalytics.Events.PermissionPrompt, {
			[DictationAnalytics.Properties.SttMode] = p3,
			[DictationAnalytics.Properties.Status] = p4
		})
	end, {})
	local v9 = React.useCallback(function(p5, p6) -- line: 45
		-- upvalues: DictationAnalytics (copy)
		DictationAnalytics.fire(DictationAnalytics.Events.RecordingStart, {
			[DictationAnalytics.Properties.SttMode] = p5,
			[DictationAnalytics.Properties.TriggerType] = p6
		})
	end, {})
	local v10 = React.useCallback(function(p7, p8, n1: number, n2: number?) -- line: 53
		-- upvalues: DictationAnalytics (copy)
		DictationAnalytics.fire(DictationAnalytics.Events.RecordingStop, {
			[DictationAnalytics.Properties.SttMode] = p7,
			[DictationAnalytics.Properties.TriggerType] = p8,
			[DictationAnalytics.Properties.DurationSeconds] = n1,
			[DictationAnalytics.Properties.CharCount] = n2
		})
	end, {})
	local v11 = React.useCallback(function() -- line: 69
		-- upvalues: v6 (copy), DictationAnalytics (copy), DictationMode (copy)
		v6.current = os.clock()
		DictationAnalytics.fire(DictationAnalytics.Events.RecordingStart, {
			[DictationAnalytics.Properties.SttMode] = DictationMode.Continuous,
			[DictationAnalytics.Properties.TriggerType] = DictationAnalytics.TriggerTypes.AutoChunk
		})
	end, {})
	local v12 = React.useCallback(function(s1: string, p9, b1: boolean) -- line: 77
		-- upvalues: DictationMode (copy), v6 (copy), DictationAnalytics (copy)
		local v27 = #s1

		if p9 == DictationMode.Continuous then
			local current = v6.current

			DictationAnalytics.fire(DictationAnalytics.Events.RecordingStop, {
				[DictationAnalytics.Properties.SttMode] = DictationMode.Continuous,
				[DictationAnalytics.Properties.TriggerType] = DictationAnalytics.TriggerTypes.AutoChunk,
				[DictationAnalytics.Properties.CharCount] = v27,
				[DictationAnalytics.Properties.DurationSeconds] = if not current then nil else os.clock() - current
			})
			v6.current = nil
		end

		DictationAnalytics.fire(DictationAnalytics.Events.TranscriptionDone, {
			[DictationAnalytics.Properties.SttMode] = p9,
			[DictationAnalytics.Properties.Success] = b1,
			[DictationAnalytics.Properties.CharCount] = v27
		})
	end, {})
	local v13 = React.useCallback(function(p10) -- line: 98
		-- upvalues: DictationAnalytics (copy)
		DictationAnalytics.fire(DictationAnalytics.Events.TranscriptionDone, {
			[DictationAnalytics.Properties.SttMode] = p10,
			[DictationAnalytics.Properties.Success] = false
		})
	end, {})

	return {
		logMicClick = v7,
		logPermissionResolved = v8,
		logRecordingStart = v9,
		logRecordingStop = v10,
		logSpeechStarted = v11,
		logTranscription = v12,
		logTranscriptionFailed = v13
	}
end

return useDictationTelemetry
