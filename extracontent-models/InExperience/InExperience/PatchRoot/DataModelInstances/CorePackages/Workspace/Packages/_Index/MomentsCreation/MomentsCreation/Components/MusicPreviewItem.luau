local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local IconButton = Foundation.IconButton
local Skeleton = Foundation.Skeleton
local Text = Foundation.Text
local View = Foundation.View

local PlayLarge = BuilderIcons.Icon.PlayLarge
local PauseLarge = BuilderIcons.Icon.PauseLarge

local MusicThumbnailIcon = MomentsCommon.Components.MusicThumbnailIcon
local RadialProgressBar = require(MomentsCreation.Components.RadialProgressBar)

local useBinding = React.useBinding
local useEffect = React.useEffect
local useMusicInfo = require(MomentsCreation.Hooks.useMusicInfo)

local MusicThumbnailIconSize = MomentsCommon.Enums.MusicThumbnailIconSize

local function MusicPreviewItem(props)
	local v = useMusicInfo(props.musicAssetId)
	local progress, v2 = useBinding(props.progress or 0)

	useEffect(function()
		v2(props.progress or 0)
	end, { props.progress })

	local onActivated = React.useCallback(function()
		if props.onMusicSelected then
			props.onMusicSelected(props.musicAssetId)
		end
	end, { props.onMusicSelected, props.musicAssetId })

	local onActivated2 = React.useCallback(function()
		if props.togglePreviewMusic then
			props.togglePreviewMusic(props.musicAssetId)
		end
	end, { props.togglePreviewMusic, props.musicAssetId })

	if v == nil then
		return React.createElement(Skeleton, { Size = UDim2.new(1, 0, 0, 64) })
	end

	local createElement = React.createElement
	local v3 = {
		LayoutOrder = props.layoutOrder,
		onActivated = 0,
		tag = "row align-x-left align-y-center gap-medium auto-y padding-x-xsmall padding-y-small radius-medium",
		Size = 0
	}

	if not props.onMusicSelected then
		onActivated = nil
	end

	v3.onActivated = onActivated

	v3.Size = UDim2.fromScale(1, 0)
	local v4 = {
		MusicThumbnail = React.createElement(MusicThumbnailIcon, {
			assetId = v.AssetId,
			size = MusicThumbnailIconSize.Large
		}),
		MusicInfo = React.createElement(View, {
			LayoutOrder = 2,
			tag = "col shrink gap-xsmall size-full-0 auto-y"
		}, {
			Title = React.createElement(Text, {
				Text = v.Title or "",
				tag = "auto-xy text-body-medium text-align-x-left text-align-y-top text-truncate-end content-emphasis"
			}),
			Artist = React.createElement(Text, {
				Text = v.Artist or "",
				tag = "auto-xy text-body-small text-align-x-left text-align-y-top text-truncate-end content-neutral"
			})
		}),
		PlaybackButton = 0
	}
	local playbackButton

	if props.togglePreviewMusic then
		local createElement2 = React.createElement

		local createElement3 = React.createElement
		local icon

		if props.isPreviewing then
			icon = PauseLarge
		else
			icon = PlayLarge
		end

		local v5 = {
			PlaybackIndicator = createElement3(IconButton, {
				icon = icon,
				isCircular = true,
				onActivated = onActivated2,
				size = Foundation.Enums.IconSize.Small,
				variant = Foundation.Enums.ButtonVariant.Standard
			}),
			ProgressBar = 0
		}
		local progressBar

		if props.progress ~= nil then
			progressBar = React.createElement(RadialProgressBar, { progress = progress })
		end

		v5.ProgressBar = progressBar
		playbackButton = createElement2(
			View,
			{
				LayoutOrder = 3,
				tag = "position-center-center anchor-center-center size-900-900 padding-xxsmall radius-circle clip"
			},
			v5
		)
	end

	v4.PlaybackButton = playbackButton
	return createElement(View, v3, v4)
end

return MusicPreviewItem
