local MediaPlayback = script:FindFirstAncestor("MediaPlayback")

local React = require(MediaPlayback.Parent.React)

require(MediaPlayback.Stores.getAudioPlaybackStore.types)
local getAudioPlaybackStore = require(MediaPlayback.Stores.getAudioPlaybackStore)

local useEffect = React.useEffect
local useMemo = React.useMemo

local function useAudioStore(value, flag: boolean?)
	local v = value or "-1"

	local v2 = useMemo(function()
		return getAudioPlaybackStore(false).getOrCreateAudioStore(v, flag)
	end, { v, flag })

	useEffect(function()
		return function()
			getAudioPlaybackStore(false).destroyAudioStore(v, flag)
		end
	end, { v, flag })

	return v2
end

return useAudioStore
