local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local BuilderIcons = require(parent.BuilderIcons)
local MomentsCommon = require(parent.MomentsCommon)
require(parent.DataHydration.MomentsStoreTypes)
local SignalsReact = require(parent.SignalsReact)
local ToMediaItem = require(parent.Moments.ToMediaItem)
local useSceneOutfitMediaItem = require(script.Parent.useSceneOutfitMediaItem)
local SceneOutfitPoster = require(script.Parent.SceneOutfitPoster)

local MomentEngagementCount = require(script.Parent.MomentEngagementCount)
local FFlagMomentsEngagementMetricsFeature = MomentsCommon.Flags.FFlagMomentsEngagementMetricsFeature
local SharedFlags = require(parent.SharedFlags)
local FFlagProfileMomentSceneOutfitPoster = SharedFlags.FFlagProfileMomentSceneOutfitPoster
local SharedFlags2 = require(parent.SharedFlags)
local FFlagMomentsPostFeedback = SharedFlags2.FFlagMomentsPostFeedback
local PostStatusBadge = require(parent.Moments.PostStatusBadge)

local View = Foundation.View
local ControlState = Foundation.Enums.ControlState
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useTokens = Foundation.Hooks.useTokens
local useSignalState = SignalsReact.useSignalState

local Analytics = MomentsCommon.Analytics
local GetMomentsCapabilities = MomentsCommon.Stores.GetMomentsCapabilities
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent
local EventNames = Analytics.EventNames
local makeProfileTileFields = require(ProfilePlatform.Analytics.makeProfileTileFields)

local MomentMediaTile = MomentsCommon.Media.MomentMediaTile
local GradientBackdrop = MomentsCommon.Components.GradientBackdrop

local ThumbUp = BuilderIcons.Icon.ThumbUp

local function MomentGridItem(props)
	local moment = props.moment
	local onHoverChanged = props.onHoverChanged
	local v = useTokens()
	local v2

	if FFlagMomentsEngagementMetricsFeature then
		v2 = useSignalState(GetMomentsCapabilities(false).getIsEngagementMetricsEnabled)
	end

	React.useEffect(function()
		local v3 = props.userId
			and moment.recommendationMetadata
			and makeProfileTileFields.makeProfileTileImpressionFields(moment, props.userId, "grid", props.index or 0)

		if v3 then
			fireAnalyticsEvent(EventNames.ProfileMomentTileImpression, v3)
		end
	end, {})

	local mediaItem = React.useMemo(function()
		return (ToMediaItem({ kind = "moment", moment = moment }))
	end, { moment.momentId })
	local v3

	if FFlagProfileMomentSceneOutfitPoster then
		v3 = useSceneOutfitMediaItem(moment, mediaItem)
	end

	local onStateChanged = React.useCallback(function(p)
		onHoverChanged(p == ControlState.Hover)
	end, { onHoverChanged })

	if not FFlagMomentsEngagementMetricsFeature or v2 then
		if moment.metadata.likeCount == nil then
			v2 = false
		else
			v2 = moment.metadata.likeCount > 0
		end
	end

	local createElement = React.createElement
	local v4 = {
		Size = UDim2.fromScale(1, 1),
		onActivated = props.onActivated,
		onStateChanged = onStateChanged,
		stateLayer = { affordance = StateLayerAffordance.None },
		tag = "clip"
	}

	local createElement2 = React.createElement

	if v3 ~= nil then
		mediaItem = v3.mediaItem
	end

	local v5 = {
		Media = createElement2(MomentMediaTile, { mediaItem = mediaItem, isActive = props.isActive }),
		ScenePoster = 0,
		BottomGradient = 0,
		Engagement = 0,
		StatusBadge = 0
	}
	local scenePoster

	if not (v3 == nil or v3.scenePoster == nil) then
		scenePoster = React.createElement(SceneOutfitPoster, {
			content = v3.scenePoster,
			zIndex = 2
		})
	end

	v5.ScenePoster = scenePoster
	local bottomGradient

	if v2 then
		bottomGradient = React.createElement(GradientBackdrop, {
			anchorPoint = Vector2.new(0, 1),
			color3 = v.Color.Common.Scrim.Color3,
			position = UDim2.fromScale(0, 1),
			rotation = -90,
			size = UDim2.fromScale(1, 0.5),
			startingTransparency = 0,
			zIndex = FFlagProfileMomentSceneOutfitPoster and 3 or 2
		})
	end

	v5.BottomGradient = bottomGradient
	local engagement

	if v2 then
		engagement = React.createElement(View, {
			tag = "row align-x-right align-y-center gap-small position-bottom-right anchor-bottom-right auto-xy padding-small",
			ZIndex = FFlagProfileMomentSceneOutfitPoster and 4 or 3
		}, {
			Reactions = React.createElement(MomentEngagementCount, {
				layoutOrder = 1,
				icon = ThumbUp,
				count = moment.metadata.likeCount,
				onMedia = true
			})
		})
	end

	v5.Engagement = engagement
	local statusBadge

	if FFlagMomentsPostFeedback then
		statusBadge = React.createElement(PostStatusBadge, {
			momentId = moment.momentId,
			ZIndex = 5
		})
	end

	v5.StatusBadge = statusBadge
	return createElement(View, v4, v5)
end

return MomentGridItem
