local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Core = ParentParentParent.Core
local React = require(ParentParentParentParent.React)
local Foundation = require(ParentParentParentParent.Foundation)
local ControlState = require(Core.Control.Enum.ControlState)
local getContentStyle = require(Core.Button.getContentStyle)
local Interactable = require(Core.Control.Interactable)
local useStyle = require(Core.Style.useStyle)
local ImageSetComponent = require(Core.ImageSet.ImageSetComponent)
local Skeleton = Foundation.Skeleton
local GenericTextLabel = require(Core.Text.GenericTextLabel.GenericTextLabel)
local Images = require(ParentParent.ImageSet.Images)
local IconSize = require(ParentParent.ImageSet.Enum.IconSize)
local getIconSize = require(ParentParent.ImageSet.getIconSize)
local v17 = Images["component_assets/circle_9"]
local v18 = Images["component_assets/circle_9_stroke_1"]
local t1 = {
	[ControlState.Default] = "SecondaryDefault",
	[ControlState.Hover] = "SecondaryOnHover"
}
local t2 = {
	[ControlState.Default] = "SecondaryDefault",
	[ControlState.Hover] = "SecondaryDefault"
}
local t3 = {
	[ControlState.Default] = "TextDefault",
	[ControlState.Hover] = "TextEmphasis"
}
local t4 = {
	[ControlState.Default] = "TextEmphasis",
	[ControlState.Hover] = "TextEmphasis"
}
local t5 = {
	[ControlState.Default] = "BackgroundMuted"
}
local t6 = {
	[ControlState.Default] = "PlaceHolder"
}
local t7 = {
	[ControlState.Default] = "PlaceHolder"
}
local t8 = {
	[ControlState.Default] = "TextEmphasis"
}

local function TileSlot(t9: {[any]: any}) -- line: 97
	-- upvalues: React (copy), ControlState (copy), useStyle (copy), getContentStyle (copy), t2 (copy), t1 (copy), t4 (copy), t3 (copy), t8 (copy), t6 (copy), t5 (copy), t7 (copy), Interactable (copy), ImageSetComponent (copy), v17 (copy), v18 (copy), getIconSize (copy), IconSize (copy), GenericTextLabel (copy), Skeleton (copy)
	local v29, v30 = React.useState(ControlState.Initialize)
	local v31, v32 = React.useState(false)
	local v33 = React.useCallback(function() -- line: 101
		-- upvalues: t9 (copy)
		t9.onActivated(t9.index)
	end, {
		t9.onActivated,
		t9.index
	})
	local v34 = React.useCallback(function(p1, p2) -- line: 105
		-- upvalues: v30 (copy), ControlState (copy), v32 (copy), t9 (copy)
		v30(p2)

		if p2 == ControlState.Hover then
			v32(true)
		else
			v32(false)
		end

		if t9.onStateChanged then
			t9.onStateChanged(p1, p2)
		end
	end, { t9.onStateChanged })
	local v35 = useStyle()
	local isDisabled = t9.isDisabled
	local isLoading = t9.isLoading
	local v38 = isDisabled and ControlState.Disabled or v29
	local isSelected = t9.isSelected
	local v40 = v31 or isSelected
	local v41 = isSelected and getContentStyle(t2, v38, v35) or getContentStyle(t1, v38, v35)
	local v42 = isSelected and getContentStyle(t4, v38, v35) or getContentStyle(t3, v38, v35)
	local v43 = getContentStyle(t8, v38, v35)
	local v44 = isSelected and getContentStyle(t6, v38, v35) or getContentStyle(t5, v38, v35)
	local v45 = getContentStyle(t7, v38, v35)
	local SubHeader1 = v35.Font.SubHeader1
	local thumbnail = t9.thumbnail
	local v48 = t9.thumbnail ~= nil
	local v49 = t9.displayText ~= nil
	local v50 = isDisabled or isLoading

	if v50 then
		v40 = false
	end

	return React.createElement(Interactable, {
		Size = UDim2.fromOffset(48, 48),
		Position = t9.position or UDim2.fromScale(0, 0),
		BackgroundTransparency = 1,
		onStateChanged = v34,
		[React.Event.Activated] = not v50 and v33 or nil
	}, {
		Button = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1)
		}, {
			Background = React.createElement(ImageSetComponent.Label, {
				BackgroundTransparency = 1,
				ZIndex = 1,
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromScale(0, 0),
				Image = v17,
				ImageColor3 = v49 and v44.Color or v45.Color,
				ImageTransparency = v49 and v44.Transparency or v45.Transparency,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(4, 4, 5, 5)
			}),
			Border = if not v40 then nil else React.createElement(ImageSetComponent.Label, {
				BackgroundTransparency = 1,
				ZIndex = 2,
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromScale(0, 0),
				Image = v18,
				ImageColor3 = v41.Color,
				ImageTransparency = v41.Transparency,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(4, 4, 5, 5)
			}),
			ButtonContentLayer = React.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 3,
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromScale(0, 0)
			}, {
				Thumbnail = if isLoading or not v48 then nil else React.createElement(ImageSetComponent.Label, {
					BackgroundTransparency = 1,
					ZIndex = 3,
					Size = UDim2.fromOffset(getIconSize(IconSize.Medium), getIconSize(IconSize.Medium)),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Image = thumbnail,
					ImageColor3 = v43.Color,
					ImageTransparency = v43.Transparency
				}),
				Text = if isLoading or not v49 then nil else React.createElement(GenericTextLabel, {
					BackgroundTransparency = 1,
					ZIndex = 3,
					Size = UDim2.new(1, -24, 1, -24),
					Text = t9.displayText,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					fontStyle = SubHeader1,
					colorStyle = v42
				}),
				LoadingShimmer = if not isLoading then nil else React.createElement(Skeleton, {
					Size = UDim2.fromScale(1, 1)
				})
			})
		})
	})
end

return TileSlot
