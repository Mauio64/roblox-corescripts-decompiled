local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
require(parent.DataHydration.MomentsStoreTypes)
local ToMediaItem = require(parent.Moments.ToMediaItem)
local useSceneOutfitMediaItem = require(script.Parent.useSceneOutfitMediaItem)
local SceneOutfitPoster = require(script.Parent.SceneOutfitPoster)
local SharedFlags = require(parent.SharedFlags)
local FFlagProfileMomentSceneOutfitPoster = SharedFlags.FFlagProfileMomentSceneOutfitPoster
local SharedFlags2 = require(parent.SharedFlags)
local FFlagMomentsPostFeedback = SharedFlags2.FFlagMomentsPostFeedback
local PostStatusBadge = require(parent.Moments.PostStatusBadge)

local useExperienceName = require(ProfilePlatform.Hooks.useExperienceName)

local View = Foundation.View
local Text = Foundation.Text
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useTokens = Foundation.Hooks.useTokens

local MomentMediaTile = MomentsCommon.Media.MomentMediaTile

local function MomentTile(props)
	local moment = props.moment
	local v = useTokens()

	local v2 = useExperienceName(moment.metadata.universeId)

	local mediaItem = React.useMemo(function()
		local toMediaItem = ToMediaItem({ kind = "moment", moment = moment })

		toMediaItem.cornerRadius = v.Radius.Large
		return toMediaItem
	end, { moment.momentId })
	local v3

	if FFlagProfileMomentSceneOutfitPoster then
		v3 = useSceneOutfitMediaItem(moment, mediaItem)
	end

	local createElement = React.createElement
	local v4 = {
		LayoutOrder = props.layoutOrder,
		Size = props.itemSize,
		onActivated = props.onActivated,
		stateLayer = { affordance = StateLayerAffordance.None },
		tag = "col gap-xsmall"
	}

	local createElement2 = React.createElement
	local v5 = {
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, -48 - v.Gap.XSmall),
		ClipsDescendants = true
	}

	local v6 = {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, v.Radius.Large) }),
		Media = 0,
		ScenePoster = 0,
		StatusBadge = 0
	}

	local createElement3 = React.createElement

	if v3 ~= nil then
		mediaItem = v3.mediaItem
	end

	v6.Media = createElement3(MomentMediaTile, { mediaItem = mediaItem, isActive = props.isActive })
	local scenePoster

	if not (v3 == nil or v3.scenePoster == nil) then
		scenePoster = React.createElement(SceneOutfitPoster, {
			content = v3.scenePoster,
			cornerRadius = v.Radius.Large,
			zIndex = 2
		})
	end

	v6.ScenePoster = scenePoster
	local statusBadge

	if FFlagMomentsPostFeedback then
		statusBadge = React.createElement(PostStatusBadge, {
			momentId = moment.momentId,
			ZIndex = 3
		})
	end

	v6.StatusBadge = statusBadge
	return createElement(View, v4, {
		MediaContainer = createElement2("Frame", v5, v6),
		Footer = React.createElement(
			View,
			{
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 48),
				tag = "col align-x-left align-y-top gap-xxsmall"
			},
			{
				Title = React.createElement(Text, {
					LayoutOrder = 1,
					tag = "size-full-0 auto-y text-align-x-left text-truncate-end",
					fontStyle = v.Typography.TitleMedium,
					textStyle = v.Color.Content.Emphasis,
					Text = moment.metadata.experienceName or v2 or ""
				})
			}
		)
	})
end

return MomentTile
