require(script.types)

local sendAudioPlayerAnalytics = require(script.Analytics.sendAudioPlayerAnalytics)
local AnalyticActions = require(script.Analytics.AnalyticActions)

return {
	AudioPlaybackTimeline = require(script.Components.AudioPlaybackTimeline),
	AudioPlayer = require(script.Components.AudioPlayer),
	AudioPlayerActions = require(script.Components.AudioPlayerActions),
	ChromeWindowWrapper = require(script.Components.ChromeWindowWrapper),
	ReportSongDialog = require(script.Components.ReportSongDialog),
	DebugAudioEmitters = require(script.Components.DebugAudioEmitters),
	useCurrentSong = require(script.Hooks.useCurrentSong),
	useSongAlbumArt = require(script.Hooks.useSongAlbumArt),
	useAudioMetadata = require(script.Hooks.useAudioMetadata),
	Analytics = {
		sendAudioPlayerAnalytics = sendAudioPlayerAnalytics,
		AnalyticActions = AnalyticActions
	},
	["jest.config"] = script["jest.config"]
}
