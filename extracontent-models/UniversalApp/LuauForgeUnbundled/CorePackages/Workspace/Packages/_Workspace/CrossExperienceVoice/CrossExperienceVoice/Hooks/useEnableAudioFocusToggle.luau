local engineFeature = game:GetEngineFeature("AudioFocusManagement")

local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/dependencies")
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

		local videoCaptureInProgressConnection = CaptureService.VideoCaptureInProgress:Connect(function(p2)
			setState(p2)
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
	local v5

	if fFlagEnableCrossExperienceVoiceCaptureMute and fFlagEnableVoiceChatMuteForVideoCaptures then
		v5 = useIsCapturingVideo()
	else
		v5 = false
	end

	local v6 = react.useCallback(function(p2)
		if not state[p2] then
			setState((cryo.Dictionary.join(state, { [p2] = true })))
		end
	end, { state })

	local v7 = react.useCallback(function(p2)
		if state[p2] then
			setState((cryo.Dictionary.join(state, { [p2] = nil })))
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

		for k, registeredContext in pairs(registeredContexts) do
			set[k] = true
		end

		setState(set)

		local onContextRegisteredConnection = result.OnContextRegistered:Connect(v6)
		local onContextUnregisteredConnection = result.OnContextUnregistered:Connect(v7)

		return function()
			if onContextRegisteredConnection then
				onContextRegisteredConnection:Disconnect()
			end

			if onContextUnregisteredConnection then
				onContextUnregisteredConnection:Disconnect()
			end
		end
	end, {})

	return state[1] and state[2] and not v5
end

return useEnableAudioFocusToggle
