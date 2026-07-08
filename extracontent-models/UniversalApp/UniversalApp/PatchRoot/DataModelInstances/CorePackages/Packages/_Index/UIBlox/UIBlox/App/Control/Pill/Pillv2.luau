local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Core = ParentParentParent.Core
local Cryo = require(ParentParentParentParent.Cryo)
local React = require(ParentParentParentParent.React)
local Foundation = require(ParentParentParentParent.Foundation)
local Images = require(ParentParent.ImageSet.Images)
local IconSize = require(ParentParent.ImageSet.Enum.IconSize)
local getIconSize = require(ParentParent.ImageSet.getIconSize)
local useSelectionCursor = require(ParentParent.SelectionImage.useSelectionCursor)
local CursorKind = require(ParentParent.SelectionImage.CursorKind)
local useStyle = require(Core.Style.useStyle)
local ControlState = require(Core.Control.Enum.ControlState)
local Interactable = require(Core.Control.Interactable)
local useControlState = require(Core.Control.useControlState)
local getContentStyle = require(Core.Button.getContentStyle)
local GenericTextLabel = require(Core.Text.GenericTextLabel.GenericTextLabel)
local ImageSetComponent = require(ParentParentParent.Core.ImageSet.ImageSetComponent)
local Skeleton = Foundation.Skeleton
local EnumsRadius = Foundation.Enums.Radius
local GetTextSize = require(ParentParentParent.Core.Text.GetTextSize)
local t1 = {
	hasBorder = false,
	isDisabled = false,
	isLoading = false,
	isSelected = false,
	layoutOrder = 1,
	text = ""
}
local t2 = {
	[ControlState.Default] = "SystemPrimaryContent",
	[ControlState.Hover] = "SystemPrimaryContent"
}
local t3 = {
	[ControlState.Default] = "TextDefault",
	[ControlState.Hover] = "TextEmphasis"
}
local t4 = {
	[ControlState.Default] = "SystemPrimaryContent",
	[ControlState.Hover] = "SystemPrimaryContent"
}
local t5 = {
	[ControlState.Default] = "BackgroundUIDefault",
	[ControlState.Hover] = "BackgroundUIDefault"
}
local t6 = {
	[ControlState.Default] = "SystemPrimaryDefault",
	[ControlState.Hover] = "SystemPrimaryOnHover"
}
local t7 = {
	[ControlState.Default] = "BackgroundOnHover",
	[ControlState.Hover] = "BackgroundOnHover"
}

local function Pillv2(t8: {[any]: any}) -- line: 113
	-- upvalues: Cryo (copy), t1 (copy), useControlState (copy), React (copy), useStyle (copy), useSelectionCursor (copy), CursorKind (copy), t4 (copy), t3 (copy), t6 (copy), t5 (copy), getContentStyle (copy), t2 (copy), t7 (copy), getIconSize (copy), IconSize (copy), GetTextSize (copy), Skeleton (copy), EnumsRadius (copy), ControlState (copy), Interactable (copy), GenericTextLabel (copy), ImageSetComponent (copy), Images (copy)
	local v32 = Cryo.Dictionary.join(t1, t8)
	local text = v32.text
	local v34, v35 = useControlState()
	local v36 = React.useCallback(function(p1, p2) -- line: 118
		-- upvalues: v32 (copy), v35 (copy)
		if v32.onStateChanged then
			v32.onStateChanged(p1, p2)
		end

		v35(p1, p2)
	end, { v32.onStateChanged })
	local v37 = useStyle()
	local Font = v37.Font
	local v39 = useSelectionCursor(CursorKind.SmallPill)
	local v40 = if not v32.isSelected then t3 else t4
	local v41 = if not v32.isSelected then t5 else t6
	local v42 = getContentStyle(t2, v34, v37)
	local v43 = getContentStyle(v40, v34, v37)
	local v44 = getContentStyle(v41, v34, v37)
	local v45 = getContentStyle(t7, v34, v37)
	local v46 = getIconSize(IconSize.Small)
	local BaseSize = Font.BaseSize
	local v48 = Font.CaptionHeader.RelativeSize * BaseSize
	local X = GetTextSize(text, v48, Font.CaptionHeader.Font, Vector2.new(10000, 10000)).X
	local v50 = X + 24
	local n1 = 216

	if v32.isSelected then
		local v52 = 4 + v46

		v50 += v52
		n1 -= v52
	end

	if v32.isLoading then
		return React.createElement(Skeleton, {
			LayoutOrder = v32.layoutOrder,
			Size = UDim2.fromOffset(v50, 28),
			radius = EnumsRadius.Circle
		})
	end

	local v53 = not v32.isSelected and v34 == ControlState.Hover

	return React.createElement(Interactable, {
		Size = UDim2.new(0, v50, 0, 28),
		BackgroundColor3 = v44.Color,
		BackgroundTransparency = v44.Transparency,
		ImageColor3 = v44.Color,
		ImageTransparency = v44.Transparency,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		LayoutOrder = v32.layoutOrder,
		ScaleType = Enum.ScaleType.Slice,
		isDisabled = v32.isDisabled,
		SelectionImageObject = v39,
		[React.Event.Activated] = if v32.isLoading then nil else v32.onActivated,
		onStateChanged = v36,
		ref = v32.controlRef,
		NextSelectionLeft = v32.NextSelectionLeft,
		NextSelectionRight = v32.NextSelectionRight,
		NextSelectionUp = v32.NextSelectionUp,
		NextSelectionDown = v32.NextSelectionDown
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(1, 0)
		}),
		UISizeConstraint = React.createElement("UISizeConstraint", {
			MinSize = Vector2.new(28, 28),
			MaxSize = Vector2.new(240, 28)
		}),
		BackgroundLayer2 = React.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = v45.Color,
			BackgroundTransparency = not v53 and 1 or v45.Transparency
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			}),
			UIStroke = if not v32.hasBorder then nil else React.createElement("UIStroke", {
				Thickness = 1,
				Color = v37.Theme.Divider.Color,
				Transparency = v37.Theme.Divider.Transparency
			}),
			Content = React.createElement("Frame", {
				ClipsDescendants = true,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.new(0, X + 4 + v46, 1, 0)
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					Padding = UDim.new(0, 4),
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				TextArea = string.len(text) > 0 and React.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(X, v48)
				}, {
					PillText = React.createElement(GenericTextLabel, {
						BackgroundTransparency = 1,
						Text = text,
						fontStyle = Font.CaptionHeader,
						colorStyle = v43,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Size = UDim2.fromOffset(n1, v48),
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center
					}),
					React.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(n1, 28)
					})
				}),
				CloseIcon = v32.isSelected and React.createElement(ImageSetComponent.Label, {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.fromOffset(v46, v46),
					Image = Images["icons/navigation/close_small"],
					ImageColor3 = v42.Color,
					ImageTransparency = v42.Transparency
				}),
				UISizeConstraint = React.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(216, 28)
				})
			})
		})
	})
end

return React.forwardRef(function(p3, p4) -- line: 256
	-- upvalues: React (copy), Pillv2 (copy), Cryo (copy)
	return React.createElement(Pillv2, Cryo.Dictionary.join(p3, {
		controlRef = p4
	}))
end)
