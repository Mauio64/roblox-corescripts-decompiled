local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local MomentContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentContext")

local fFlagMomentsEngagementMetricsFeature = MomentsCommon.Flags.FFlagMomentsEngagementMetricsFeature
local fFlagMomentsServeEDPVideos = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsServeEDPVideos
local fFlagMomentsRenderAvatarPostsInFeed = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsRenderAvatarPostsInFeed
local CreatorAttribution = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/TopContent/VideoInfo/CreatorAttribution")
local DebugInfo = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/TopContent/VideoInfo/DebugInfo")
local Description = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/TopContent/VideoInfo/Description")
local Reactions = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/TopContent/VideoInfo/Reactions")
local StatusChip = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/TopContent/VideoInfo/StatusChip")

local useMomentsSession = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/MomentsSessionContext").useMomentsSession

local view = Foundation.View

local getMomentsCapabilities = MomentsCommon.Stores.GetMomentsCapabilities
local useSignalState = SignalsReact.useSignalState

local function VideoInfo(p2)
	local kind = useSignalState(MomentContext.useMoment().store.getData).kind
	local v6 = kind == "experience" or fFlagMomentsRenderAvatarPostsInFeed and kind == "avatar"
	local v7

	if fFlagMomentsServeEDPVideos then
		v7 = not (p2.moment == nil) and p2.moment.entityType == "edpVideo"
	end

	local v8

	if fFlagMomentsEngagementMetricsFeature then
		v8 = useSignalState(getMomentsCapabilities(false).getIsEngagementMetricsEnabled)
	end

	local children = {}

	if not useSignalState(useMomentsSession().getHideDetails) then
		children.DebugInfo = React.createElement(DebugInfo, { LayoutOrder = 0 })

		local v10 = if v6 and not (fFlagMomentsServeEDPVideos and v7) then React.createElement(CreatorAttribution, {
			LayoutOrder = 1
		}) else nil
		children.CreatorAttribution = v10

		children.Description = React.createElement(Description, { LayoutOrder = 2 })

		local v11 = if v6 and (not fFlagMomentsEngagementMetricsFeature or v8) then React.createElement(Reactions, {
			LayoutOrder = 3
		}) else nil
		children.Reactions = v11

		children.StatusChip = React.createElement(StatusChip, { LayoutOrder = 4 })
	end

	return React.createElement(
		view,
		{
			LayoutOrder = p2.LayoutOrder,
			tag = "col align-x-left align-y-bottom grow gap-small auto-y"
		},
		children
	)
end

return React.memo(VideoInfo)
