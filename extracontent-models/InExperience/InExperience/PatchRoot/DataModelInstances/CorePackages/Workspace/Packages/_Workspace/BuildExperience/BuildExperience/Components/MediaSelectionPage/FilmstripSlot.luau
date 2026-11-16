local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local Image = Foundation.Image
local View = Foundation.View
local Icon = Foundation.Icon
local IconButton = Foundation.IconButton
local Badge = Foundation.Badge
local Menu = Foundation.Menu

local BadgeVariant = Foundation.Enums.BadgeVariant
local BadgeShape = Foundation.Enums.BadgeShape
local BadgeSize = Foundation.Enums.BadgeSize
local IconPosition = Foundation.Enums.IconPosition
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide

local useTokens = Foundation.Hooks.useTokens

require(script.Parent.types)

local function FilmstripSlot(props)
	local video = useLocalization({ video = LocalizationStrings.MEDIA_SELECTION_VIDEO }).video
	local v = useTokens()
	local color3

	if props.isSelected then
		color3 = v.Color.Content.Emphasis.Color3
	else
		color3 = v.Color.Stroke.Default.Color3
	end

	local transparency = props.isSelected and 0 or v.Color.Stroke.Default.Transparency
	local thickness

	if props.isSelected then
		thickness = v.Stroke.Thick
	else
		thickness = v.Stroke.Standard
	end

	if props.isFilled then
		local createElement = React.createElement

		local v2 = {
			isOpen = props.isMenuOpen or false,
			items = props.menuItems or {
				{ items = {} }
			},
			side = PopoverSide.Top,
			align = PopoverAlign.Center,
			onPressedOutside = props.onMenuClose,
			onActivated = props.onMenuActivated,
			size = InputSize.Medium,
			LayoutOrder = props.LayoutOrder
		}

		local createElement2 = React.createElement
		local v3 = {
			tag = {
				["radius-large"] = true,
				["size-full-2700"] = true,
				["aspect-1-1"] = props.aspectRatio == "square",
				["aspect-16-9"] = props.aspectRatio == "wide"
			},
			LayoutOrder = props.LayoutOrder
		}
		local v4 = {
			Stroke = React.createElement("UIStroke", {
				Color = color3,
				Transparency = transparency,
				Thickness = thickness,
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
		local imageClip

		if props.isLoading then
			imageClip = React.createElement(View, { tag = "size-full radius-large bg-surface-200" })
		elseif props.assetSource and props.mediaType == "video" then
			imageClip = React.createElement("VideoFrame", {
				Size = UDim2.fromScale(1, 1),
				Video = props.assetSource,
				Looped = false,
				Playing = false,
				Volume = 0,
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			}, {
				UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 12) })
			})
		elseif props.assetSource then
			imageClip = React.createElement(View, { tag = "size-full radius-large clip" }, {
				Thumbnail = React.createElement(Image, {
					Image = props.assetSource,
					tag = "size-full radius-large",
					ScaleType = Enum.ScaleType.Crop
				})
			})
		end

		v4.ImageClip = imageClip
		local editButton

		if props.isSelected and props.onEditPressed then
			editButton = React.createElement(View, {
				tag = "auto-xy radius-circle bg-over-media-0 padding-xxsmall",
				Position = UDim2.new(1, -v.Gap.Small, 0, v.Gap.Small),
				AnchorPoint = Vector2.new(1, 0),
				ZIndex = 3
			}, {
				Button = React.createElement(IconButton, {
					icon = IconName.Pencil,
					size = InputSize.XSmall,
					onActivated = props.onEditPressed
				})
			})
		end

		v4.EditButton = editButton
		local videoBadge

		if props.mediaType == "video" then
			videoBadge = React.createElement(Badge, {
				Position = UDim2.fromOffset(v.Gap.Small, v.Gap.Small),
				ZIndex = 3,
				icon = { name = IconName.PlaySmall, position = IconPosition.Left },
				text = video,
				variant = BadgeVariant.OverMedia,
				shape = BadgeShape.Pill,
				size = BadgeSize.Small
			})
		end

		v4.VideoBadge = videoBadge
		return createElement(Menu, v2, createElement2(View, v3, v4))
	end

	return React.createElement(Menu, {
		tag = "size-full",
		isOpen = props.isMenuOpen or false,
		items = props.menuItems or {
			{ items = {} }
		},
		side = PopoverSide.Top,
		align = PopoverAlign.Center,
		onPressedOutside = props.onMenuClose,
		onActivated = props.onMenuActivated,
		LayoutOrder = props.LayoutOrder
	}, React.createElement(View, {
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
			Transparency = transparency,
			Thickness = thickness,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		}),
		TouchArea = React.createElement("TextButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = "",
			ZIndex = 1,
			[React.Event.Activated] = props.onEmptySlotPressed or function() end
		}),
		PlusIcon = React.createElement(View, {
			Size = UDim2.fromScale(1, 1),
			tag = "align-x-center align-y-center"
		}, {
			IconElement = React.createElement(Icon, {
				name = IconName.PlusSmall,
				size = IconSize.Medium,
				tag = "auto-xy content-default"
			})
		})
	}))
end

return FilmstripSlot
