local MediaPlayback = script:FindFirstAncestor("MediaPlayback")
local React = require(MediaPlayback.Parent.React)

require(MediaPlayback.Stores.getAudioPlaybackStore.types)

local getAudioPlaybackStore = require(MediaPlayback.Stores.getAudioPlaybackStore)
local useEffect = React.useEffect
local useMemo = React.useMemo

local function useAudioStore(p1, b1: boolean?) -- line: 11
	-- upvalues: useMemo (copy), getAudioPlaybackStore (copy), useEffect (copy)
	local v9 = p1 or "-1"
	local v10 = useMemo(function() -- line: 14
		-- upvalues: getAudioPlaybackStore (copy), v9 (copy), b1 (copy)
		return getAudioPlaybackStore(false).getOrCreateAudioStore(v9, b1)
	end, {
		v9,
		b1
	})

	useEffect(function() -- line: 19
		-- upvalues: getAudioPlaybackStore (copy), v9 (copy), b1 (copy)
		return function() -- line: 20
			-- upvalues: getAudioPlaybackStore (copy), v9 (copy), b1 (copy)
			getAudioPlaybackStore(false).destroyAudioStore(v9, b1)
		end
	end, {
		v9,
		b1
	})

	return v10
end

return useAudioStore
