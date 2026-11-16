local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local AspectRatio = require(Foundation.Components.AspectRatio)
local CornerRadius = require(Foundation.Components.CornerRadius)
local Padding = require(Foundation.Components.Padding)

local getTestIdTag = require(Foundation.Utility.getTestIdTag)

require(Foundation.Components.Types)

local function GuiObjectChildren(props)
	local testId = props.testId
	local v = {
		Children = React.createElement(React.Fragment, {}, props.children),
		AspectRatio = 0,
		CornerRadius = 0,
		FlexItem = 0,
		ListLayout = 0,
		SizeConstraint = 0,
		Padding = 0,
		Scale = 0,
		Stroke = 0
	}
	local aspectRatio

	if props.aspectRatio ~= nil then
		local createElement = React.createElement
		local v2 = { value = props.aspectRatio, testId = 0 }
		local testId2

		if testId then
			testId2 = `{testId}--aspect-ratio`
		end

		v2.testId = testId2
		aspectRatio = createElement(AspectRatio, v2)
	end

	v.AspectRatio = aspectRatio
	local cornerRadius

	if props.cornerRadius ~= nil then
		local createElement = React.createElement
		local v2 = { value = props.cornerRadius, testId = 0 }
		local testId2

		if testId then
			testId2 = `{testId}--corner-radius`
		end

		v2.testId = testId2
		cornerRadius = createElement(CornerRadius, v2)
	end

	v.CornerRadius = cornerRadius
	local flexItem

	if props.flexItem ~= nil then
		flexItem = React.createElement("UIFlexItem", {
			FlexMode = props.flexItem.FlexMode,
			GrowRatio = props.flexItem.GrowRatio,
			ShrinkRatio = props.flexItem.ShrinkRatio,
			ItemLineAlignment = props.flexItem.ItemLineAlignment,
			[React.Tag] = getTestIdTag(testId, "flex-item")
		})
	end

	v.FlexItem = flexItem
	local listLayout

	if not (props.layout == nil or props.layout.FillDirection == nil) then
		listLayout = React.createElement("UIListLayout", {
			FillDirection = props.layout.FillDirection,
			ItemLineAlignment = props.layout.ItemLineAlignment,
			HorizontalAlignment = props.layout.HorizontalAlignment,
			HorizontalFlex = props.layout.HorizontalFlex,
			VerticalAlignment = props.layout.VerticalAlignment,
			VerticalFlex = props.layout.VerticalFlex,
			Padding = props.layout.Padding,
			SortOrder = props.layout.SortOrder,
			Wraps = props.layout.Wraps,
			[React.Tag] = getTestIdTag(testId, "list-layout")
		})
	end

	v.ListLayout = listLayout
	local sizeConstraint

	if props.sizeConstraint ~= nil then
		sizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = props.sizeConstraint.MaxSize,
			MinSize = props.sizeConstraint.MinSize,
			[React.Tag] = getTestIdTag(testId, "size-constraint")
		})
	end

	v.SizeConstraint = sizeConstraint
	local padding

	if props.padding ~= nil then
		local createElement = React.createElement
		local v2 = { value = props.padding, testId = 0 }
		local testId2

		if testId then
			testId2 = `{testId}--padding`
		end

		v2.testId = testId2
		padding = createElement(Padding, v2)
	end

	v.Padding = padding
	local scale

	if props.scale ~= nil then
		scale = React.createElement("UIScale", {
			Scale = props.scale,
			[React.Tag] = getTestIdTag(testId, "scale")
		})
	end

	v.Scale = scale
	local stroke

	if props.stroke ~= nil then
		stroke = React.createElement("UIStroke", {
			Color = props.stroke.Color,
			Thickness = props.stroke.Thickness,
			Transparency = props.stroke.Transparency,
			LineJoinMode = props.stroke.LineJoinMode,
			BorderStrokePosition = props.stroke.BorderStrokePosition,
			[React.Tag] = getTestIdTag(testId, "stroke")
		})
	end

	v.Stroke = stroke
	return v
end

return GuiObjectChildren
