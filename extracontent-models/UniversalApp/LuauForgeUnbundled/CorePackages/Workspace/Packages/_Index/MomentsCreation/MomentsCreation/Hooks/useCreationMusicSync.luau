local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")

local useAudioPlayback = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useAudioPlayback")
local GetFFlagMomentsTTSAudioOverlay = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFFlagMomentsTTSAudioOverlay")
local getTtsDuckScalar = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Audio/getTtsDuckScalar")

local function useCreationMusicSync(p2, p3, p4)
	local playback = p2.playback

	local state, setState = React.useState(playback.getMusic(false))
	local state2, setState2 = React.useState(playback.getIsMuted(false))
	local state3, setState3 = React.useState(playback.getIsPlaying(false))

	local useState = React.useState
	local v5 = GetFFlagMomentsTTSAudioOverlay

	if v5 then
		v5 = not (p4 == nil) and p4.getState(false) == "playing"
	end

	local state4, setState4 = useState(v5)

	React.useEffect(function()
		return Signals.createEffect(function(p5)
			setState(playback.getMusic(p5))
			setState2(playback.getIsMuted(p5))
			setState3(playback.getIsPlaying(p5))

			if GetFFlagMomentsTTSAudioOverlay then
				setState4(p4 ~= nil and p4.getState(p5) == "playing")
			end
		end)
	end, { playback })

	local v6 = GetFFlagMomentsTTSAudioOverlay and state4
	local v7 = not v6 and 1 or getTtsDuckScalar()

	local v8 = React.useMemo(function()
		if state == nil then
			return nil
		end

		return NumberRange.new(state.startTime, state.startTime + math.max(0, p3))
	end, { state, p3 })
	local v10 = state ~= nil
	local v11 = if state ~= nil then state.assetId else nil
	local v12 = useAudioPlayback(v10, v11, {
		autoplay = true,
		looping = true,
		playbackRegion = v8 or NumberRange.new(0, 1e999),
		duckScalar = v7
	})

	React.useEffect(function()
		if state == nil then
			return
		end

		if state3 then
			v12.playback.play()
		else
			v12.playback.pause()
		end
	end, { state, state3 })

	React.useEffect(function()
		if state == nil then
			return
		end

		v12.volume.unmute()
	end, { state, state2 })

	return { audio = v12, music = state, userMuted = state2, isDucking = v6 }
end

return useCreationMusicSync
