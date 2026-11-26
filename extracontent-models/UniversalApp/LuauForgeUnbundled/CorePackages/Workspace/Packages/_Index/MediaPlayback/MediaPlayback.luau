local module = require("@game/CorePackages/Workspace/Packages/_Index/MediaPlayback/MediaPlayback/Stores/getAudioPlaybackStore")

return {
	useLazyFmod = require("@game/CorePackages/Workspace/Packages/_Index/MediaPlayback/MediaPlayback/Hooks/useLazyFmod"),
	getAudioPlaybackStore = module,
	useAudioStore = require("@game/CorePackages/Workspace/Packages/_Index/MediaPlayback/MediaPlayback/Hooks/useAudioStore"),
	useLastPlayedAudioStore = require("@game/CorePackages/Workspace/Packages/_Index/MediaPlayback/MediaPlayback/Hooks/useLastPlayedAudioStore"),
	enableAudioPlaybackInApp = require("@game/CorePackages/Workspace/Packages/_Index/MediaPlayback/MediaPlayback/Common/enableAudioPlaybackInApp"),
	getFFlagAudioPreviewLua = require("@game/CorePackages/Workspace/Packages/_Index/MediaPlayback/MediaPlayback/Flags/getFFlagAudioPreviewLua")
}
