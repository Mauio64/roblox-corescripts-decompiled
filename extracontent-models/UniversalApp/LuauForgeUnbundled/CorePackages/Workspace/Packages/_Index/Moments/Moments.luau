local module = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Constants")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Enums")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentItem")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/MomentsTabEntry")
local module6 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/MomentsFeedSurface")
local module7 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/MomentsBackHeader")
local module8 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/MomentsHostShell")
local module9 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/MomentsImmersivePresentation")
local module10 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Moderation/reportMoment")
local module11 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Moderation/reportEdpVideo")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/MomentsHostContext")

return {
	Constants = module,
	Enums = module2,
	Feed = module3.Feed,
	createFeedStore = module3.createFeedStore,
	createMockFeedSource = module3.createMockFeedSource,
	createSnapshotFeedSource = module3.createSnapshotFeedSource,
	useFeed = module3.useFeed,
	MomentItem = module4,
	MomentsTabEntry = module5,
	MomentsFeedSurface = module6,
	MomentsBackHeader = module7,
	MomentsHostShell = module8,
	MomentsImmersivePresentation = module9,
	reportMoment = module10,
	reportEdpVideo = module11
}
