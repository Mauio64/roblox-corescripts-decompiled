local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Foundation = require(ProfilePlatformParent.Foundation)
local BuilderIcons = require(ProfilePlatformParent.BuilderIcons)
local MomentsCommon = require(ProfilePlatformParent.MomentsCommon)

require(ProfilePlatformParent.DataHydration.MomentsStoreTypes)

local ToMediaItem = require(ProfilePlatformParent.Moments.ToMediaItem)
local MomentEngagementCount = require(script.Parent.MomentEngagementCount)
local FFlagProfileMomentsOrderingAndReactions = require(ProfilePlatformParent.SharedFlags).FFlagProfileMomentsOrderingAndReactions
local View = Foundation.View
local ControlState = Foundation.Enums.ControlState
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useTokens = Foundation.Hooks.useTokens
local Analytics = MomentsCommon.Analytics
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent
local EventNames = Analytics.EventNames
local makeProfileTileFields = require(ProfilePlatform.Analytics.makeProfileTileFields)
local MomentMediaTile = MomentsCommon.Media.MomentMediaTile
local GradientBackdrop = MomentsCommon.Components.GradientBackdrop
local ThumbUp = BuilderIcons.Icon.ThumbUp

local function MomentGridItem(t1: {[any]: any}) -- line: 48
	-- upvalues: useTokens (copy), React (copy), makeProfileTileFields (copy), fireAnalyticsEvent (copy), EventNames (copy), ToMediaItem (copy), ControlState (copy), FFlagProfileMomentsOrderingAndReactions (copy), View (copy), StateLayerAffordance (copy), MomentMediaTile (copy), GradientBackdrop (copy), MomentEngagementCount (copy), ThumbUp (copy)
	local moment = t1.moment
	local onHoverChanged = t1.onHoverChanged
	local v25 = useTokens()

	React.useEffect(function() -- line: 55
		-- upvalues: t1 (copy), moment (copy), makeProfileTileFields (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if t1.userId and moment.recommendationMetadata then
			local v29 = makeProfileTileFields.makeProfileTileImpressionFields(moment, t1.userId, "grid", t1.index or 0)

			if v29 then
				fireAnalyticsEvent(EventNames.ProfileMomentTileImpression, v29)
			end
		end
	end, {})

	local v26 = React.useMemo(function() -- line: 69
		-- upvalues: ToMediaItem (copy), moment (copy)
		return (ToMediaItem({
			kind = "moment",
			moment = moment
		}))
	end, { moment.momentId })
	local v27 = React.useCallback(function(p1) -- line: 73
		-- upvalues: onHoverChanged (copy), ControlState (copy)
		onHoverChanged(p1 == ControlState.Hover)
	end, { onHoverChanged })
	local v28 = not FFlagProfileMomentsOrderingAndReactions or moment.metadata.likeCount ~= nil and moment.metadata.likeCount > 0

	return React.createElement(View, {
		tag = "clip",
		Size = UDim2.fromScale(1, 1),
		onActivated = t1.onActivated,
		onStateChanged = v27,
		stateLayer = {
			affordance = StateLayerAffordance.None
		}
	}, {
		Media = React.createElement(MomentMediaTile, {
			mediaItem = v26,
			isActive = t1.isActive
		}),
		BottomGradient = if not v28 then nil else React.createElement(GradientBackdrop, {
			rotation = -90,
			startingTransparency = 0,
			zIndex = 2,
			anchorPoint = Vector2.new(0, 1),
			color3 = v25.Color.Common.Scrim.Color3,
			position = UDim2.fromScale(0, 1),
			size = UDim2.fromScale(1, 0.5)
		}),
		Engagement = if not v28 then nil else React.createElement(View, {
			tag = "row align-x-right align-y-center gap-small position-bottom-right anchor-bottom-right auto-xy padding-small",
			ZIndex = 3
		}, {
			Reactions = React.createElement(MomentEngagementCount, {
				layoutOrder = 1,
				onMedia = true,
				icon = ThumbUp,
				count = moment.metadata.likeCount
			})
		})
	})
end

return MomentGridItem
