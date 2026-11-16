local Songbird = script:FindFirstAncestor("Songbird")

local CoreGui = game:GetService("CoreGui")

local React = require(Songbird.Parent.React)
local ReactUtils = require(Songbird.Parent.ReactUtils)
local ReactRoblox = require(Songbird.Parent.ReactRoblox)
local Foundation = require(Songbird.Parent.Foundation)
local Localization = require(Songbird.Parent.Localization)

local CustomFoundationChip = require(Songbird.Components.CustomFoundationChip)
local AnalyticActions = require(Songbird.Analytics.AnalyticActions)
local sendAudioPlayerAnalytics = require(Songbird.Analytics.sendAudioPlayerAnalytics)
require(Songbird.types)
local ReportSongDialog = require(Songbird.Components.ReportSongDialog)

local SharedFlags = require(Songbird.Parent.SharedFlags)
local GetFFlagSongDetailsPageDesignPass = SharedFlags.GetFFlagSongDetailsPageDesignPass

local useLocalization = Localization.Hooks.useLocalization
local useCallback = React.useCallback
local useState = React.useState
local createNextOrder = ReactUtils.createNextOrder

local function AudioPlayerActions(props)
	local v = useLocalization({
		favorite = "Feature.SongDetails.Action.Favorite",
		report = "Feature.SongDetails.Action.Report"
	})

	local state, setState = useState(false)
	local nextOrder = createNextOrder()

	local v2 = useCallback(function(action)
		local songId = props.audio.assetId:gsub("rbxassetid://", "")
		local v2

		if props.audio.thumbnailAssetId then
			v2 = props.audio.thumbnailAssetId:gsub("rbxassetid://", "")
		end

		sendAudioPlayerAnalytics({
			action = action,
			songId = songId,
			thumbnailId = v2 or "-1",
			source = props.analyticsSource
		})
	end, {
		props.audio.assetId,
		props.audio.thumbnail,
		props.audio.thumbnailAssetId,
		props.analyticsSource
	})

	local onActivated = useCallback(function()
		if props.audio.isLiked then
			if props.onUnlike then
				v2(AnalyticActions.Unlike)
				props.onUnlike()
			end
		elseif props.onLike then
			v2(AnalyticActions.Like)
			props.onLike()
		end
	end, { props.audio.isLiked, props.onLike, props.onUnlike, v2 })

	local onActivated2 = useCallback(function()
		v2(AnalyticActions.StartAudioReport)
		setState(true)
	end, {})

	local v3 = useCallback(function()
		setState(false)
	end, {})

	local createElement = React.createElement
	local view = Foundation.View
	local v4 = { tag = "auto-xy row gap-small", LayoutOrder = props.LayoutOrder }
	local favorite

	if GetFFlagSongDetailsPageDesignPass() then
		local createElement2 = React.createElement
		local chip = Foundation.Chip
		local v5 = { text = v.favorite, leading = 0, onActivated = 0, LayoutOrder = 0 }
		local leading = { iconName = Foundation.Enums.IconName.Star, iconVariant = 0 }
		local iconVariant

		if props.audio.isLiked then
			iconVariant = Foundation.Enums.IconVariant.Filled
		end

		leading.iconVariant = iconVariant
		v5.leading = leading

		v5.onActivated = onActivated
		v5.LayoutOrder = nextOrder()
		favorite = createElement2(chip, v5)
	else
		favorite = React.createElement(CustomFoundationChip, {
			LayoutOrder = nextOrder(),
			text = v.favorite,
			icon = props.audio.isLiked and "icons/actions/favoriteOn" or "icons/actions/favoriteOff",
			onActivated = onActivated
		})
	end

	local report

	if GetFFlagSongDetailsPageDesignPass() then
		report = React.createElement(Foundation.Chip, {
			text = v.report,
			leading = { iconName = Foundation.Enums.IconName.Flag },
			onActivated = onActivated2,
			LayoutOrder = nextOrder()
		})
	else
		report = React.createElement(CustomFoundationChip, {
			LayoutOrder = nextOrder(),
			text = v.report,
			icon = "icons/actions/feedback",
			onActivated = onActivated2
		})
	end

	return createElement(view, v4, {
		Favorite = favorite,
		Report = report,
		ReportDialog = state and ReactRoblox.createPortal(
			React.createElement("ScreenGui", {
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				DisplayOrder = 2
			}, {
				Background = React.createElement(Foundation.View, {
					tag = "size-full row align-y-center align-x-center bg-over-media-100",
					stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
					onActivated = v3
				}, {
					Dialog = React.createElement(ReportSongDialog, {
						audio = props.audio,
						analyticsSource = props.analyticsSource or "unknown",
						onClose = v3
					})
				})
			}),
			CoreGui
		)
	})
end

return AudioPlayerActions
