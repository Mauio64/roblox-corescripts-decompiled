local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/Foundation")

local fFlagAXItemMediaHeaderDefaultAspectRatio = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/AvatarExperienceFlags").FFlagAXItemMediaHeaderDefaultAspectRatio

local OutfitViewport = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/AvatarSwitcher/Components/OutfitViewport/OutfitViewport")

local view = Foundation.View
local image = Foundation.Image
local skeleton = Foundation.Skeleton

local function ItemMediaHeader(props)
	local item = props.item

	local v5 = if item then `{item.itemType}:{item.itemId}` else nil
	local state, setState = React.useState(nil)

	local v6 = React.useCallback(function()
		if v5 then
			setState(v5)
		end
	end, { v5 })

	local v7 = not (item == nil or props.preferThreeDimensional ~= true) and state ~= v5
	local mediaHorizontalBleed = props.mediaHorizontalBleed or 0
	local aspectRatio = if props.size == nil then props.aspectRatio else nil

	local thumbnail = props.thumbnail

	local ref = React.useRef(thumbnail)
	ref.current = thumbnail
	local state2, setState2 = React.useState(nil)
	local v8 = React.useCallback(function(p2)
		if p2 == Enum.AssetFetchStatus.Success and ref.current == thumbnail then
			setState2(thumbnail)
		end
	end, { thumbnail })
	local v9 = not (thumbnail == nil) and state2 == thumbnail
	local bundleType, bundleItems

	if item and item.itemType == "Bundle" then
		bundleType = item.bundleType
		bundleItems = item.bundleItems
	end

	local createElement = React.createElement
	local v12 = props.size

	if not v12 then
		if fFlagAXItemMediaHeaderDefaultAspectRatio and aspectRatio then
			v12 = UDim2.fromScale(1, 1 / aspectRatio)
		else
			v12 = UDim2.fromScale(1, 1)
		end
	end

	local v13 = if fFlagAXItemMediaHeaderDefaultAspectRatio and aspectRatio then Enum.SizeConstraint.RelativeXX else nil
	local v11 = {
		Size = v12,
		SizeConstraint = v13,
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		ZIndex = props.zIndex,
		Visible = props.visible,
		tag = props.tag,
		testId = props.testId or "item-media-header"
	}
	local v15

	if v7 then
		local createElement2 = React.createElement
		local v17 = {
			BackgroundTransparency = 1,
			tag = "position-top-center anchor-top-center",
			Size = UDim2.new(1, mediaHorizontalBleed * 2, 1, 0),
			testId = "item-media-header-preview"
		}

		local v19 = if item then React.createElement(OutfitViewport, {
			size = UDim2.fromScale(1, 1),
			itemId = item.itemId,
			itemType = item.itemType,
			bundleType = bundleType,
			bundleItems = bundleItems,
			setParentScrollingEnabled = props.setParentScrollingEnabled,
			onLoadingFailed = v6
		}) else nil
		v15 = createElement2(view, v17, { Viewport = v19 })
	end

	local v16

	if not v7 then
		local createElement2 = React.createElement
		local v18 = {
			BackgroundTransparency = 1,
			tag = "position-top-center anchor-top-center size-full",
			testId = "item-media-header-thumbnail",
			aspectRatio = { AspectRatio = 1, DominantAxis = Enum.DominantAxis.Height }
		}

		local v19 = {
			Image = React.createElement(image, {
				Image = thumbnail,
				tag = "size-full",
				ScaleType = Enum.ScaleType.Fit,
				BackgroundTransparency = 1,
				onLoaded = v8,
				testId = "item-media-header-thumbnail-image"
			}),
			Skeleton = 0
		}

		local v20 = if not v9 then React.createElement(skeleton, {
			tag = "size-full",
			ZIndex = 2,
			testId = "item-media-header-thumbnail-skeleton"
		}) else nil
		v19.Skeleton = v20
		v16 = createElement2(view, v18, v19)
	end

	return createElement(view, v11, {
		Preview = v15,
		Thumbnail = v16,
		Overlay = props.overlaySlot
	})
end

return React.memo(ItemMediaHeader)
