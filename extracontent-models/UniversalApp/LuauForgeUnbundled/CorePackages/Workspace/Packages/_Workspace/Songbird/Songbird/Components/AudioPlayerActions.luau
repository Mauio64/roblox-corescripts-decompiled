local CoreGui = game:GetService("CoreGui")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/React")
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/ReactUtils")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/ReactRoblox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Localization")

local CustomFoundationChip = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Components/CustomFoundationChip")
local AnalyticActions = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Analytics/AnalyticActions")
local sendAudioPlayerAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Analytics/sendAudioPlayerAnalytics")
require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/types")
local ReportSongDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Components/ReportSongDialog")

local getFFlagSongDetailsPageDesignPass = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/SharedFlags").GetFFlagSongDetailsPageDesignPass

local useLocalization = Localization.Hooks.useLocalization
local useCallback = React.useCallback
local useState = React.useState
local createNextOrder = ReactUtils.createNextOrder

local function AudioPlayerActions(props)
	local v5 = useLocalization({
		favorite = "Feature.SongDetails.Action.Favorite",
		report = "Feature.SongDetails.Action.Report"
	})

	local state, setState = useState(false)
	local nextOrder = createNextOrder()

	local v6 = useCallback(function(p2)
		local v7 = props.audio.assetId:gsub("rbxassetid://", "")
		local v8 = if props.audio.thumbnailAssetId then props.audio.thumbnailAssetId:gsub("rbxassetid://", "") else nil

		sendAudioPlayerAnalytics({
			action = p2,
			songId = v7,
			thumbnailId = v8 or "-1",
			source = props.analyticsSource
		})
	end, {
		props.audio.assetId,
		props.audio.thumbnail,
		props.audio.thumbnailAssetId,
		props.analyticsSource
	})

	local v7 = useCallback(function()
		if props.audio.isLiked then
			if props.onUnlike then
				v6(AnalyticActions.Unlike)
				props.onUnlike()
			end
		elseif props.onLike then
			v6(AnalyticActions.Like)
			props.onLike()
		end
	end, { props.audio.isLiked, props.onLike, props.onUnlike, v6 })

	local v8 = useCallback(function()
		v6(AnalyticActions.StartAudioReport)
		setState(true)
	end, {})

	local v9 = useCallback(function()
		setState(false)
	end, {})

	local createElement = React.createElement
	local view = Foundation.View
	local v10 = { tag = "auto-xy row gap-small", LayoutOrder = props.LayoutOrder }
	local v12

	if getFFlagSongDetailsPageDesignPass() then
		local createElement2 = React.createElement
		local chip = Foundation.Chip
		local v13 = {
			text = v5.favorite,
			leading = 0,
			onActivated = 0,
			LayoutOrder = 0
		}
		local v14 = { iconName = Foundation.Enums.IconName.Star, iconVariant = 0 }
		local v15 = if props.audio.isLiked then Foundation.Enums.IconVariant.Filled else nil
		v14.iconVariant = v15
		v13.leading = v14

		v13.onActivated = v7
		v13.LayoutOrder = nextOrder()
		v12 = createElement2(chip, v13)
	else
		v12 = React.createElement(CustomFoundationChip, {
			LayoutOrder = nextOrder(),
			text = v5.favorite,
			icon = props.audio.isLiked and "icons/actions/favoriteOn" or "icons/actions/favoriteOff",
			onActivated = v7
		})
	end

	local v13 = if getFFlagSongDetailsPageDesignPass() then React.createElement(Foundation.Chip, {
		text = v5.report,
		leading = { iconName = Foundation.Enums.IconName.Flag },
		onActivated = v8,
		LayoutOrder = nextOrder()
	}) else React.createElement(CustomFoundationChip, {
		LayoutOrder = nextOrder(),
		text = v5.report,
		icon = "icons/actions/feedback",
		onActivated = v8
	})
	return createElement(view, v10, {
		Favorite = v12,
		Report = v13,
		ReportDialog = state and ReactRoblox.createPortal(
			React.createElement(
				"ScreenGui",
				{ ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 2 },
				{
					Background = React.createElement(Foundation.View, {
						tag = "size-full row align-y-center align-x-center bg-over-media-100",
						stateLayer = {
							affordance = Foundation.Enums.StateLayerAffordance.None
						},
						onActivated = v9
					}, {
						Dialog = React.createElement(ReportSongDialog, {
							audio = props.audio,
							analyticsSource = props.analyticsSource or "unknown",
							onClose = v9
						})
					})
				}
			),
			CoreGui
		)
	})
end

return AudioPlayerActions
