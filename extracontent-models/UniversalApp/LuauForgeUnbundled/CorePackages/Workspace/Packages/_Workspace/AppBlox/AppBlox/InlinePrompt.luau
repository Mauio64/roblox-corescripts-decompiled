local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/UIBlox")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Cryo")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Responsive")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local core = UIBlox.Core
local app = UIBlox.App
local useStyle = core.Style.useStyle
local useTokens = Foundation.Hooks.useTokens
local fFlagSduiComponentsUseFoundationTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SharedFlags").FFlagSduiComponentsUseFoundationTokens
local button = UIBlox.App.Button.Button
local images = app.ImageSet.Images
local iconButton = app.Button.IconButton
local iconSize = app.ImageSet.Enum.IconSize
local imageSetLabel = core.ImageSet.ImageSetLabel
local getIconSize = app.ImageSet.getIconSize

local iconsnavigationclose = images["icons/navigation/close"]

local function InlinePrompt(props)
	local v5 = if fFlagSduiComponentsUseFoundationTokens then useTokens() else useStyle().Tokens

	local v6 = not props.onDismiss and 0 or getIconSize(iconSize.Small)
	local v7 = (props.iconImage and 36 or 0) + v6

	local ref = React.useRef(nil)
	local v8 = Responsive.useBreakpointXOrSmaller(Responsive.Keys.Small)

	local createElement = React.createElement
	local v10 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1
	}

	local createElement2 = React.createElement
	local v12 = {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = 0
	}
	local v13 = if v8 then Enum.VerticalAlignment.Top else Enum.VerticalAlignment.Center
	v12.VerticalAlignment = v13
	local children = {
		UILayout = createElement2("UIListLayout", v12),
		Icon = 0,
		MiddleFrame = 0,
		DismissButtonFrame = 0
	}

	local v14 = if props.iconImage then React.createElement(imageSetLabel, {
		LayoutOrder = 1,
		Selectable = false,
		Size = UDim2.fromOffset(36, 36),
		Image = props.iconImage,
		ImageColor3 = v5.Color.Content.Emphasis.Color3,
		ImageTransparency = v5.Color.Content.Emphasis.Transparency,
		BackgroundTransparency = 1
	}) else nil
	children.Icon = v14

	local createElement3 = React.createElement
	local v16 = {
		LayoutOrder = 2,
		Size = UDim2.new(1, -v7, 0, 0),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local v17 = {
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
	local v19 = {
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY
	}
	local v20 = {
		UIFlexItem = React.createElement("UIFlexItem", {
			FlexMode = Enum.UIFlexMode.Fill
		}),
		TextLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingRight = UDim.new(0, 12)
		}),
		Title = 0,
		Subline = 0
	}

	local createElement5 = React.createElement
	local v22 = {
		LayoutOrder = 1,
		Text = props.titleMessage,
		BackgroundTransparency = 1,
		TextColor3 = v5.Color.Content.Emphasis.Color3,
		TextTransparency = v5.Color.Content.Emphasis.Transparency,
		TextSize = v5.Typography.CaptionLarge.FontSize,
		Font = 0,
		FontFace = 0,
		TextXAlignment = 0,
		Size = 0,
		AutomaticSize = 0,
		TextWrapped = true,
		TextScaled = false,
		LineHeight = 0
	}
	local v23 = if not foundationFontFaceMigration then v5.Typography.CaptionLarge.Font else nil
	v22.Font = v23

	local v24 = if foundationFontFaceMigration then normalizeFontFace(v5.Typography.CaptionLarge.Font) else nil
	v22.FontFace = v24

	v22.TextXAlignment = Enum.TextXAlignment.Left
	v22.Size = UDim2.new(1, 0, 0, 0)
	v22.AutomaticSize = Enum.AutomaticSize.Y

	v22.LineHeight = v5.LineHeight.LineHeight_140
	v20.Title = createElement5("TextLabel", v22)
	local v25

	if props.sublineMessage then
		local createElement6 = React.createElement
		local v27 = {
			LayoutOrder = 2,
			Text = props.sublineMessage,
			BackgroundTransparency = 1,
			TextColor3 = v5.Color.Content.Default.Color3,
			TextTransparency = v5.Color.Content.Default.Transparency,
			TextSize = v5.Typography.BodySmall.FontSize,
			Font = 0,
			FontFace = 0,
			TextXAlignment = 0,
			Size = 0,
			AutomaticSize = 0,
			TextWrapped = true,
			TextScaled = false,
			LineHeight = 1
		}
		local v28 = if not foundationFontFaceMigration then v5.Typography.BodySmall.Font else nil
		v27.Font = v28

		local v29 = if foundationFontFaceMigration then normalizeFontFace(v5.Typography.BodySmall.Font) else nil
		v27.FontFace = v29

		v27.TextXAlignment = Enum.TextXAlignment.Left
		v27.Size = UDim2.new(1, 0, 0, 0)
		v27.AutomaticSize = Enum.AutomaticSize.Y
		v25 = createElement6("TextLabel", v27)
	end

	v20.Subline = v25
	v17.Text = createElement4("Frame", v19, v20)

	local v26 = if not (v8 or not props.buttonProps) then React.createElement(
		button,
		Cryo.Dictionary.join(
			{
				size = UDim2.new(0, 0, 0, 0),
				automaticSize = Enum.AutomaticSize.XY,
				layoutOrder = 2
			},
			props.buttonProps
		)
	) else nil
	v17.Button = v26
	children.MiddleFrame = createElement3("Frame", v16, v17)

	local v27 = if props.onDismiss then React.createElement(iconButton, {
		backgroundTransparency = 1,
		icon = iconsnavigationclose,
		iconSize = iconSize.Small,
		size = UDim2.new(0, iconSize.Small, 0, iconSize.Small),
		onActivated = props.onDismiss,
		layoutOrder = 3
	}) else nil
	children.DismissButtonFrame = v27
	local element = createElement("Frame", v10, children)

	local createElement6 = React.createElement
	local v29 = {
		BackgroundTransparency = props.backgroundTransparency or v5.Color.Surface.Surface_300.Transparency,
		BackgroundColor3 = props.backgroundColor3 or v5.Color.Surface.Surface_300.Color3,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		ref = ref
	}

	local v30 = {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		ContainerRef = 0
	}

	local createElement7 = React.createElement
	local provider = Responsive.ContainerRef.Provider

	local v32 = {
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

	local v33 = if v8 and props.buttonProps then React.createElement(
		button,
		Cryo.Dictionary.join(
			{
				size = UDim2.new(1, 0, 0, 0),
				fitContent = false,
				automaticSize = Enum.AutomaticSize.XY,
				layoutOrder = 2
			},
			props.buttonProps
		)
	) else nil
	v32.Button = v33
	v30.ContainerRef = createElement7(provider, { value = ref }, v32)
	return createElement6("Frame", v29, v30)
end

return InlinePrompt
