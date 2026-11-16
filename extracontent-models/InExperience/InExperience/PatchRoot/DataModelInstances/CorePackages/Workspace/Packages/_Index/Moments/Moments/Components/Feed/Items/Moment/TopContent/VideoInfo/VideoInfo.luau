local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
require(parent.MomentsTypes)
local SignalsReact = require(parent.SignalsReact)

local MomentContext = require(script.Parent.Parent.Parent.MomentContext)

local FFlagMomentsEngagementMetricsFeature = MomentsCommon.Flags.FFlagMomentsEngagementMetricsFeature
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsServeEDPVideos = SharedFlags.FFlagMomentsServeEDPVideos
local SharedFlags2 = require(parent.SharedFlags)
local FFlagMomentsRenderAvatarPostsInFeed = SharedFlags2.FFlagMomentsRenderAvatarPostsInFeed
local CreatorAttribution = require(script.Parent.CreatorAttribution)
local DebugInfo = require(script.Parent.DebugInfo)
local Description = require(script.Parent.Description)
local Reactions = require(script.Parent.Reactions)
local StatusChip = require(script.Parent.StatusChip)

local MomentsSessionContext = require(Moments.Stores.GetMomentsStore.MomentsSessionContext)
local useMomentsSession = MomentsSessionContext.useMomentsSession

local View = Foundation.View

local GetMomentsCapabilities = MomentsCommon.Stores.GetMomentsCapabilities
local useSignalState = SignalsReact.useSignalState

local function VideoInfo(p)
	local kind = useSignalState(MomentContext.useMoment().store.getData).kind
	local v = kind == "experience" or FFlagMomentsRenderAvatarPostsInFeed and kind == "avatar"
	local v2

	if FFlagMomentsServeEDPVideos then
		if p.moment == nil then
			v2 = false
		else
			v2 = p.moment.entityType == "edpVideo"
		end
	end

	local v3

	if FFlagMomentsEngagementMetricsFeature then
		v3 = useSignalState(GetMomentsCapabilities(false).getIsEngagementMetricsEnabled)
	end

	local children = {}

	if not useSignalState(useMomentsSession().getHideDetails) then
		children.DebugInfo = React.createElement(DebugInfo, { LayoutOrder = 0 })
		local creatorAttribution

		if v and not (FFlagMomentsServeEDPVideos and v2) then
			creatorAttribution = React.createElement(CreatorAttribution, { LayoutOrder = 1 })
		end

		children.CreatorAttribution = creatorAttribution

		children.Description = React.createElement(Description, { LayoutOrder = 2 })
		local reactions

		if v and (not FFlagMomentsEngagementMetricsFeature or v3) then
			reactions = React.createElement(Reactions, { LayoutOrder = 3 })
		end

		children.Reactions = reactions

		children.StatusChip = React.createElement(StatusChip, { LayoutOrder = 4 })
	end

	return React.createElement(
		View,
		{
			LayoutOrder = p.LayoutOrder,
			tag = "col align-x-left align-y-bottom grow gap-small auto-y"
		},
		children
	)
end

return React.memo(VideoInfo)
