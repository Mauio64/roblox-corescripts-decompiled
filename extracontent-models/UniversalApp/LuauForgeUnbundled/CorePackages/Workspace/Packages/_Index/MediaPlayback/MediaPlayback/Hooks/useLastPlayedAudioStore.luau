local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaPlayback/SignalsReact")

require("@game/CorePackages/Workspace/Packages/_Index/MediaPlayback/MediaPlayback/Stores/getAudioPlaybackStore/types")
local getAudioPlaybackStore = require("@game/CorePackages/Workspace/Packages/_Index/MediaPlayback/MediaPlayback/Stores/getAudioPlaybackStore")
local useAudioStore = require("@game/CorePackages/Workspace/Packages/_Index/MediaPlayback/MediaPlayback/Hooks/useAudioStore")

local useSignalState = SignalsReact.useSignalState

local function useLastPlayedAudioStore()
	local v6 = useSignalState(useSignalState(getAudioPlaybackStore).getLastPlayedAudioStore)

	local assetId = if v6 then v6.assetId else nil
	local v8 = if v6 then v6.usePreview else nil
	return useAudioStore(assetId, v8)
end

return useLastPlayedAudioStore
