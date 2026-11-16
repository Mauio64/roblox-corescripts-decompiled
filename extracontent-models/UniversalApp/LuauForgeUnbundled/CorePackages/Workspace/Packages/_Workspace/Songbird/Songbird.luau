require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/types")

local module = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Analytics/sendAudioPlayerAnalytics")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Analytics/AnalyticActions")

return {
	AudioPlaybackTimeline = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Components/AudioPlaybackTimeline"),
	AudioPlayer = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Components/AudioPlayer"),
	AudioPlayerActions = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Components/AudioPlayerActions"),
	ChromeWindowWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Components/ChromeWindowWrapper"),
	ReportSongDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Components/ReportSongDialog"),
	DebugAudioEmitters = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Components/DebugAudioEmitters"),
	useCurrentSong = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Hooks/useCurrentSong"),
	useSongAlbumArt = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Hooks/useSongAlbumArt"),
	useAudioMetadata = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Hooks/useAudioMetadata"),
	Analytics = { sendAudioPlayerAnalytics = module, AnalyticActions = module2 }
}
