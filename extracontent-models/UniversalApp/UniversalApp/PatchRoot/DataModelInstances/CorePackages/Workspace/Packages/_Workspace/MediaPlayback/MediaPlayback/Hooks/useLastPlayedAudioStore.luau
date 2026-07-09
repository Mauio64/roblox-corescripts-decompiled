local MediaPlayback = script:FindFirstAncestor("MediaPlayback")
local SignalsReact = require(MediaPlayback.Parent.SignalsReact)

require(MediaPlayback.Stores.getAudioPlaybackStore.types)

local getAudioPlaybackStore = require(MediaPlayback.Stores.getAudioPlaybackStore)
local useAudioStore = require(MediaPlayback.Hooks.useAudioStore)
local useSignalState = SignalsReact.useSignalState

local function useLastPlayedAudioStore() -- line: 11
	-- upvalues: useSignalState (copy), getAudioPlaybackStore (copy), useAudioStore (copy)
	local v7 = useSignalState(getAudioPlaybackStore)
	local v8 = useSignalState(v7.getLastPlayedAudioStore)

	return useAudioStore(if not v8 then nil else v8.assetId, if not v8 then nil else v8.usePreview)
end

return useLastPlayedAudioStore
