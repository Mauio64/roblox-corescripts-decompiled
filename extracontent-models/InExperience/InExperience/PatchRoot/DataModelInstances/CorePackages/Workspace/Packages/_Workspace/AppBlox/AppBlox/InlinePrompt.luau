local parent = script:FindFirstAncestor("AppBlox").Parent
local UIBlox = require(parent.UIBlox)
local React = require(parent.React)
local Cryo = require(parent.Cryo)
local Responsive = require(parent.Responsive)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local Core = UIBlox.Core
local App = UIBlox.App
local useStyle = Core.Style.useStyle
local useTokens = Foundation.Hooks.useTokens
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiComponentsUseFoundationTokens = SharedFlags.FFlagSduiComponentsUseFoundationTokens
local Button = UIBlox.App.Button.Button
local Images = App.ImageSet.Images
local IconButton = App.Button.IconButton
local IconSize = App.ImageSet.Enum.IconSize
local ImageSetLabel = Core.ImageSet.ImageSetLabel
local getIconSize = App.ImageSet.getIconSize

local iconsnavigationclose = Images["icons/navigation/close"]

local function InlinePrompt(props)
	local v

	if FFlagSduiComponentsUseFoundationTokens then
		v = useTokens()
	else
		v = useStyle().Tokens
	end

	local v2 = not props.onDismiss and 0 or getIconSize(IconSize.Small)
	local v3 = (props.iconImage and 36 or 0) + v2

	local ref = React.useRef(nil)
	local v4 = Responsive.useBreakpointXOrSmaller(Responsive.Keys.Small)

	local createElement = React.createElement
	local v5 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1
	}

	local createElement2 = React.createElement
	local v6 = {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = 0
	}
	local verticalAlignment

	if v4 then
		verticalAlignment = Enum.VerticalAlignment.Top
	else
		verticalAlignment = Enum.VerticalAlignment.Center
	end

	v6.VerticalAlignment = verticalAlignment
	local children = {
		UILayout = createElement2("UIListLayout", v6),
		Icon = 0,
		MiddleFrame = 0,
		DismissButtonFrame = 0
	}
	local icon

	if props.iconImage then
		icon = React.createElement(ImageSetLabel, {
			LayoutOrder = 1,
			Selectable = false,
			Size = UDim2.fromOffset(36, 36),
			Image = props.iconImage,
			ImageColor3 = v.Color.Content.Emphasis.Color3,
			ImageTransparency = v.Color.Content.Emphasis.Transparency,
			BackgroundTransparency = 1
		})
	end

	children.Icon = icon

	local createElement3 = React.createElement
	local v7 = {
		LayoutOrder = 2,
		Size = UDim2.new(1, -v3, 0, 0),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local v8 = {
		UILayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 12)
		}),
		Text = 0,
		Button = 0
	}

	local createElement4 = React.createElement
	local v9 = {
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY
	}
	local v10 = {
		UIFlexItem = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill }),
		TextLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		UIPadding = React.createElement("UIPadding", { PaddingRight = UDim.new(0, 12) }),
		Title = 0,
		Subline = 0
	}

	local createElement5 = React.createElement
	local v11 = {
		LayoutOrder = 1,
		Text = props.titleMessage,
		BackgroundTransparency = 1,
		TextColor3 = v.Color.Content.Emphasis.Color3,
		TextTransparency = v.Color.Content.Emphasis.Transparency,
		TextSize = v.Typography.CaptionLarge.FontSize,
		Font = 0,
		FontFace = 0,
		TextXAlignment = 0,
		Size = 0,
		AutomaticSize = 0,
		TextWrapped = true,
		TextScaled = false,
		LineHeight = 0
	}
	local font

	if not FoundationFontFaceMigration then
		font = v.Typography.CaptionLarge.Font
	end

	v11.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(v.Typography.CaptionLarge.Font)
	end

	v11.FontFace = fontFace

	v11.TextXAlignment = Enum.TextXAlignment.Left
	v11.Size = UDim2.new(1, 0, 0, 0)
	v11.AutomaticSize = Enum.AutomaticSize.Y

	v11.LineHeight = v.LineHeight.LineHeight_140
	v10.Title = createElement5("TextLabel", v11)
	local subline

	if props.sublineMessage then
		local createElement6 = React.createElement
		local v12 = {
			LayoutOrder = 2,
			Text = props.sublineMessage,
			BackgroundTransparency = 1,
			TextColor3 = v.Color.Content.Default.Color3,
			TextTransparency = v.Color.Content.Default.Transparency,
			TextSize = v.Typography.BodySmall.FontSize,
			Font = 0,
			FontFace = 0,
			TextXAlignment = 0,
			Size = 0,
			AutomaticSize = 0,
			TextWrapped = true,
			TextScaled = false,
			LineHeight = 1
		}
		local font2

		if not FoundationFontFaceMigration then
			font2 = v.Typography.BodySmall.Font
		end

		v12.Font = font2
		local fontFace2

		if FoundationFontFaceMigration then
			fontFace2 = normalizeFontFace(v.Typography.BodySmall.Font)
		end

		v12.FontFace = fontFace2

		v12.TextXAlignment = Enum.TextXAlignment.Left
		v12.Size = UDim2.new(1, 0, 0, 0)
		v12.AutomaticSize = Enum.AutomaticSize.Y
		subline = createElement6("TextLabel", v12)
	end

	v10.Subline = subline
	v8.Text = createElement4("Frame", v9, v10)
	local button

	if not (v4 or not props.buttonProps) then
		button = React.createElement(
			Button,
			Cryo.Dictionary.join(
				{
					size = UDim2.new(0, 0, 0, 0),
					automaticSize = Enum.AutomaticSize.XY,
					layoutOrder = 2
				},
				props.buttonProps
			)
		)
	end

	v8.Button = button
	children.MiddleFrame = createElement3("Frame", v7, v8)
	local dismissButtonFrame

	if props.onDismiss then
		dismissButtonFrame = React.createElement(IconButton, {
			backgroundTransparency = 1,
			icon = iconsnavigationclose,
			iconSize = IconSize.Small,
			size = UDim2.new(0, IconSize.Small, 0, IconSize.Small),
			onActivated = props.onDismiss,
			layoutOrder = 3
		})
	end

	children.DismissButtonFrame = dismissButtonFrame
	local element = createElement("Frame", v5, children)

	local createElement6 = React.createElement
	local v12 = {
		BackgroundTransparency = props.backgroundTransparency or v.Color.Surface.Surface_300.Transparency,
		BackgroundColor3 = props.backgroundColor3 or v.Color.Surface.Surface_300.Color3,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		ref = ref
	}

	local v13 = {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		ContainerRef = 0
	}

	local createElement7 = React.createElement
	local provider = Responsive.ContainerRef.Provider

	local v14 = {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 12),
			PaddingTop = UDim.new(0, 12),
			PaddingBottom = UDim.new(0, 12)
		}),
		UILayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 12)
		}),
		HorizontalContent = element,
		Button = 0
	}
	local button2

	if v4 and props.buttonProps then
		button2 = React.createElement(
			Button,
			Cryo.Dictionary.join(
				{
					size = UDim2.new(1, 0, 0, 0),
					fitContent = false,
					automaticSize = Enum.AutomaticSize.XY,
					layoutOrder = 2
				},
				props.buttonProps
			)
		)
	end

	v14.Button = button2
	v13.ContainerRef = createElement7(provider, { value = ref }, v14)
	return createElement6("Frame", v12, v13)
end

return InlinePrompt
