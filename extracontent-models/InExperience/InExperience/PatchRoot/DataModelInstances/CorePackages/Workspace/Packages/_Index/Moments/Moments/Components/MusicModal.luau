local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local Songbird = require(parent.Songbird)

local IconButton = Foundation.IconButton
local Sheet = Foundation.Sheet
local Text = Foundation.Text
local View = Foundation.View

local useLocalization = Localization.Hooks.useLocalization
local sendAudioPlayerAnalytics = Songbird.Analytics.sendAudioPlayerAnalytics
local AnalyticActions = Songbird.Analytics.AnalyticActions

local MusicThumbnailIcon = MomentsCommon.Components.MusicThumbnailIcon
local MusicThumbnailIconSize = MomentsCommon.Enums.MusicThumbnailIconSize
local FFlagMomentsAudioSaveButton = MomentsCommon.Flags.FFlagMomentsAudioSaveButton
local FFlagMomentsAudioSaveSongbirdAnalytics = require(Moments.Flags.FFlagMomentsAudioSaveSongbirdAnalytics)

require(Moments.Hooks.useMusicInfo)

local v = { title = "Feature.Moments.Label.Music" }

local function SaveButtonWithAnalytics(p)
	local state, setState = React.useState(false)
	local onActivated = React.useCallback(function()
		local action

		if state then
			action = AnalyticActions.Unlike
		else
			action = AnalyticActions.Like
		end

		sendAudioPlayerAnalytics({
			action = action,
			songId = tostring(p.assetId),
			thumbnailId = "-1",
			source = "moments"
		})

		setState(not state)
	end, { state, p.assetId })

	local createElement = React.createElement
	local icon = { name = BuilderIcons.Icon.Bookmark, variant = 0 }
	local variant

	if state then
		variant = BuilderIcons.IconVariant.Filled
	else
		variant = BuilderIcons.IconVariant.Regular
	end

	icon.variant = variant
	return createElement(IconButton, {
		icon = icon,
		LayoutOrder = 3,
		onActivated = onActivated,
		size = Foundation.Enums.InputSize.Medium,
		testId = "MomentsMusicSaveButton"
	})
end

local function MusicModal(p)
	local v2 = useLocalization(v)
	local musicInfo = p.musicInfo

	local createElement = React.createElement
	local root = Sheet.Root
	local v3 = { isOpen = true, onClose = p.onClose, preferCenterSheet = true }

	local v4 = {
		Header = React.createElement(Sheet.Header, nil, {
			Title = React.createElement(Text, {
				Text = v2.title,
				tag = "auto-xy text-heading-small content-emphasis"
			})
		}),
		Content = 0
	}

	local createElement2 = React.createElement
	local content = Sheet.Content
	local createElement3 = React.createElement

	local v5 = {
		MusicThumbnail = React.createElement(MusicThumbnailIcon, {
			assetId = musicInfo.AssetId,
			size = MusicThumbnailIconSize.Large
		}),
		MusicInfo = 0,
		SaveButton = 0
	}

	local createElement4 = React.createElement

	local v6 = {
		Title = React.createElement(Text, {
			tag = "auto-xy text-title-medium text-align-x-left text-align-y-top text-truncate-end content-emphasis",
			Text = musicInfo.Title or "",
			LayoutOrder = 1
		}),
		Artist = 0
	}
	local artist

	if musicInfo.Artist then
		artist = React.createElement(Text, {
			tag = "auto-xy text-body-small text-align-x-left text-align-y-top text-truncate-end content-neutral",
			Text = musicInfo.Artist,
			LayoutOrder = 2
		})
	end

	v6.Artist = artist
	v5.MusicInfo = createElement4(View, {
		tag = "col shrink gap-xsmall size-full-0 auto-y",
		LayoutOrder = 2
	}, v6)
	local saveButton

	if FFlagMomentsAudioSaveButton and FFlagMomentsAudioSaveSongbirdAnalytics then
		saveButton = React.createElement(SaveButtonWithAnalytics, { assetId = musicInfo.AssetId })
	elseif FFlagMomentsAudioSaveButton then
		saveButton = React.createElement(IconButton, {
			icon = BuilderIcons.Icon.Bookmark,
			LayoutOrder = 3,
			onActivated = function() end,
			size = Foundation.Enums.InputSize.Medium,
			testId = "MomentsMusicSaveButton"
		})
	end

	v5.SaveButton = saveButton
	v4.Content = createElement2(content, nil, {
		MusicInfoContainer = createElement3(
			View,
			{ tag = "row align-y-center gap-medium size-full-0 auto-y padding-bottom-large" },
			v5
		)
	})
	return createElement(root, v3, v4)
end

return MusicModal
