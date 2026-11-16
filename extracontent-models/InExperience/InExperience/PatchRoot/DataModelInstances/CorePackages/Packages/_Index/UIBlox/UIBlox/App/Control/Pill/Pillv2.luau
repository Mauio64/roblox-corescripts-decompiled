local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local core = parent2.Core

local Cryo = require(parent3.Cryo)
local React = require(parent3.React)
local Foundation = require(parent3.Foundation)

local Images = require(parent.ImageSet.Images)
local IconSize = require(parent.ImageSet.Enum.IconSize)
local getIconSize = require(parent.ImageSet.getIconSize)
local useSelectionCursor = require(parent.SelectionImage.useSelectionCursor)
local CursorKind = require(parent.SelectionImage.CursorKind)
local useStyle = require(core.Style.useStyle)
local ControlState = require(core.Control.Enum.ControlState)
local Interactable = require(core.Control.Interactable)
local useControlState = require(core.Control.useControlState)
local getContentStyle = require(core.Button.getContentStyle)

local GenericTextLabel = require(core.Text.GenericTextLabel.GenericTextLabel)
local ImageSetComponent = require(parent2.Core.ImageSet.ImageSetComponent)
local Skeleton = Foundation.Skeleton
local Radius = Foundation.Enums.Radius
local GetTextSize = require(parent2.Core.Text.GetTextSize)
local GetFontFromFontStyle = require(parent2.Core.Text.GetFontFromFontStyle)

local v = {
	hasBorder = false,
	isDisabled = false,
	isLoading = false,
	isSelected = false,
	layoutOrder = 1,
	text = ""
}

local v2 = {
	[ControlState.Default] = "SystemPrimaryContent",
	[ControlState.Hover] = "SystemPrimaryContent"
}

local v3 = { [ControlState.Default] = "TextDefault", [ControlState.Hover] = "TextEmphasis" }

local v4 = {
	[ControlState.Default] = "SystemPrimaryContent",
	[ControlState.Hover] = "SystemPrimaryContent"
}

local v5 = {
	[ControlState.Default] = "BackgroundUIDefault",
	[ControlState.Hover] = "BackgroundUIDefault"
}

local v6 = {
	[ControlState.Default] = "SystemPrimaryDefault",
	[ControlState.Hover] = "SystemPrimaryOnHover"
}

local v7 = {
	[ControlState.Default] = "BackgroundOnHover",
	[ControlState.Hover] = "BackgroundOnHover"
}

local function Pillv2(p)
	local joined = Cryo.Dictionary.join(v, p)
	local text = joined.text

	local v8, v9 = useControlState()
	local onStateChanged = React.useCallback(function(p2, p3)
		if joined.onStateChanged then
			joined.onStateChanged(p2, p3)
		end

		v9(p2, p3)
	end, { joined.onStateChanged })

	local v10 = useStyle()
	local font = v10.Font

	local selectionImageObject = useSelectionCursor(CursorKind.SmallPill)

	local v11 = if joined.isSelected then v4 else v3
	local v12 = if joined.isSelected then v6 else v5

	local contentStyle = getContentStyle(v2, v8, v10)
	local contentStyle2 = getContentStyle(v11, v8, v10)
	local contentStyle3 = getContentStyle(v12, v8, v10)
	local contentStyle4 = getContentStyle(v7, v8, v10)

	local iconSize = getIconSize(IconSize.Small)
	local baseSize = font.BaseSize
	local v13 = font.CaptionHeader.RelativeSize * baseSize

	local x = GetTextSize(text, v13, GetFontFromFontStyle(font.CaptionHeader), Vector2.new(10000, 10000)).X

	local v14 = x + 24
	local v15 = 216

	if joined.isSelected then
		local v16 = 4 + iconSize
		v14 += v16
		v15 -= v16
	end

	if joined.isLoading then
		return React.createElement(Skeleton, {
			LayoutOrder = joined.layoutOrder,
			Size = UDim2.fromOffset(v14, 28),
			radius = Radius.Circle
		})
	end

	local v16 = not joined.isSelected and v8 == ControlState.Hover

	local createElement = React.createElement
	local v17 = {}
	v17.Size = UDim2.new(0, v14, 0, 28)
	v17.BackgroundColor3 = contentStyle3.Color
	v17.BackgroundTransparency = contentStyle3.Transparency
	v17.ImageColor3 = contentStyle3.Color
	v17.ImageTransparency = contentStyle3.Transparency
	v17.AutoButtonColor = false
	v17.BorderSizePixel = 0
	v17.LayoutOrder = joined.layoutOrder
	v17.ScaleType = Enum.ScaleType.Slice
	v17.isDisabled = joined.isDisabled
	v17.SelectionImageObject = selectionImageObject
	local activated = React.Event.Activated
	local v18

	if not joined.isLoading then
		v18 = joined.onActivated
	end

	v17[activated] = v18
	v17.onStateChanged = onStateChanged

	v17.ref = joined.controlRef
	v17.NextSelectionLeft = joined.NextSelectionLeft
	v17.NextSelectionRight = joined.NextSelectionRight
	v17.NextSelectionUp = joined.NextSelectionUp
	v17.NextSelectionDown = joined.NextSelectionDown
	local v19 = {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
		UISizeConstraint = React.createElement("UISizeConstraint", {
			MinSize = Vector2.new(28, 28),
			MaxSize = Vector2.new(240, 28)
		}),
		BackgroundLayer2 = 0
	}

	local createElement2 = React.createElement
	local v20 = {
		Size = UDim2.fromScale(1, 1),
		BorderSizePixel = 0,
		BackgroundColor3 = contentStyle4.Color,
		BackgroundTransparency = not v16 and 1 or contentStyle4.Transparency
	}
	local v21 = {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
		UIStroke = 0,
		Content = 0
	}
	local uiStroke

	if joined.hasBorder then
		uiStroke = React.createElement("UIStroke", {
			Color = v10.Theme.Divider.Color,
			Transparency = v10.Theme.Divider.Transparency,
			Thickness = 1
		})
	end

	v21.UIStroke = uiStroke

	local createElement3 = React.createElement
	local v22 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(0, x + 4 + iconSize, 1, 0),
		ClipsDescendants = true,
		BackgroundTransparency = 1
	}

	local v23 = {
		UIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, 4),
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		TextArea = 0,
		CloseIcon = 0,
		UISizeConstraint = 0
	}
	local textArea

	if string.len(text) > 0 then
		textArea = React.createElement(
			"Frame",
			{ Size = UDim2.fromOffset(x, v13), LayoutOrder = 1, BackgroundTransparency = 1 },
			{
				PillText = React.createElement(GenericTextLabel, {
					Text = text,
					BackgroundTransparency = 1,
					fontStyle = font.CaptionHeader,
					colorStyle = contentStyle2,
					TextTruncate = Enum.TextTruncate.AtEnd,
					Size = UDim2.fromOffset(v15, v13),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center
				}),
				React.createElement("UISizeConstraint", { MaxSize = Vector2.new(v15, 28) })
			}
		)
	else
		textArea = false
	end

	v23.TextArea = textArea

	v23.CloseIcon = joined.isSelected and React.createElement(ImageSetComponent.Label, {
		LayoutOrder = 2,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(iconSize, iconSize),
		BackgroundTransparency = 1,
		Image = Images["icons/navigation/close_small"],
		ImageColor3 = contentStyle.Color,
		ImageTransparency = contentStyle.Transparency
	})

	v23.UISizeConstraint = React.createElement("UISizeConstraint", {
		MaxSize = Vector2.new(216, 28)
	})
	v21.Content = createElement3("Frame", v22, v23)
	v19.BackgroundLayer2 = createElement2("Frame", v20, v21)
	return createElement(Interactable, v17, v19)
end

return React.forwardRef(function(p, controlRef)
	return React.createElement(Pillv2, Cryo.Dictionary.join(p, { controlRef = controlRef }))
end)
