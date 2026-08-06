local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local React = require(BuildExperienceParent.React)
local Foundation = require(BuildExperienceParent.Foundation)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local FoundationImage = Foundation.Image
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

local function FilmstripSlot(t1: {[any]: any}) -- line: 47
	-- upvalues: useTokens (copy), React (copy), Menu (copy), PopoverSide (copy), PopoverAlign (copy), View (copy), Icon (copy), IconName (copy), IconSize (copy), InputSize (copy), FoundationImage (copy), IconButton (copy), Badge (copy), IconPosition (copy), LocalizationStrings (copy), BadgeVariant (copy), BadgeShape (copy), BadgeSize (copy)
	local v24 = useTokens()
	local v25 = if not t1.isSelected then v24.Color.Stroke.Default.Color3 else v24.Color.Content.Emphasis.Color3
	local v26 = if not t1.isSelected then v24.Color.Stroke.Default.Transparency else 0
	local v27 = if not t1.isSelected then v24.Stroke.Standard else v24.Stroke.Thick

	if not t1.isFilled then
		return React.createElement(Menu, {
			tag = "size-full",
			isOpen = t1.isMenuOpen or false,
			items = t1.menuItems or {{
				items = {}
			}},
			side = PopoverSide.Top,
			align = PopoverAlign.Center,
			onPressedOutside = t1.onMenuClose,
			onActivated = t1.onMenuActivated,
			LayoutOrder = t1.LayoutOrder
		}, React.createElement(View, {
			tag = {
				["radius-large"] = true,
				["bg-surface-200"] = true,
				["size-full-2400"] = true,
				["aspect-1-1"] = t1.aspectRatio == "square",
				["aspect-16-9"] = t1.aspectRatio == "wide"
			}
		}, {
			Stroke = React.createElement("UIStroke", {
				Color = v25,
				Transparency = v26,
				Thickness = v27,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			}),
			TouchArea = React.createElement("TextButton", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Text = "",
				ZIndex = 1,
				[React.Event.Activated] = t1.onEmptySlotPressed or function() -- line: 88
				end
			}),
			PlusIcon = React.createElement(View, {
				tag = "align-x-center align-y-center",
				Size = UDim2.fromScale(1, 1)
			}, {
				IconElement = React.createElement(Icon, {
					tag = "auto-xy content-default",
					name = IconName.PlusSmall,
					size = IconSize.Medium
				})
			})
		}))
	end

	return React.createElement(Menu, {
		isOpen = t1.isMenuOpen or false,
		items = t1.menuItems or {{
			items = {}
		}},
		side = PopoverSide.Top,
		align = PopoverAlign.Center,
		onPressedOutside = t1.onMenuClose,
		onActivated = t1.onMenuActivated,
		size = InputSize.Medium,
		LayoutOrder = t1.LayoutOrder
	}, React.createElement(View, {
		tag = {
			["radius-large"] = true,
			["size-full-2400"] = true,
			["aspect-1-1"] = t1.aspectRatio == "square",
			["aspect-16-9"] = t1.aspectRatio == "wide"
		},
		LayoutOrder = t1.LayoutOrder
	}, {
		Stroke = React.createElement("UIStroke", {
			Color = v25,
			Transparency = v26,
			Thickness = v27,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		}),
		TouchArea = React.createElement("TextButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = "",
			ZIndex = 2,
			[React.Event.Activated] = t1.onSelect
		}),
		ImageClip = if not t1.isLoading then if not t1.assetSource or t1.mediaType ~= "video" then if not t1.assetSource then nil else React.createElement(View, {
			tag = "size-full radius-large clip"
		}, {
			Thumbnail = React.createElement(FoundationImage, {
				tag = "size-full radius-large",
				Image = t1.assetSource,
				ScaleType = Enum.ScaleType.Crop
			})
		}) else React.createElement("VideoFrame", {
			Looped = false,
			Playing = false,
			Volume = 0,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			Video = t1.assetSource
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 12)
			})
		}) else React.createElement(View, {
			tag = "size-full radius-large bg-surface-200"
		}),
		EditButton = if not t1.isSelected or not t1.onEditPressed then nil else React.createElement(View, {
			tag = "auto-xy radius-circle bg-over-media-0 padding-xxsmall",
			ZIndex = 3,
			Position = UDim2.new(1, -v24.Gap.Small, 0, v24.Gap.Small),
			AnchorPoint = Vector2.new(1, 0)
		}, {
			Button = React.createElement(IconButton, {
				icon = IconName.Pencil,
				size = InputSize.XSmall,
				onActivated = t1.onEditPressed
			})
		}),
		VideoBadge = if t1.mediaType ~= "video" then nil else React.createElement(Badge, {
			ZIndex = 3,
			Position = UDim2.fromOffset(v24.Gap.Small, v24.Gap.Small),
			icon = {
				name = IconName.PlaySmall,
				position = IconPosition.Left
			},
			text = LocalizationStrings.MEDIA_SELECTION_VIDEO,
			variant = BadgeVariant.OverMedia,
			shape = BadgeShape.Pill,
			size = BadgeSize.Small
		})
	}))
end

return FilmstripSlot
