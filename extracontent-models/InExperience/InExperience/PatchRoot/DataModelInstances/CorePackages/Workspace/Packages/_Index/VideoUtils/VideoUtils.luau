require(script.Analytics.VideoAnalyticsTypes)

local FeedVideoPlaybackContext = require(script.FeedVideoPlaybackContext)
local VideoPlaybackCoordinator = require(script.VideoPlaybackCoordinator)
local VideoPlaybackDetectionMethod = require(script.VideoPlaybackDetectionMethod)
local VideoPlaybackDetector = require(script.VideoPlaybackDetector)
local ViewportVideoAutoplayController = require(script.ViewportVideoAutoplayController)
local VideoPlayer = require(script.VideoPlayer)
local EdpVideoBlockingConfig = require(script.EdpVideoBlockingConfig)

return {
	FeedVideoPlaybackContext = FeedVideoPlaybackContext,
	VideoPlaybackCoordinator = VideoPlaybackCoordinator,
	VideoPlaybackDetectionMethod = VideoPlaybackDetectionMethod,
	VideoPlaybackDetector = VideoPlaybackDetector,
	ViewportVideoAutoplayController = ViewportVideoAutoplayController,
	ViewportVideoAutoplaySync = require(script.ViewportVideoAutoplaySync),
	VideoPlayer = VideoPlayer,
	AnalyticsEnums = require(script.Analytics.Enums),
	VideoLogger = require(script.Analytics.VideoLogger),
	getIsInstanceVisible = require(script.getIsInstanceVisible),
	getPlaybackDetectionMethod = require(script.getPlaybackDetectionMethod),
	RoundIconButton = require(script.RoundIconButton),
	useCanDevicePlayVideoPreview = require(script.useCanDevicePlayVideoPreview),
	useTagAsViewportAutoplayCandidate = require(script.useTagAsViewportAutoplayCandidate),
	EdpVideoBlockingConfig = EdpVideoBlockingConfig,
	VideoBlockingHelpers = require(script.VideoBlockingHelpers),
	["jest.config"] = script["jest.config"]
}
