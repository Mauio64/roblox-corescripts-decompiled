local MusicPicker = script:FindFirstAncestor("MusicPicker")
local parent = MusicPicker.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)

local Image = Foundation.Image
local IconButton = Foundation.IconButton
local Radius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton
local Text = Foundation.Text
local View = Foundation.View
local getRbxThumb = Foundation.Utility.getRbxThumb

local useAssetFetchStatus = RoactUtils.Hooks.useAssetFetchStatus

local MusicPickerContext = require(MusicPicker.Context.MusicPickerContext)
require(MusicPicker.Types.MusicPickerTypes)

local PlayLarge = BuilderIcons.Icon.PlayLarge
local PauseLarge = BuilderIcons.Icon.PauseLarge
local Bookmark = BuilderIcons.Icon.Bookmark

local function MusicPickerRow(props)
	local item = props.item
	local v = React.useContext(MusicPickerContext)

	local v2 = v.previewingId == item.id
	local v3 = v.savedIds[item.id] == true

	local rbxThumb = getRbxThumb(Foundation.Enums.ThumbnailType.Asset, item.thumbnailAssetId)
	local v4 = useAssetFetchStatus(rbxThumb) == Enum.AssetFetchStatus.Success

	local onActivated = React.useCallback(function()
		props.onSelect(item.id)
	end, { props.onSelect, item.id })

	local onActivated2 = React.useCallback(function()
		v.togglePreview(item.id)
	end, { v.togglePreview, item.id })

	local onActivated3 = React.useCallback(function()
		v.toggleSaved(item.id)
	end, { v.toggleSaved, item.id })

	local createElement = React.createElement
	local v5 = {
		LayoutOrder = props.layoutOrder,
		onActivated = onActivated,
		tag = "row align-x-left align-y-center gap-medium size-full-0 auto-y padding-x-xsmall padding-y-small radius-medium"
	}

	local createElement2 = React.createElement
	local v6 = {
		BackgroundTransparency = 1,
		cornerRadius = UDim.new(0, 8),
		Image = rbxThumb,
		LayoutOrder = 1,
		ScaleType = Enum.ScaleType.Fit,
		tag = "position-center-center anchor-center-center size-1200"
	}
	local skeleton

	if not v4 then
		skeleton = React.createElement(Skeleton, {
			radius = Radius.Medium,
			Size = UDim2.fromScale(1, 1)
		})
	end

	local children = {
		Thumbnail = createElement2(Image, v6, { Skeleton = skeleton }),
		MusicInfo = React.createElement(View, {
			LayoutOrder = 2,
			tag = "col shrink gap-xxsmall size-full-0 auto-y"
		}, {
			Title = React.createElement(Text, {
				Text = item.title or "",
				tag = "auto-xy text-title-medium text-align-x-left text-align-y-top text-truncate-end content-emphasis"
			}),
			Artist = React.createElement(Text, {
				Text = item.artist or "",
				tag = "auto-xy text-body-small text-align-x-left text-align-y-top text-truncate-end content-neutral"
			})
		}),
		Controls = 0
	}

	local createElement3 = React.createElement

	local createElement4 = React.createElement
	local icon = if v2 then PauseLarge else PlayLarge
	local v7 = {
		PreviewButton = createElement4(IconButton, {
			icon = icon,
			isCircular = true,
			LayoutOrder = 1,
			onActivated = onActivated2,
			size = Foundation.Enums.IconSize.Small,
			variant = Foundation.Enums.ButtonVariant.Standard
		}),
		SaveButton = 0
	}
	local saveButton

	if v.showSaveButton then
		local createElement5 = React.createElement
		local icon2 = { name = Bookmark, variant = 0 }
		local variant

		if v3 then
			variant = BuilderIcons.IconVariant.Filled
		else
			variant = BuilderIcons.IconVariant.Regular
		end

		icon2.variant = variant
		saveButton = createElement5(IconButton, {
			icon = icon2,
			isCircular = true,
			LayoutOrder = 2,
			onActivated = onActivated3,
			size = Foundation.Enums.IconSize.Small,
			variant = Foundation.Enums.ButtonVariant.Utility
		})
	end

	v7.SaveButton = saveButton
	children.Controls = createElement3(
		View,
		{ LayoutOrder = 3, tag = "row align-x-right align-y-center gap-small auto-xy" },
		v7
	)
	return createElement(View, v5, children)
end

return MusicPickerRow
