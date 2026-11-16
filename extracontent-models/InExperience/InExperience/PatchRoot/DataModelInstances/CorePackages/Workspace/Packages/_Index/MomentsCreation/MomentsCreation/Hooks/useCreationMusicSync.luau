local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
require(parent.MomentsTypes)
require(MomentsCreation.Types.CreationFlowTypes)

local useAudioPlayback = require(MomentsCreation.Hooks.useAudioPlayback)
local GetFFlagMomentsTTSAudioOverlay = require(MomentsCreation.Flags.GetFFlagMomentsTTSAudioOverlay)
local getTtsDuckScalar = require(MomentsCreation.Audio.getTtsDuckScalar)

local function useCreationMusicSync(p, p2: number, p3)
	local playback = p.playback

	local state, setState = React.useState((playback.getMusic(false)))
	local state2, setState2 = React.useState(playback.getIsMuted(false))
	local state3, setState3 = React.useState(playback.getIsPlaying(false))

	local useState = React.useState
	local v = GetFFlagMomentsTTSAudioOverlay

	if v then
		if p3 == nil then
			v = false
		else
			v = p3.getState(false) == "playing"
		end
	end

	local state4, setState4 = useState(v)

	React.useEffect(function()
		return Signals.createEffect(function(p4)
			setState(playback.getMusic(p4))
			setState2(playback.getIsMuted(p4))
			setState3(playback.getIsPlaying(p4))

			if GetFFlagMomentsTTSAudioOverlay then
				setState4(p3 ~= nil and p3.getState(p4) == "playing")
			end
		end)
	end, { playback })

	local isDucking = GetFFlagMomentsTTSAudioOverlay and state4
	local duckScalar = not isDucking and 1 or getTtsDuckScalar()

	local v2 = React.useMemo(function()
		if state == nil then
			return nil
		end

		return NumberRange.new(state.startTime, state.startTime + math.max(0, p2))
	end, { state, p2 })
	local v3 = state ~= nil
	local v4

	if state ~= nil then
		v4 = state.assetId
	end

	local audio = useAudioPlayback(v3, v4, {
		autoplay = true,
		looping = true,
		playbackRegion = v2 or NumberRange.new(0, 1e999),
		duckScalar = duckScalar
	})

	React.useEffect(function()
		if state == nil then
			return
		end

		if state3 then
			audio.playback.play()
		else
			audio.playback.pause()
		end
	end, { state, state3 })

	React.useEffect(function()
		if state == nil then
			return
		end

		audio.volume.unmute()
	end, { state, state2 })

	return { audio = audio, music = state, userMuted = state2, isDucking = isDucking }
end

return useCreationMusicSync
