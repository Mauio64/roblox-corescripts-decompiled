local MediaPlayback = script:FindFirstAncestor("MediaPlayback")

local SignalsReact = require(MediaPlayback.Parent.SignalsReact)

require(MediaPlayback.Stores.getAudioPlaybackStore.types)
local getAudioPlaybackStore = require(MediaPlayback.Stores.getAudioPlaybackStore)
local useAudioStore = require(MediaPlayback.Hooks.useAudioStore)

local useSignalState = SignalsReact.useSignalState

local function useLastPlayedAudioStore()
	local v = useSignalState(useSignalState(getAudioPlaybackStore).getLastPlayedAudioStore)
	local assetId

	if v then
		assetId = v.assetId
	end

	local v2

	if v then
		v2 = v.usePreview
	end

	return useAudioStore(assetId, v2)
end

return useLastPlayedAudioStore
