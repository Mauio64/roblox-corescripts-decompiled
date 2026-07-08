local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local MomentsCreationFlowParent = MomentsCreationFlow.Parent
local BuilderIcons = require(MomentsCreationFlowParent.BuilderIcons)
local Foundation = require(MomentsCreationFlowParent.Foundation)
local MomentsCommon = require(MomentsCreationFlowParent.MomentsCommon)
local React = require(MomentsCreationFlowParent.React)
local IconButton = Foundation.IconButton
local Skeleton = Foundation.Skeleton
local FoundationText = Foundation.Text
local View = Foundation.View
local PlayLarge = BuilderIcons.Icon.PlayLarge
local PauseLarge = BuilderIcons.Icon.PauseLarge
local MusicThumbnailIcon = MomentsCommon.MusicThumbnailIcon
local RadialProgressBar = require(MomentsCreationFlow.Components.RadialProgressBar)
local useBinding = React.useBinding
local useEffect = React.useEffect
local useMusicInfo = require(MomentsCreationFlow.Hooks.useMusicInfo)
local MusicThumbnailIconSize = MomentsCommon.Enums.MusicThumbnailIconSize

return function(t1: {[any]: any}) -- line: 36
	-- upvalues: useMusicInfo (copy), useBinding (copy), useEffect (copy), React (copy), Skeleton (copy), View (copy), MusicThumbnailIcon (copy), MusicThumbnailIconSize (copy), FoundationText (copy), IconButton (copy), PauseLarge (copy), PlayLarge (copy), Foundation (copy), RadialProgressBar (copy)
	local v20 = useMusicInfo(t1.musicAssetId)
	local v21, v22 = useBinding(t1.progress or 0)

	useEffect(function() -- line: 40
		-- upvalues: v22 (copy), t1 (copy)
		v22(t1.progress or 0)
	end, { t1.progress })

	local v23 = React.useCallback(function() -- line: 44
		-- upvalues: t1 (copy)
		if t1.onMusicSelected then
			t1.onMusicSelected(t1.musicAssetId)
		end
	end, {
		t1.onMusicSelected,
		t1.musicAssetId
	})
	local v24 = React.useCallback(function() -- line: 50
		-- upvalues: t1 (copy)
		if t1.togglePreviewMusic then
			t1.togglePreviewMusic(t1.musicAssetId)
		end
	end, {
		t1.togglePreviewMusic,
		t1.musicAssetId
	})

	if not v20 then
		return React.createElement(Skeleton, {
			Size = UDim2.new(1, 0, 0, 64)
		})
	end

	return React.createElement(View, {
		tag = "align-x-left align-y-center auto-y row gap-medium padding-x-xsmall padding-y-small radius-medium",
		LayoutOrder = t1.layoutOrder,
		onActivated = if not t1.onMusicSelected then nil else v23,
		Size = UDim2.fromScale(1, 0)
	}, {
		MusicThumbnail = React.createElement(MusicThumbnailIcon, {
			assetId = v20.AssetId,
			size = MusicThumbnailIconSize.Large
		}),
		MusicInfo = React.createElement(View, {
			LayoutOrder = 2,
			tag = "auto-y col gap-xsmall size-full-0 shrink"
		}, {
			Title = React.createElement(FoundationText, {
				tag = "auto-xy text-body-medium content-emphasis text-truncate-end text-align-x-left text-align-y-top",
				Text = v20.Title
			}),
			Artist = React.createElement(FoundationText, {
				tag = "auto-xy text-body-small content-neutral text-truncate-end text-align-x-left text-align-y-top",
				Text = v20.Artist
			})
		}),
		PlaybackButton = if not t1.togglePreviewMusic then nil else React.createElement(View, {
			LayoutOrder = 3,
			tag = "anchor-center-center clip position-center-center radius-circle size-900-900 padding-xxsmall"
		}, {
			PlaybackIndicator = React.createElement(IconButton, {
				isCircular = true,
				icon = if not t1.isPreviewing then PlayLarge else PauseLarge,
				onActivated = v24,
				size = Foundation.Enums.IconSize.Small,
				variant = Foundation.Enums.ButtonVariant.Standard
			}),
			ProgressBar = if not t1.progress then nil else React.createElement(RadialProgressBar, {
				progress = v21
			})
		})
	})
end
