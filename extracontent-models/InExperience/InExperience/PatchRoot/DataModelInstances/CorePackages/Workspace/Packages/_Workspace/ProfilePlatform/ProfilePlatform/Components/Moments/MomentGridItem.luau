local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local BuilderIcons = require(Parent.BuilderIcons)
local MomentsCommon = require(Parent.MomentsCommon)

require(Parent.DataHydration.MomentsStoreTypes)

local ToMediaItem = require(Parent.Moments.ToMediaItem)
local MomentEngagementCount = require(script.Parent.MomentEngagementCount)
local FFlagProfileMomentsOrderingAndReactions = require(Parent.SharedFlags).FFlagProfileMomentsOrderingAndReactions
local View = Foundation.View
local ControlState = Foundation.Enums.ControlState
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useTokens = Foundation.Hooks.useTokens
local Analytics = MomentsCommon.Analytics
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent
local EventNames = Analytics.EventNames
local MomentMediaTile = MomentsCommon.Media.MomentMediaTile
local GradientBackdrop = MomentsCommon.Components.GradientBackdrop
local ThumbUp = BuilderIcons.Icon.ThumbUp

local function MomentGridItem(t1: {[any]: any}) -- line: 47
	-- upvalues: useTokens (copy), React (copy), fireAnalyticsEvent (copy), EventNames (copy), ToMediaItem (copy), ControlState (copy), FFlagProfileMomentsOrderingAndReactions (copy), View (copy), StateLayerAffordance (copy), MomentMediaTile (copy), GradientBackdrop (copy), MomentEngagementCount (copy), ThumbUp (copy)
	local moment = t1.moment
	local onHoverChanged = t1.onHoverChanged
	local v23 = useTokens()

	React.useEffect(function() -- line: 54
		-- upvalues: t1 (copy), moment (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if t1.userId and moment.recommendationMetadata then
			fireAnalyticsEvent(EventNames.ProfileMomentTileImpression, {
				userId = t1.userId,
				itemId = moment.recommendationMetadata.itemId or "",
				gridIndex = tostring(t1.index or 0)
			})
		end
	end, {})

	local v24 = React.useMemo(function() -- line: 67
		-- upvalues: ToMediaItem (copy), moment (copy)
		return (ToMediaItem({
			kind = "moment",
			moment = moment
		}))
	end, { moment.momentId })
	local v25 = React.useCallback(function(p1) -- line: 71
		-- upvalues: onHoverChanged (copy), ControlState (copy)
		onHoverChanged(p1 == ControlState.Hover)
	end, { onHoverChanged })
	local v26 = not FFlagProfileMomentsOrderingAndReactions or moment.metadata.likeCount ~= nil and moment.metadata.likeCount > 0

	return React.createElement(View, {
		tag = "clip",
		Size = UDim2.fromScale(1, 1),
		onActivated = t1.onActivated,
		onStateChanged = v25,
		stateLayer = {
			affordance = StateLayerAffordance.None
		}
	}, {
		Media = React.createElement(MomentMediaTile, {
			mediaItem = v24,
			isActive = t1.isActive
		}),
		BottomGradient = if not v26 then nil else React.createElement(GradientBackdrop, {
			rotation = -90,
			startingTransparency = 0,
			zIndex = 2,
			anchorPoint = Vector2.new(0, 1),
			color3 = v23.Color.Common.Scrim.Color3,
			position = UDim2.fromScale(0, 1),
			size = UDim2.fromScale(1, 0.5)
		}),
		Engagement = if not v26 then nil else React.createElement(View, {
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
