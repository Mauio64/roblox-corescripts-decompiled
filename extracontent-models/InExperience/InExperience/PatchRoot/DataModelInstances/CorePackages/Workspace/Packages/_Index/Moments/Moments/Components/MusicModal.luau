local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Foundation = require(MomentsParent.Foundation)
local Localization = require(MomentsParent.Localization)
local MomentsCommon = require(MomentsParent.MomentsCommon)
local React = require(MomentsParent.React)
local Sheet = Foundation.Sheet
local FoundationText = Foundation.Text
local View = Foundation.View
local useLocalization = Localization.Hooks.useLocalization
local MusicThumbnailIcon = MomentsCommon.Components.MusicThumbnailIcon
local MusicThumbnailIconSize = MomentsCommon.Enums.MusicThumbnailIconSize

require(Moments.Hooks.useMusicInfo)

local t1 = {
	title = "Feature.Moments.Label.Music"
}

local function MusicModal(t2: {[any]: any}) -- line: 30
	-- upvalues: useLocalization (copy), t1 (copy), React (copy), Sheet (copy), FoundationText (copy), View (copy), MusicThumbnailIcon (copy), MusicThumbnailIconSize (copy)
	local v16 = useLocalization(t1)
	local musicInfo = t2.musicInfo

	return React.createElement(Sheet.Root, {
		isOpen = true,
		preferCenterSheet = true,
		onClose = t2.onClose
	}, {
		Header = React.createElement(Sheet.Header, nil, {
			Title = React.createElement(FoundationText, {
				tag = "auto-xy text-heading-small content-emphasis",
				Text = v16.title
			})
		}),
		Content = React.createElement(Sheet.Content, nil, {
			MusicInfoContainer = React.createElement(View, {
				tag = "row align-y-center gap-medium size-full-0 auto-y padding-bottom-large"
			}, {
				MusicThumbnail = React.createElement(MusicThumbnailIcon, {
					assetId = musicInfo.AssetId,
					size = MusicThumbnailIconSize.Large
				}),
				MusicInfo = React.createElement(View, {
					tag = "col shrink gap-xsmall size-full-0 auto-y",
					LayoutOrder = 2
				}, {
					Title = React.createElement(FoundationText, {
						tag = "auto-xy text-title-medium text-align-x-left text-align-y-top text-truncate-end content-emphasis",
						LayoutOrder = 1,
						Text = musicInfo.Title or ""
					}),
					Artist = if not musicInfo.Artist then nil else React.createElement(FoundationText, {
						tag = "auto-xy text-body-small text-align-x-left text-align-y-top text-truncate-end content-neutral",
						LayoutOrder = 2,
						Text = musicInfo.Artist
					})
				})
			})
		})
	})
end

return MusicModal
