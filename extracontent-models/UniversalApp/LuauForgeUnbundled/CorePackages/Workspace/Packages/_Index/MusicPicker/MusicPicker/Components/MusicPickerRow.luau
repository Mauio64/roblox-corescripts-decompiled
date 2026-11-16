local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/MusicPicker/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MusicPicker/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MusicPicker/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/MusicPicker/RoactUtils")

local image = Foundation.Image
local iconButton = Foundation.IconButton
local radius = Foundation.Enums.Radius
local skeleton = Foundation.Skeleton
local text = Foundation.Text
local view = Foundation.View
local getRbxThumb = Foundation.Utility.getRbxThumb

local useAssetFetchStatus = RoactUtils.Hooks.useAssetFetchStatus

local MusicPickerContext = require("@game/CorePackages/Workspace/Packages/_Index/MusicPicker/MusicPicker/Context/MusicPickerContext")
require("@game/CorePackages/Workspace/Packages/_Index/MusicPicker/MusicPicker/Types/MusicPickerTypes")

local playLarge = BuilderIcons.Icon.PlayLarge
local pauseLarge = BuilderIcons.Icon.PauseLarge
local bookmark = BuilderIcons.Icon.Bookmark

local function MusicPickerRow(props)
	local item = props.item
	local v5 = React.useContext(MusicPickerContext)

	local v6 = v5.previewingId == item.id
	local v7 = v5.savedIds[item.id] == true

	local rbxThumb = getRbxThumb(Foundation.Enums.ThumbnailType.Asset, item.thumbnailAssetId)
	local v8 = useAssetFetchStatus(rbxThumb) == Enum.AssetFetchStatus.Success

	local v9 = React.useCallback(function()
		props.onSelect(item.id)
	end, { props.onSelect, item.id })

	local v10 = React.useCallback(function()
		v5.togglePreview(item.id)
	end, { v5.togglePreview, item.id })

	local v11 = React.useCallback(function()
		v5.toggleSaved(item.id)
	end, { v5.toggleSaved, item.id })

	local createElement = React.createElement
	local v13 = {
		LayoutOrder = props.layoutOrder,
		onActivated = v9,
		tag = "row align-x-left align-y-center gap-medium size-full-0 auto-y padding-x-xsmall padding-y-small radius-medium"
	}

	local createElement2 = React.createElement
	local v15 = {
		BackgroundTransparency = 1,
		cornerRadius = UDim.new(0, 8),
		Image = rbxThumb,
		LayoutOrder = 1,
		ScaleType = Enum.ScaleType.Fit,
		tag = "position-center-center anchor-center-center size-1200"
	}

	local v17 = if not v8 then React.createElement(skeleton, {
		radius = radius.Medium,
		Size = UDim2.fromScale(1, 1)
	}) else nil
	local children = {
		Thumbnail = createElement2(image, v15, { Skeleton = v17 }),
		MusicInfo = React.createElement(
			view,
			{ LayoutOrder = 2, tag = "col shrink gap-xxsmall size-full-0 auto-y" },
			{
				Title = React.createElement(text, {
					Text = item.title or "",
					tag = "auto-xy text-title-medium text-align-x-left text-align-y-top text-truncate-end content-emphasis"
				}),
				Artist = React.createElement(text, {
					Text = item.artist or "",
					tag = "auto-xy text-body-small text-align-x-left text-align-y-top text-truncate-end content-neutral"
				})
			}
		),
		Controls = 0
	}

	local createElement3 = React.createElement

	local v20 = {
		PreviewButton = React.createElement(iconButton, {
			icon = if v6 then pauseLarge else playLarge,
			isCircular = true,
			LayoutOrder = 1,
			onActivated = v10,
			size = Foundation.Enums.IconSize.Small,
			variant = Foundation.Enums.ButtonVariant.Standard
		}),
		SaveButton = 0
	}
	local v24

	if v5.showSaveButton then
		local createElement5 = React.createElement
		local v27 = { name = bookmark, variant = 0 }

		local v28 = if v7 then BuilderIcons.IconVariant.Filled else BuilderIcons.IconVariant.Regular
		v27.variant = v28
		v24 = createElement5(iconButton, {
			icon = v27,
			isCircular = true,
			LayoutOrder = 2,
			onActivated = v11,
			size = Foundation.Enums.IconSize.Small,
			variant = Foundation.Enums.ButtonVariant.Utility
		})
	end

	v20.SaveButton = v24
	children.Controls = createElement3(
		view,
		{ LayoutOrder = 3, tag = "row align-x-right align-y-center gap-small auto-xy" },
		v20
	)
	return createElement(view, v13, children)
end

return MusicPickerRow
