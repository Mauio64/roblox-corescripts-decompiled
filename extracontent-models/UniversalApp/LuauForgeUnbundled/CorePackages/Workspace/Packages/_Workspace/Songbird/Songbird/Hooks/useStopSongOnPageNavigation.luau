local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/SignalsReact")
local MediaPlayback = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/MediaPlayback")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/React")

local getAudioPlaybackStore = MediaPlayback.getAudioPlaybackStore
local useEffect = React.useEffect
local useCallback = React.useCallback

local function useStopSongOnPageNavigation(p2, callback)
	local v5 = SignalsReact.useSignalState(getAudioPlaybackStore)

	local v6 = useCallback(function()
		for k, v7 in v5.getPlayingAudioStores(false) do
			v7.stop()
		end

		if callback then
			callback()
		end
	end, { v5, callback })

	useEffect(function()
		if not p2 then
			v6()
		end
	end, { p2, v6 })

	useEffect(function()
		return v6
	end, { v6 })
end

return useStopSongOnPageNavigation
