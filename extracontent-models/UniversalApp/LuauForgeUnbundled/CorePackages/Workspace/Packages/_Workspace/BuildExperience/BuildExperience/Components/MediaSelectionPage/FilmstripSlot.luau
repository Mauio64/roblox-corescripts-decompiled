local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local image = Foundation.Image
local view = Foundation.View
local icon = Foundation.Icon
local iconButton = Foundation.IconButton
local badge = Foundation.Badge
local menu = Foundation.Menu

local badgeVariant = Foundation.Enums.BadgeVariant
local badgeShape = Foundation.Enums.BadgeShape
local badgeSize = Foundation.Enums.BadgeSize
local iconPosition = Foundation.Enums.IconPosition
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local inputSize = Foundation.Enums.InputSize
local popoverAlign = Foundation.Enums.PopoverAlign
local popoverSide = Foundation.Enums.PopoverSide

local useTokens = Foundation.Hooks.useTokens

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MediaSelectionPage/types")

local function FilmstripSlot(props)
	local video = useLocalization({ video = LocalizationStrings.MEDIA_SELECTION_VIDEO }).video
	local v5 = useTokens()
	local color3

	if props.isSelected then
		color3 = v5.Color.Content.Emphasis.Color3
	else
		color3 = v5.Color.Stroke.Default.Color3
	end

	local v6 = props.isSelected and 0 or v5.Color.Stroke.Default.Transparency
	local v7 = if props.isSelected then v5.Stroke.Thick else v5.Stroke.Standard

	if props.isFilled then
		local createElement = React.createElement

		local v9 = {
			isOpen = props.isMenuOpen or false,
			items = props.menuItems or {
				{ items = {} }
			},
			side = popoverSide.Top,
			align = popoverAlign.Center,
			onPressedOutside = props.onMenuClose,
			onActivated = props.onMenuActivated,
			size = inputSize.Medium,
			LayoutOrder = props.LayoutOrder
		}

		local createElement2 = React.createElement
		local v11 = {
			tag = {
				["radius-large"] = true,
				["size-full-2700"] = true,
				["aspect-1-1"] = props.aspectRatio == "square",
				["aspect-16-9"] = props.aspectRatio == "wide"
			},
			LayoutOrder = props.LayoutOrder
		}
		local v12 = {
			Stroke = React.createElement("UIStroke", {
				Color = color3,
				Transparency = v6,
				Thickness = v7,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			}),
			TouchArea = React.createElement("TextButton", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Text = "",
				ZIndex = 2,
				[React.Event.Activated] = props.onSelect
			}),
			ImageClip = 0,
			EditButton = 0,
			VideoBadge = 0
		}
		local v13

		if props.isLoading then
			v13 = React.createElement(view, {
				tag = "size-full radius-large bg-surface-200"
			})
		elseif props.assetSource and props.mediaType == "video" then
			v13 = React.createElement("VideoFrame", {
				Size = UDim2.fromScale(1, 1),
				Video = props.assetSource,
				Looped = false,
				Playing = false,
				Volume = 0,
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, 12)
				})
			})
		elseif props.assetSource then
			v13 = React.createElement(view, { tag = "size-full radius-large clip" }, {
				Thumbnail = React.createElement(image, {
					Image = props.assetSource,
					tag = "size-full radius-large",
					ScaleType = Enum.ScaleType.Crop
				})
			})
		end

		v12.ImageClip = v13

		local v14 = if props.isSelected and props.onEditPressed then React.createElement(view, {
			tag = "auto-xy radius-circle bg-over-media-0 padding-xxsmall",
			Position = UDim2.new(1, -v5.Gap.Small, 0, v5.Gap.Small),
			AnchorPoint = Vector2.new(1, 0),
			ZIndex = 3
		}, {
			Button = React.createElement(iconButton, {
				icon = iconName.Pencil,
				size = inputSize.XSmall,
				onActivated = props.onEditPressed
			})
		}) else nil
		v12.EditButton = v14

		local v15 = if props.mediaType == "video" then React.createElement(badge, {
			Position = UDim2.fromOffset(v5.Gap.Small, v5.Gap.Small),
			ZIndex = 3,
			icon = { name = iconName.PlaySmall, position = iconPosition.Left },
			text = video,
			variant = badgeVariant.OverMedia,
			shape = badgeShape.Pill,
			size = badgeSize.Small
		}) else nil
		v12.VideoBadge = v15
		return createElement(menu, v9, createElement2(view, v11, v12))
	end

	return React.createElement(menu, {
		tag = "size-full",
		isOpen = props.isMenuOpen or false,
		items = props.menuItems or {
			{ items = {} }
		},
		side = popoverSide.Top,
		align = popoverAlign.Center,
		onPressedOutside = props.onMenuClose,
		onActivated = props.onMenuActivated,
		LayoutOrder = props.LayoutOrder
	}, React.createElement(view, {
		tag = {
			["radius-large"] = true,
			["bg-surface-200"] = true,
			["size-full-2700"] = true,
			["aspect-1-1"] = props.aspectRatio == "square",
			["aspect-16-9"] = props.aspectRatio == "wide"
		}
	}, {
		Stroke = React.createElement("UIStroke", {
			Color = color3,
			Transparency = v6,
			Thickness = v7,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		}),
		TouchArea = React.createElement("TextButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = "",
			ZIndex = 1,
			[React.Event.Activated] = props.onEmptySlotPressed or function() end
		}),
		PlusIcon = React.createElement(
			view,
			{ Size = UDim2.fromScale(1, 1), tag = "align-x-center align-y-center" },
			{
				IconElement = React.createElement(icon, {
					name = iconName.PlusSmall,
					size = iconSize.Medium,
					tag = "auto-xy content-default"
				})
			}
		)
	}))
end

return FilmstripSlot
