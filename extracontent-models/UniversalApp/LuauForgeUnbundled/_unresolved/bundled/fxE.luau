local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BulkPurchaseApp/React")
local module2 = require("@luauforge/bundled/fxp")

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/BulkPurchaseApp/Style").useDesignTokens

local module3 = require("@luauforge/bundled/fxv")

local module4 = require("@luauforge/bundled/fxF")

local styledTextLabel = module2.App.Text.StyledTextLabel
local images = module2.App.ImageSet.Images
local imageSetLabel = module2.Core.ImageSet.ImageSetLabel
local imageSetButton = module2.Core.ImageSet.ImageSetButton
local useSelectionCursor = module2.App.SelectionImage.useSelectionCursor
local cursorKind = module2.App.SelectionImage.CursorKind

local function mapTokens(data)
	return {
		barBackgroundColor = data.Color.Surface.Surface_0.Color3,
		barBackgroundTransparency = data.Color.Surface.Surface_0.Transparency,
		barHeight = data.Size.Size_1400,
		iconAndTextInputMargin = data.Size.Size_400,
		iconOffsetX = data.Size.Size_100,
		iconContainerSize = data.Size.Size_800,
		textColorGroup = data.Color.Content.Emphasis,
		textFontGroup = data.Typography.BodyLarge,
		textIconColor = data.Color.Content.Emphasis.Color3,
		textIconTransparency = data.Color.Content.Emphasis.Transparency,
		textSize = data.Typography.BodyLarge.FontSize,
		trailingIconSize = data.Size.Size_400,
		autocompleteIconSize = data.Size.Size_600,
		recentIconSize = data.Size.Size_800
	}
end

local function getIconMap(p2)
	return {
		recent = { icon = images["icons/menu/recent"], size = p2.recentIconSize },
		autocomplete = {
			icon = images["icons/common/search"],
			size = p2.autocompleteIconSize
		}
	}
end

local function getDisplayProps(p2, p3)
	local iconMap = getIconMap(p3)
	local icon = nil
	local size = nil

	if p2 == module4.Recent then
		return iconMap.recent.icon, iconMap.recent.size, true
	end

	if p2 == module4.Autocomplete then
		icon = iconMap.autocomplete.icon
		size = iconMap.autocomplete.size
	end

	return icon, size, false
end

local function SuggestedItem(props, ref)
	local v5 = useDesignTokens(mapTokens)

	local height = props.height or v5.barHeight
	local text = props.text
	local kind = props.type
	local iconMap = getIconMap(v5)
	local icon = nil
	local size = nil
	local flag = false

	if kind == module4.Recent then
		icon = iconMap.recent.icon
		size = iconMap.recent.size
		flag = true
	elseif kind == module4.Autocomplete then
		icon = iconMap.autocomplete.icon
		size = iconMap.autocomplete.size
	end

	local v6 = useSelectionCursor(cursorKind.RoundedRect)
	local v7 = useSelectionCursor(cursorKind.RoundedRectNoInset)

	local fontSize = v5.textFontGroup.FontSize

	local function onActivate()
		props.onActivate()
	end

	local function onTrailingButtonActivate()
		if props.onTrailingButtonActivate then
			props.onTrailingButtonActivate()
		end
	end

	local createElement = React.createElement
	local v9 = {
		Size = UDim2.new(1, 0, 0, height),
		AnchorPoint = Vector2.new(0, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = v5.barBackgroundColor,
		BackgroundTransparency = v5.barBackgroundTransparency,
		LayoutOrder = props.layoutOrder,
		BorderSizePixel = 0,
		margin = v5.iconOffsetX,
		flexSlot = React.createElement("ImageButton", {
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			[React.Event.Activated] = onActivate,
			[React.Tag] = "data-testid=AvatarExperienceSearch_SuggestedItem_ImageButton",
			SelectionImageObject = v7,
			ref = ref
		}, {
			ButtonChildren = React.createElement(module3, {
				margin = v5.iconOffsetX,
				reverse = true,
				rigidSlot = React.createElement(
					"Frame",
					{
						AnchorPoint = Vector2.new(0, 0.5),
						Size = UDim2.fromOffset(v5.iconContainerSize, v5.iconContainerSize),
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 0, 0.5, 0)
					},
					{
						SuggestedItemLeadingIcon = React.createElement(imageSetLabel, {
							AnchorPoint = Vector2.new(0.5, 0.5),
							Image = icon,
							ImageColor3 = v5.textIconColor,
							ImageTransparency = v5.textIconTransparency,
							BackgroundTransparency = 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							Size = UDim2.fromOffset(size, size)
						})
					}
				),
				flexSlot = React.createElement(
					"Frame",
					{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, height) },
					{
						UIListLayout = React.createElement("UIListLayout", {
							VerticalAlignment = Enum.VerticalAlignment.Center
						}),
						TextLabel = React.createElement(styledTextLabel, {
							fontStyle = v5.textFontGroup,
							colorStyle = v5.textColorGroup,
							text = text or "",
							textWrapped = false,
							textTruncate = Enum.TextTruncate.AtEnd,
							textXAlignment = Enum.TextXAlignment.Left,
							textYAlignment = Enum.TextYAlignment.Top,
							automaticSize = Enum.AutomaticSize.X,
							size = UDim2.new(1, 0, 0, fontSize)
						})
					}
				)
			})
		}),
		rigidSlot = 0
	}
	local v11

	if flag then
		v11 = React.createElement(imageSetButton, {
			AnchorPoint = Vector2.new(0, 0.5),
			Image = images["icons/navigation/close_small"],
			ImageColor3 = v5.textIconColor,
			ImageTransparency = v5.textIconTransparency,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 0.5, 0),
			Size = UDim2.fromOffset(v5.trailingIconSize, v5.trailingIconSize),
			[React.Event.Activated] = onTrailingButtonActivate,
			[React.Tag] = "data-testid=AvatarExperienceSearch_SuggestedItem_TrailingButton",
			SelectionImageObject = v6
		})
	end

	v9.rigidSlot = v11
	return createElement(module3, v9)
end

return React.forwardRef(SuggestedItem)
