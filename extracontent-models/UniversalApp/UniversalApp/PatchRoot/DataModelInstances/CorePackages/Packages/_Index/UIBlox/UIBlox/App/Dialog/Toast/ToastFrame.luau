local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent
local parent4 = parent3.Parent

local Cryo = require(parent4.Cryo)
local Roact = require(parent4.Roact)
local t = require(parent4.t)

local ToastIcon = require(parent.ToastIcon)
local ToastText = require(parent.ToastText)

local Button = require(parent2.Button.Button)
local ButtonType = require(parent2.Button.Enum.ButtonType)

local StandardButtonSize = require(parent3.Core.Button.Enum.StandardButtonSize)
local UIBloxConfig = require(parent3.UIBloxConfig)

local extended = Roact.PureComponent:extend("ToastFrame")

extended.validateProps = t.strictInterface({
	anchorPoint = t.optional(t.Vector2),
	buttonProps = t.optional(t.strictInterface({
		buttonDimensions = t.Vector2,
		buttonText = t.string,
		onActivated = t.callback
	})),
	iconProps = t.optional(ToastIcon.validateProps),
	iconChildren = t.optional(t.table),
	isCompact = t.optional(t.boolean),
	layoutOrder = t.optional(t.integer),
	padding = t.numberMin(0),
	position = t.optional(t.UDim2),
	size = t.UDim2,
	subtitleTextProps = t.optional(ToastText.validateProps),
	textFrameSize = t.UDim2,
	titleTextProps = ToastText.validateProps,
	buttonType = t.optional(ButtonType.isEnumValue)
})

extended.defaultProps = {
	padding = 0,
	size = UDim2.new(1, 0, 1, 0),
	textFrameSize = UDim2.new(1, 0, 1, 0)
}

local function renderToastIcon(iconProps, iconChildren)
	if not iconProps then
		return nil
	end

	if type(iconProps.Image) == "function" then
		return iconProps.Image(iconProps)
	end

	return Roact.createElement(ToastIcon, Cryo.Dictionary.join(iconProps, { LayoutOrder = 1 }), iconChildren)
end

function extended.render(p)
	local toastButton = p.props.buttonProps
	local buttonText = toastButton and toastButton.buttonText
	local y = toastButton and toastButton.buttonDimensions.Y
	local x = toastButton and toastButton.buttonDimensions.X
	local buttonType

	if toastButton then
		buttonType = toastButton.buttonType or ButtonType.PrimarySystem
	end

	local isCompact = p.props.isCompact
	local iconProps = p.props.iconProps
	local onActivated = toastButton and toastButton.onActivated
	local padding = p.props.padding
	local subtitleTextProps = p.props.subtitleTextProps

	local v = not UIBloxConfig.useFoundationToastButtonSizing and 0 or padding
	local verticalAlignment

	if subtitleTextProps then
		if isCompact then
			verticalAlignment = Enum.VerticalAlignment.Top
		else
			verticalAlignment = Enum.VerticalAlignment.Center
		end
	else
		verticalAlignment = Enum.VerticalAlignment.Center
	end

	local createElement = Roact.createElement
	local v2 = {
		AnchorPoint = p.props.anchorPoint,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		LayoutOrder = p.props.layoutOrder,
		Position = p.props.position,
		Size = p.props.size
	}

	local createElement2 = Roact.createElement
	local fillDirection

	if isCompact then
		fillDirection = Enum.FillDirection.Vertical
	else
		fillDirection = Enum.FillDirection.Horizontal
	end

	local v3 = {
		FillDirection = fillDirection,
		Padding = UDim.new(0, padding),
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = 0,
		VerticalAlignment = 0
	}
	local horizontalAlignment

	if isCompact then
		horizontalAlignment = Enum.HorizontalAlignment.Center
	else
		horizontalAlignment = Enum.HorizontalAlignment.Left
	end

	v3.HorizontalAlignment = horizontalAlignment
	v3.VerticalAlignment = Enum.VerticalAlignment.Center
	local children = {
		UIListLayout = createElement2("UIListLayout", v3),
		UIPadding = padding > 0 and Roact.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, padding),
			PaddingLeft = UDim.new(0, padding),
			PaddingRight = UDim.new(0, padding),
			PaddingTop = UDim.new(0, padding)
		}),
		ToastMessageFrame = 0,
		ToastButton = 0
	}

	local createElement3 = Roact.createElement
	local v4 = {
		AnchorPoint = p.props.anchorPoint,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = false,
		LayoutOrder = 1,
		Position = p.props.position,
		Size = 0
	}
	local size

	if toastButton then
		if isCompact then
			size = UDim2.new(1, 0, 1, -y - v)
		else
			size = UDim2.new(1, -x - v, 1, 0)
		end
	else
		size = p.props.size
	end

	v4.Size = size

	local createElement4 = Roact.createElement
	local v5 = {
		FillDirection = Enum.FillDirection.Horizontal,
		Padding = UDim.new(0, padding),
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = 0
	}

	if not verticalAlignment then
		if isCompact then
			verticalAlignment = Enum.VerticalAlignment.Top
		else
			verticalAlignment = Enum.VerticalAlignment.Center
		end
	end

	v5.VerticalAlignment = verticalAlignment
	children.ToastMessageFrame = createElement3("Frame", v4, {
		UIListLayout = createElement4("UIListLayout", v5),
		ToastIcon = renderToastIcon(iconProps, p.props.iconChildren),
		ToastTextFrame = Roact.createElement(
			"Frame",
			{ BackgroundTransparency = 1, LayoutOrder = 2, Size = p.props.textFrameSize },
			{
				UIListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				ToastTitle = Roact.createElement(
					ToastText,
					Cryo.Dictionary.join(p.props.titleTextProps, { LayoutOrder = 1 })
				),
				ToastSubtitle = subtitleTextProps and Roact.createElement(
					ToastText,
					Cryo.Dictionary.join(subtitleTextProps, { LayoutOrder = 2 })
				)
			}
		)
	})

	if toastButton then
		local createElement5 = Roact.createElement
		local v6 = {
			buttonType = buttonType,
			fitContent = not isCompact,
			layoutOrder = 2,
			maxWidth = 0,
			onActivated = 0,
			standardSize = 0,
			text = 0
		}
		local maxWidth

		if not isCompact then
			maxWidth = toastButton.buttonDimensions.X
		end

		v6.maxWidth = maxWidth
		v6.onActivated = onActivated
		v6.standardSize = StandardButtonSize.Small
		v6.text = buttonText
		toastButton = createElement5(Button, v6)
	end

	children.ToastButton = toastButton
	return createElement("Frame", v2, children)
end

return extended
