require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/Analytics/VideoAnalyticsTypes")
local module = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/ViewportVideoAutoplayMode")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/FeedVideoPlaybackContext")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/VideoPlaybackCoordinator")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/VideoPlaybackDetectionMethod")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/VideoPlaybackDetector")
local module6 = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/ViewportVideoAutoplayController")
local module7 = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/VideoPlayer")
local module8 = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/EdpVideoBlockingConfig")

return {
	FeedVideoPlaybackContext = module2,
	VideoPlaybackCoordinator = module3,
	ViewportVideoAutoplayMode = module,
	VideoPlaybackDetectionMethod = module4,
	VideoPlaybackDetector = module5,
	ViewportVideoAutoplayController = module6,
	ViewportVideoAutoplaySync = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/ViewportVideoAutoplaySync"),
	VideoPlayer = module7,
	AnalyticsEnums = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/Analytics/Enums"),
	VideoLogger = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/Analytics/VideoLogger"),
	getIsInstanceVisible = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/getIsInstanceVisible"),
	getPlaybackDetectionMethod = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/getPlaybackDetectionMethod"),
	isVideoEligibleForPlayability = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/isVideoEligibleForPlayability"),
	RoundIconButton = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/RoundIconButton"),
	useCanDevicePlayVideoPreview = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/useCanDevicePlayVideoPreview"),
	useFeedVideoPlaybackContext = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/useFeedVideoPlaybackContext"),
	useTagAsViewportAutoplayCandidate = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/useTagAsViewportAutoplayCandidate"),
	EdpVideoBlockingConfig = module8,
	VideoBlockingHelpers = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/VideoBlockingHelpers")
}
