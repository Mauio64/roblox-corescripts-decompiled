local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Songbird = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Songbird")

local iconButton = Foundation.IconButton
local sheet = Foundation.Sheet
local text = Foundation.Text
local view = Foundation.View

local useLocalization = Localization.Hooks.useLocalization
local sendAudioPlayerAnalytics = Songbird.Analytics.sendAudioPlayerAnalytics
local analyticActions = Songbird.Analytics.AnalyticActions

local musicThumbnailIcon = MomentsCommon.Components.MusicThumbnailIcon
local musicThumbnailIconSize = MomentsCommon.Enums.MusicThumbnailIconSize
local fFlagMomentsAudioSaveButton = MomentsCommon.Flags.FFlagMomentsAudioSaveButton
local FFlagMomentsAudioSaveSongbirdAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsAudioSaveSongbirdAnalytics")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useMusicInfo")

local v5 = { title = "Feature.Moments.Label.Music" }

local function SaveButtonWithAnalytics(p2)
	local state, setState = React.useState(false)
	local v6 = React.useCallback(function()
		local v9 = if state then analyticActions.Unlike else analyticActions.Like
		sendAudioPlayerAnalytics({
			action = v9,
			songId = tostring(p2.assetId),
			thumbnailId = "-1",
			source = "moments"
		})

		setState(not state)
	end, { state, p2.assetId })

	local createElement = React.createElement
	local v9 = { name = BuilderIcons.Icon.Bookmark, variant = 0 }
	local v10 = if state then BuilderIcons.IconVariant.Filled else BuilderIcons.IconVariant.Regular
	v9.variant = v10
	return createElement(iconButton, {
		icon = v9,
		LayoutOrder = 3,
		onActivated = v6,
		size = Foundation.Enums.InputSize.Medium,
		testId = "MomentsMusicSaveButton"
	})
end

local function MusicModal(p2)
	local v6 = useLocalization(v5)
	local musicInfo = p2.musicInfo

	local createElement = React.createElement
	local root = sheet.Root
	local v7 = { isOpen = true, onClose = p2.onClose, preferCenterSheet = true }

	local v8 = {
		Header = React.createElement(sheet.Header, nil, {
			Title = React.createElement(text, {
				Text = v6.title,
				tag = "auto-xy text-heading-small content-emphasis"
			})
		}),
		Content = 0
	}

	local createElement2 = React.createElement
	local content = sheet.Content
	local createElement3 = React.createElement

	local v13 = {
		MusicThumbnail = React.createElement(musicThumbnailIcon, {
			assetId = musicInfo.AssetId,
			size = musicThumbnailIconSize.Large
		}),
		MusicInfo = 0,
		SaveButton = 0
	}

	local createElement4 = React.createElement

	local v16 = {
		Title = React.createElement(text, {
			tag = "auto-xy text-title-medium text-align-x-left text-align-y-top text-truncate-end content-emphasis",
			Text = musicInfo.Title or "",
			LayoutOrder = 1
		}),
		Artist = 0
	}

	local v17 = if musicInfo.Artist then React.createElement(text, {
		tag = "auto-xy text-body-small text-align-x-left text-align-y-top text-truncate-end content-neutral",
		Text = musicInfo.Artist,
		LayoutOrder = 2
	}) else nil
	v16.Artist = v17
	v13.MusicInfo = createElement4(
		view,
		{ tag = "col shrink gap-xsmall size-full-0 auto-y", LayoutOrder = 2 },
		v16
	)
	local v18

	if fFlagMomentsAudioSaveButton and FFlagMomentsAudioSaveSongbirdAnalytics then
		v18 = React.createElement(SaveButtonWithAnalytics, {
			assetId = musicInfo.AssetId
		})
	elseif fFlagMomentsAudioSaveButton then
		v18 = React.createElement(iconButton, {
			icon = BuilderIcons.Icon.Bookmark,
			LayoutOrder = 3,
			onActivated = function() end,
			size = Foundation.Enums.InputSize.Medium,
			testId = "MomentsMusicSaveButton"
		})
	end

	v13.SaveButton = v18
	v8.Content = createElement2(content, nil, {
		MusicInfoContainer = createElement3(
			view,
			{
				tag = "row align-y-center gap-medium size-full-0 auto-y padding-bottom-large"
			},
			v13
		)
	})
	return createElement(root, v7, v8)
end

return MusicModal
