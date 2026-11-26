local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/BuilderIcons")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/MomentsCommon")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/DataHydration/MomentsStoreTypes")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SignalsReact")
local ToMediaItem = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Moments/ToMediaItem")
local useSceneOutfitMediaItem = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Moments/useSceneOutfitMediaItem")
local SceneOutfitPoster = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Moments/SceneOutfitPoster")

local MomentEngagementCount = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Moments/MomentEngagementCount")
local fFlagMomentsEngagementMetricsFeature = MomentsCommon.Flags.FFlagMomentsEngagementMetricsFeature
local fFlagProfileMomentSceneOutfitPoster = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfileMomentSceneOutfitPoster
local fFlagMomentsPostFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagMomentsPostFeedback
local PostStatusBadge = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Moments/PostStatusBadge")

local view = Foundation.View
local controlState = Foundation.Enums.ControlState
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useTokens = Foundation.Hooks.useTokens
local useSignalState = SignalsReact.useSignalState

local analytics = MomentsCommon.Analytics
local getMomentsCapabilities = MomentsCommon.Stores.GetMomentsCapabilities
local fireAnalyticsEvent = analytics.fireAnalyticsEvent
local eventNames = analytics.EventNames
local makeProfileTileFields = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/makeProfileTileFields")

local momentMediaTile = MomentsCommon.Media.MomentMediaTile
local gradientBackdrop = MomentsCommon.Components.GradientBackdrop

local thumbUp = BuilderIcons.Icon.ThumbUp

local function MomentGridItem(props)
	local moment = props.moment
	local onHoverChanged = props.onHoverChanged
	local v5 = useTokens()
	local v6

	if fFlagMomentsEngagementMetricsFeature then
		v6 = useSignalState(getMomentsCapabilities(false).getIsEngagementMetricsEnabled)
	end

	React.useEffect(function()
		local v7 = props.userId
			and moment.recommendationMetadata
			and makeProfileTileFields.makeProfileTileImpressionFields(moment, props.userId, "grid", props.index or 0)

		if v7 then
			fireAnalyticsEvent(eventNames.ProfileMomentTileImpression, v7)
		end
	end, {})

	local v7 = React.useMemo(function()
		return ToMediaItem({ kind = "moment", moment = moment })
	end, { moment.momentId })
	local v8 = if fFlagProfileMomentSceneOutfitPoster then useSceneOutfitMediaItem(moment, v7) else nil

	local v9 = React.useCallback(function(p2)
		onHoverChanged(p2 == controlState.Hover)
	end, { onHoverChanged })

	if not fFlagMomentsEngagementMetricsFeature or v6 then
		v6 = not (moment.metadata.likeCount == nil) and moment.metadata.likeCount > 0
	end

	local createElement = React.createElement
	local v11 = {
		Size = UDim2.fromScale(1, 1),
		onActivated = props.onActivated,
		onStateChanged = v9,
		stateLayer = { affordance = stateLayerAffordance.None },
		tag = "clip"
	}

	local createElement2 = React.createElement

	if v8 ~= nil then
		v7 = v8.mediaItem
	end

	local v12 = {
		Media = createElement2(momentMediaTile, {
			mediaItem = v7,
			isActive = props.isActive
		}),
		ScenePoster = 0,
		BottomGradient = 0,
		Engagement = 0,
		StatusBadge = 0
	}

	local v15 = if v8 ~= nil and v8.scenePoster ~= nil then React.createElement(SceneOutfitPoster, {
		content = v8.scenePoster,
		zIndex = 2
	}) else nil
	v12.ScenePoster = v15

	local v16 = if v6 then React.createElement(gradientBackdrop, {
		anchorPoint = Vector2.new(0, 1),
		color3 = v5.Color.Common.Scrim.Color3,
		position = UDim2.fromScale(0, 1),
		rotation = -90,
		size = UDim2.fromScale(1, 0.5),
		startingTransparency = 0,
		zIndex = fFlagProfileMomentSceneOutfitPoster and 3 or 2
	}) else nil
	v12.BottomGradient = v16

	local v17 = if v6 then React.createElement(view, {
		tag = "row align-x-right align-y-center gap-small position-bottom-right anchor-bottom-right auto-xy padding-small",
		ZIndex = fFlagProfileMomentSceneOutfitPoster and 4 or 3
	}, {
		Reactions = React.createElement(MomentEngagementCount, {
			layoutOrder = 1,
			icon = thumbUp,
			count = moment.metadata.likeCount,
			onMedia = true
		})
	}) else nil
	v12.Engagement = v17

	local v18 = if fFlagMomentsPostFeedback then React.createElement(PostStatusBadge, {
		momentId = moment.momentId,
		ZIndex = 5
	}) else nil
	v12.StatusBadge = v18
	return createElement(view, v11, v12)
end

return MomentGridItem
