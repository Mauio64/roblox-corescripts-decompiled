local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaPlayback/React")

require("@game/CorePackages/Workspace/Packages/_Index/MediaPlayback/MediaPlayback/Stores/getAudioPlaybackStore/types")
local getAudioPlaybackStore = require("@game/CorePackages/Workspace/Packages/_Index/MediaPlayback/MediaPlayback/Stores/getAudioPlaybackStore")

local useEffect = React.useEffect
local useMemo = React.useMemo

local function useAudioStore(value, p2)
	local v5 = value or "-1"

	local v6 = useMemo(function()
		return getAudioPlaybackStore(false).getOrCreateAudioStore(v5, p2)
	end, { v5, p2 })

	useEffect(function()
		return function()
			getAudioPlaybackStore(false).destroyAudioStore(v5, p2)
		end
	end, { v5, p2 })

	return v6
end

return useAudioStore
