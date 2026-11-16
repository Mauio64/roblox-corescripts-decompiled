local Songbird = script:FindFirstAncestor("Songbird")

local SignalsReact = require(Songbird.Parent.SignalsReact)
local MediaPlayback = require(Songbird.Parent.MediaPlayback)
local React = require(Songbird.Parent.React)

local getAudioPlaybackStore = MediaPlayback.getAudioPlaybackStore
local useEffect = React.useEffect
local useCallback = React.useCallback

local function useStopSongOnPageNavigation(flag: boolean, callback)
	local v = SignalsReact.useSignalState(getAudioPlaybackStore)

	local v2 = useCallback(function()
		for _, v2 in v.getPlayingAudioStores(false) do
			v2.stop()
		end

		if callback then
			callback()
		end
	end, { v, callback })

	useEffect(function()
		if not flag then
			v2()
		end
	end, { flag, v2 })

	useEffect(function()
		return v2
	end, { v2 })
end

return useStopSongOnPageNavigation
