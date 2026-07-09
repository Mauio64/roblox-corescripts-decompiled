local Songbird = script:FindFirstAncestor("Songbird")
local SignalsReact = require(Songbird.Parent.SignalsReact)
local MediaPlayback = require(Songbird.Parent.MediaPlayback)
local React = require(Songbird.Parent.React)
local getAudioPlaybackStore = MediaPlayback.getAudioPlaybackStore
local useEffect = React.useEffect
local useCallback = React.useCallback

local function useStopSongOnPageNavigation(b1: boolean, p1: ((...any) -> ...any)?) -- line: 23
	-- upvalues: SignalsReact (copy), getAudioPlaybackStore (copy), useCallback (copy), useEffect (copy)
	local v11 = SignalsReact.useSignalState(getAudioPlaybackStore)
	local v12 = useCallback(function() -- line: 26
		-- upvalues: v11 (copy), p1 (copy)
		for _, v14 in v11.getPlayingAudioStores(false) do
			v14.stop()
		end

		if p1 then
			p1()
		end
	end, {
		v11,
		p1
	})

	useEffect(function() -- line: 35
		-- upvalues: b1 (copy), v12 (copy)
		if not b1 then
			v12()
		end
	end, {
		b1,
		v12
	})
	useEffect(function() -- line: 41
		-- upvalues: v12 (copy)
		return v12
	end, { v12 })
end

return useStopSongOnPageNavigation
