local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local iconButton = Foundation.IconButton
local skeleton = Foundation.Skeleton
local text = Foundation.Text
local view = Foundation.View

local playLarge = BuilderIcons.Icon.PlayLarge
local pauseLarge = BuilderIcons.Icon.PauseLarge

local musicThumbnailIcon = MomentsCommon.Components.MusicThumbnailIcon
local RadialProgressBar = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/RadialProgressBar")

local useBinding = React.useBinding
local useEffect = React.useEffect
local useMusicInfo = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useMusicInfo")

local musicThumbnailIconSize = MomentsCommon.Enums.MusicThumbnailIconSize

local function MusicPreviewItem(props)
	local v5 = useMusicInfo(props.musicAssetId)
	local v6, v7 = useBinding(props.progress or 0)

	useEffect(function()
		v7(props.progress or 0)
	end, { props.progress })

	local v8 = React.useCallback(function()
		if props.onMusicSelected then
			props.onMusicSelected(props.musicAssetId)
		end
	end, { props.onMusicSelected, props.musicAssetId })

	local v9 = React.useCallback(function()
		if props.togglePreviewMusic then
			props.togglePreviewMusic(props.musicAssetId)
		end
	end, { props.togglePreviewMusic, props.musicAssetId })

	if v5 == nil then
		return React.createElement(skeleton, { Size = UDim2.new(1, 0, 0, 64) })
	end

	local createElement = React.createElement
	local v11 = {
		LayoutOrder = props.layoutOrder,
		onActivated = 0,
		tag = "row align-x-left align-y-center gap-medium auto-y padding-x-xsmall padding-y-small radius-medium",
		Size = 0
	}

	if not props.onMusicSelected then
		v8 = nil
	end

	v11.onActivated = v8

	v11.Size = UDim2.fromScale(1, 0)
	local v12 = {
		MusicThumbnail = React.createElement(musicThumbnailIcon, {
			assetId = v5.AssetId,
			size = musicThumbnailIconSize.Large
		}),
		MusicInfo = React.createElement(
			view,
			{ LayoutOrder = 2, tag = "col shrink gap-xsmall size-full-0 auto-y" },
			{
				Title = React.createElement(text, {
					Text = v5.Title or "",
					tag = "auto-xy text-body-medium text-align-x-left text-align-y-top text-truncate-end content-emphasis"
				}),
				Artist = React.createElement(text, {
					Text = v5.Artist or "",
					tag = "auto-xy text-body-small text-align-x-left text-align-y-top text-truncate-end content-neutral"
				})
			}
		),
		PlaybackButton = 0
	}
	local v13

	if props.togglePreviewMusic then
		local createElement2 = React.createElement

		local createElement3 = React.createElement
		local v19 = if props.isPreviewing then pauseLarge else playLarge
		local v16 = {
			PlaybackIndicator = createElement3(iconButton, {
				icon = v19,
				isCircular = true,
				onActivated = v9,
				size = Foundation.Enums.IconSize.Small,
				variant = Foundation.Enums.ButtonVariant.Standard
			}),
			ProgressBar = 0
		}

		local v20 = if props.progress ~= nil then React.createElement(RadialProgressBar, {
			progress = v6
		}) else nil
		v16.ProgressBar = v20
		v13 = createElement2(
			view,
			{
				LayoutOrder = 3,
				tag = "position-center-center anchor-center-center size-900-900 padding-xxsmall radius-circle clip"
			},
			v16
		)
	end

	v12.PlaybackButton = v13
	return createElement(view, v11, v12)
end

return MusicPreviewItem
