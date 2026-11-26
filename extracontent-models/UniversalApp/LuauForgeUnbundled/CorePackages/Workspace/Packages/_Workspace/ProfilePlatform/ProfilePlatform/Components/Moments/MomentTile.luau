local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/MomentsCommon")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/DataHydration/MomentsStoreTypes")
local ToMediaItem = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Moments/ToMediaItem")
local useSceneOutfitMediaItem = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Moments/useSceneOutfitMediaItem")
local SceneOutfitPoster = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Moments/SceneOutfitPoster")
local fFlagProfileMomentSceneOutfitPoster = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfileMomentSceneOutfitPoster
local fFlagMomentsPostFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagMomentsPostFeedback
local PostStatusBadge = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Moments/PostStatusBadge")

local useExperienceName = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useExperienceName")

local view = Foundation.View
local text = Foundation.Text
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useTokens = Foundation.Hooks.useTokens

local momentMediaTile = MomentsCommon.Media.MomentMediaTile

local function MomentTile(props)
	local moment = props.moment
	local v5 = useTokens()

	local v6 = useExperienceName(moment.metadata.universeId)

	local v7 = React.useMemo(function()
		local v8 = ToMediaItem({ kind = "moment", moment = moment })

		v8.cornerRadius = v5.Radius.Large
		return v8
	end, { moment.momentId })
	local v8 = if fFlagProfileMomentSceneOutfitPoster then useSceneOutfitMediaItem(moment, v7) else nil

	local createElement = React.createElement
	local v10 = {
		LayoutOrder = props.layoutOrder,
		Size = props.itemSize,
		onActivated = props.onActivated,
		stateLayer = { affordance = stateLayerAffordance.None },
		tag = "col gap-xsmall"
	}

	local createElement2 = React.createElement
	local v12 = {
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, -48 - v5.Gap.XSmall),
		ClipsDescendants = true
	}

	local v13 = {
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v5.Radius.Large)
		}),
		Media = 0,
		ScenePoster = 0,
		StatusBadge = 0
	}

	local createElement3 = React.createElement

	if v8 ~= nil then
		v7 = v8.mediaItem
	end

	v13.Media = createElement3(momentMediaTile, {
		mediaItem = v7,
		isActive = props.isActive
	})

	local v16 = if v8 ~= nil and v8.scenePoster ~= nil then React.createElement(SceneOutfitPoster, {
		content = v8.scenePoster,
		cornerRadius = v5.Radius.Large,
		zIndex = 2
	}) else nil
	v13.ScenePoster = v16

	local v17 = if fFlagMomentsPostFeedback then React.createElement(PostStatusBadge, {
		momentId = moment.momentId,
		ZIndex = 3
	}) else nil
	v13.StatusBadge = v17
	return createElement(view, v10, {
		MediaContainer = createElement2("Frame", v12, v13),
		Footer = React.createElement(
			view,
			{
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 48),
				tag = "col align-x-left align-y-top gap-xxsmall"
			},
			{
				Title = React.createElement(text, {
					LayoutOrder = 1,
					tag = "size-full-0 auto-y text-align-x-left text-truncate-end",
					fontStyle = v5.Typography.TitleMedium,
					textStyle = v5.Color.Content.Emphasis,
					Text = moment.metadata.experienceName or v6 or ""
				})
			}
		)
	})
end

return MomentTile
