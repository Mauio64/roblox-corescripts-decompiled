local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local BuilderIcons = require(MomentsCreationParent.BuilderIcons)
local Foundation = require(MomentsCreationParent.Foundation)
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)
local React = require(MomentsCreationParent.React)
local IconButton = Foundation.IconButton
local Skeleton = Foundation.Skeleton
local FoundationText = Foundation.Text
local View = Foundation.View
local PlayLarge = BuilderIcons.Icon.PlayLarge
local PauseLarge = BuilderIcons.Icon.PauseLarge
local MusicThumbnailIcon = MomentsCommon.Components.MusicThumbnailIcon
local RadialProgressBar = require(MomentsCreation.Components.RadialProgressBar)
local useBinding = React.useBinding
local useEffect = React.useEffect
local useMusicInfo = require(MomentsCreation.Hooks.useMusicInfo)
local MusicThumbnailIconSize = MomentsCommon.Enums.MusicThumbnailIconSize

local function MusicPreviewItem(t1: {[any]: any}) -- line: 41
	-- upvalues: useMusicInfo (copy), useBinding (copy), useEffect (copy), React (copy), Skeleton (copy), View (copy), MusicThumbnailIcon (copy), MusicThumbnailIconSize (copy), FoundationText (copy), IconButton (copy), PauseLarge (copy), PlayLarge (copy), Foundation (copy), RadialProgressBar (copy)
	local v21 = useMusicInfo(t1.musicAssetId)
	local v22, v23 = useBinding(t1.progress or 0)

	useEffect(function() -- line: 45
		-- upvalues: v23 (copy), t1 (copy)
		v23(t1.progress or 0)
	end, { t1.progress })

	local v24 = React.useCallback(function() -- line: 49
		-- upvalues: t1 (copy)
		if t1.onMusicSelected then
			t1.onMusicSelected(t1.musicAssetId)
		end
	end, {
		t1.onMusicSelected,
		t1.musicAssetId
	})
	local v25 = React.useCallback(function() -- line: 55
		-- upvalues: t1 (copy)
		if t1.togglePreviewMusic then
			t1.togglePreviewMusic(t1.musicAssetId)
		end
	end, {
		t1.togglePreviewMusic,
		t1.musicAssetId
	})

	if v21 == nil then
		return React.createElement(Skeleton, {
			Size = UDim2.new(1, 0, 0, 64)
		})
	end

	return React.createElement(View, {
		tag = "row align-x-left align-y-center gap-medium auto-y padding-x-xsmall padding-y-small radius-medium",
		LayoutOrder = t1.layoutOrder,
		onActivated = if not t1.onMusicSelected then nil else v24,
		Size = UDim2.fromScale(1, 0)
	}, {
		MusicThumbnail = React.createElement(MusicThumbnailIcon, {
			assetId = v21.AssetId,
			size = MusicThumbnailIconSize.Large
		}),
		MusicInfo = React.createElement(View, {
			LayoutOrder = 2,
			tag = "col shrink gap-xsmall size-full-0 auto-y"
		}, {
			Title = React.createElement(FoundationText, {
				tag = "auto-xy text-body-medium text-align-x-left text-align-y-top text-truncate-end content-emphasis",
				Text = v21.Title or ""
			}),
			Artist = React.createElement(FoundationText, {
				tag = "auto-xy text-body-small text-align-x-left text-align-y-top text-truncate-end content-neutral",
				Text = v21.Artist or ""
			})
		}),
		PlaybackButton = if not t1.togglePreviewMusic then nil else React.createElement(View, {
			LayoutOrder = 3,
			tag = "position-center-center anchor-center-center size-900-900 padding-xxsmall radius-circle clip"
		}, {
			PlaybackIndicator = React.createElement(IconButton, {
				isCircular = true,
				icon = if not t1.isPreviewing then PlayLarge else PauseLarge,
				onActivated = v25,
				size = Foundation.Enums.IconSize.Small,
				variant = Foundation.Enums.ButtonVariant.Standard
			}),
			ProgressBar = if t1.progress == nil then nil else React.createElement(RadialProgressBar, {
				progress = v22
			})
		})
	})
end

return MusicPreviewItem
