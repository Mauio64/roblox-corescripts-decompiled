local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local React = require(MomentsCreationParent.React)
local Signals = require(MomentsCreationParent.Signals)

require(MomentsCreationParent.MomentsTypes)

local useAudioPlayback = require(MomentsCreation.Hooks.useAudioPlayback)
local GetFFlagMomentsMuteVideoAudioOnly = require(MomentsCreation.Flags.GetFFlagMomentsMuteVideoAudioOnly)

local function useCreationMusicSync(p1, n1: number) -- line: 37
	-- upvalues: React (copy), Signals (copy), useAudioPlayback (copy), GetFFlagMomentsMuteVideoAudioOnly (copy)
	local playback = p1.playback
	local v11, v12 = React.useState((playback.getMusic(false)))
	local v13, v14 = React.useState(playback.getIsMuted(false))
	local v15, v16 = React.useState(playback.getIsPlaying(false))

	React.useEffect(function() -- line: 44
		-- upvalues: Signals (copy), v12 (copy), playback (copy), v14 (copy), v16 (copy)
		return Signals.createEffect(function(p2) -- line: 45
			-- upvalues: v12 (copy), playback (copy), v14 (copy), v16 (copy)
			v12(playback.getMusic(p2))
			v14(playback.getIsMuted(p2))
			v16(playback.getIsPlaying(p2))
		end)
	end, { playback })

	local v17 = React.useMemo(function() -- line: 53
		-- upvalues: v11 (copy), n1 (copy)
		if v11 == nil then
			return nil
		end

		return NumberRange.new(v11.startTime, v11.startTime + math.max(0, n1))
	end, {
		v11,
		n1
	})
	local v18 = useAudioPlayback(v11 ~= nil, if v11 == nil then nil else v11.assetId, {
		autoplay = true,
		looping = true,
		playbackRegion = v17 or NumberRange.new(0, 1e999)
	})

	React.useEffect(function() -- line: 69
		-- upvalues: v11 (copy), v15 (copy), v18 (copy)
		if v11 == nil then
			return
		end

		if v15 then
			v18.playback.play()

			return
		end

		v18.playback.pause()
	end, {
		v11,
		v15
	})
	React.useEffect(function() -- line: 85
		-- upvalues: v11 (copy), GetFFlagMomentsMuteVideoAudioOnly (copy), v13 (copy), v18 (copy)
		if v11 == nil then
			return
		end

		if not GetFFlagMomentsMuteVideoAudioOnly() and v13 then
			v18.volume.mute()

			return
		end

		v18.volume.unmute()
	end, {
		v11,
		v13
	})

	return {
		audio = v18,
		music = v11,
		userMuted = v13
	}
end

return useCreationMusicSync
