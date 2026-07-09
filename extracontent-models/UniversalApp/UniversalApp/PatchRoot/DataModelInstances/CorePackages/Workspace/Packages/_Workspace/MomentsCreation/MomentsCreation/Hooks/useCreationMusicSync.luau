local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local React = require(MomentsCreationParent.React)
local Signals = require(MomentsCreationParent.Signals)

require(MomentsCreationParent.MomentsTypes)

local useAudioPlayback = require(MomentsCreation.Hooks.useAudioPlayback)

local function useCreationMusicSync(p1, n1: number) -- line: 36
	-- upvalues: React (copy), Signals (copy), useAudioPlayback (copy)
	local playback = p1.playback
	local v10, v11 = React.useState((playback.getMusic(false)))
	local v12, v13 = React.useState(playback.getIsMuted(false))
	local v14, v15 = React.useState(playback.getIsPlaying(false))

	React.useEffect(function() -- line: 43
		-- upvalues: Signals (copy), v11 (copy), playback (copy), v13 (copy), v15 (copy)
		return Signals.createEffect(function(p2) -- line: 44
			-- upvalues: v11 (copy), playback (copy), v13 (copy), v15 (copy)
			v11(playback.getMusic(p2))
			v13(playback.getIsMuted(p2))
			v15(playback.getIsPlaying(p2))
		end)
	end, { playback })

	local v16 = React.useMemo(function() -- line: 52
		-- upvalues: v10 (copy), n1 (copy)
		if v10 == nil then
			return nil
		end

		return NumberRange.new(v10.startTime, v10.startTime + math.max(0, n1))
	end, {
		v10,
		n1
	})
	local v17 = useAudioPlayback(v10 ~= nil, if v10 == nil then nil else v10.assetId, {
		autoplay = true,
		looping = true,
		playbackRegion = v16 or NumberRange.new(0, 1e999)
	})

	React.useEffect(function() -- line: 68
		-- upvalues: v10 (copy), v14 (copy), v17 (copy)
		if v10 == nil then
			return
		end

		if v14 then
			v17.playback.play()

			return
		end

		v17.playback.pause()
	end, {
		v10,
		v14
	})
	React.useEffect(function() -- line: 81
		-- upvalues: v10 (copy), v12 (copy), v17 (copy)
		if v10 == nil then
			return
		end

		if v12 then
			v17.volume.mute()

			return
		end

		v17.volume.unmute()
	end, {
		v10,
		v12
	})

	return {
		audio = v17,
		music = v10,
		userMuted = v12
	}
end

return useCreationMusicSync
