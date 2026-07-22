local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local AspectRatio = require(Foundation.Components.AspectRatio)
local CornerRadius = require(Foundation.Components.CornerRadius)
local Padding = require(Foundation.Components.Padding)
local Flags = require(Foundation.Utility.Flags)
local getTestIdTag = require(Foundation.Utility.getTestIdTag)

require(Foundation.Components.Types)

local function GuiObjectChildren(p1) -- line: 17
	-- upvalues: React (copy), AspectRatio (copy), Flags (copy), CornerRadius (copy), getTestIdTag (copy), Padding (copy)
	local testId = p1.testId

	return {
		Children = React.createElement(React.Fragment, {}, p1.children),
		AspectRatio = if p1.aspectRatio == nil then nil else React.createElement(AspectRatio, {
			value = p1.aspectRatio,
			testId = if not testId then nil else `{ testId }--aspect-ratio`
		}),
		CornerRadius = if p1.cornerRadius == nil then nil else if not Flags.FoundationCornerRadiusPerCorner then React.createElement("UICorner", {
			CornerRadius = p1.cornerRadius,
			[React.Tag] = getTestIdTag(testId, "corner-radius")
		}) else React.createElement(CornerRadius, {
			value = p1.cornerRadius,
			testId = if not testId then nil else `{ testId }--corner-radius`
		}),
		FlexItem = if p1.flexItem == nil then nil else React.createElement("UIFlexItem", {
			FlexMode = p1.flexItem.FlexMode,
			GrowRatio = p1.flexItem.GrowRatio,
			ShrinkRatio = p1.flexItem.ShrinkRatio,
			ItemLineAlignment = p1.flexItem.ItemLineAlignment,
			[React.Tag] = getTestIdTag(testId, "flex-item")
		}),
		ListLayout = if p1.layout == nil or p1.layout.FillDirection == nil then nil else React.createElement("UIListLayout", {
			FillDirection = p1.layout.FillDirection,
			ItemLineAlignment = p1.layout.ItemLineAlignment,
			HorizontalAlignment = p1.layout.HorizontalAlignment,
			HorizontalFlex = p1.layout.HorizontalFlex,
			VerticalAlignment = p1.layout.VerticalAlignment,
			VerticalFlex = p1.layout.VerticalFlex,
			Padding = p1.layout.Padding,
			SortOrder = p1.layout.SortOrder,
			Wraps = p1.layout.Wraps,
			[React.Tag] = getTestIdTag(testId, "list-layout")
		}),
		SizeConstraint = if p1.sizeConstraint == nil then nil else React.createElement("UISizeConstraint", {
			MaxSize = p1.sizeConstraint.MaxSize,
			MinSize = p1.sizeConstraint.MinSize,
			[React.Tag] = getTestIdTag(testId, "size-constraint")
		}),
		Padding = if p1.padding == nil then nil else React.createElement(Padding, {
			value = p1.padding,
			testId = if not testId then nil else `{ testId }--padding`
		}),
		Scale = if p1.scale == nil then nil else React.createElement("UIScale", {
			Scale = p1.scale,
			[React.Tag] = getTestIdTag(testId, "scale")
		}),
		Stroke = if p1.stroke == nil then nil else React.createElement("UIStroke", {
			Color = p1.stroke.Color,
			Thickness = p1.stroke.Thickness,
			Transparency = p1.stroke.Transparency,
			LineJoinMode = p1.stroke.LineJoinMode,
			BorderStrokePosition = p1.stroke.BorderStrokePosition,
			[React.Tag] = getTestIdTag(testId, "stroke")
		})
	}
end

return GuiObjectChildren
