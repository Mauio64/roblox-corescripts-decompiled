local engineFeature = game:GetEngineFeature("AudioFocusManagement")

local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local dependencies = require(CrossExperienceVoice.dependencies)
local sharedFlags = dependencies.SharedFlags

local fFlagEnableCrossExperienceVoiceCaptureMute = sharedFlags.GetFFlagEnableCrossExperienceVoiceCaptureMute()
local fFlagEnableVoiceChatMuteForVideoCaptures = sharedFlags.GetFFlagEnableVoiceChatMuteForVideoCaptures()
local CaptureService

if fFlagEnableVoiceChatMuteForVideoCaptures then
	CaptureService = game:GetService("CaptureService")
else
	CaptureService = nil
end

local react = dependencies.React
local cryo = dependencies.Cryo

local function useIsCapturingVideo()
	local state, setState = react.useState(CaptureService and CaptureService:IsCapturingVideo())

	react.useEffect(function()
		if not CaptureService then
			return
		end

		local videoCaptureInProgressConnection = CaptureService.VideoCaptureInProgress:Connect(function(flag: boolean)
			setState(flag)
		end)

		return function()
			if CaptureService then
				videoCaptureInProgressConnection:Disconnect()
			end
		end
	end, {})

	return state
end

local function useEnableAudioFocusToggle()
	local state, setState = react.useState({})
	local v

	if fFlagEnableCrossExperienceVoiceCaptureMute and fFlagEnableVoiceChatMuteForVideoCaptures then
		v = useIsCapturingVideo()
	else
		v = false
	end

	local v2 = react.useCallback(function(p)
		if not state[p] then
			setState((cryo.Dictionary.join(state, { [p] = true })))
		end
	end, { state })

	local v3 = react.useCallback(function(p)
		if state[p] then
			setState((cryo.Dictionary.join(state, { [p] = nil })))
		end
	end, { state })

	react.useEffect(function()
		if not engineFeature then
			return
		end

		local success, result = pcall(function()
			return game:GetService("AudioFocusService")
		end)

		if not (success and result) then
			return
		end

		local registeredContexts = result:GetRegisteredContexts()
		local set = {}

		for k, _ in pairs(registeredContexts) do
			set[k] = true
		end

		setState(set)

		local onContextRegisteredConnection = result.OnContextRegistered:Connect(v2)
		local onContextUnregisteredConnection = result.OnContextUnregistered:Connect(v3)

		return function()
			if onContextRegisteredConnection then
				onContextRegisteredConnection:Disconnect()
			end

			if onContextUnregisteredConnection then
				onContextUnregisteredConnection:Disconnect()
			end
		end
	end, {})

	return state[1] and state[2] and not v
end

return useEnableAudioFocusToggle
