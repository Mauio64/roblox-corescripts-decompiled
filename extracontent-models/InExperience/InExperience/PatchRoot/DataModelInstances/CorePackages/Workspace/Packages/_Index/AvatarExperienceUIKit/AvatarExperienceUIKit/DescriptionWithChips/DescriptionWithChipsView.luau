local parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

require(script.Parent.DescriptionWithChipsTypes)
local DescriptionTextBlock = require(script.Parent.DescriptionTextBlock)
local DescriptionCollapseFrame = require(script.Parent.DescriptionCollapseFrame)

local View = Foundation.View
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local Skeleton = Foundation.Skeleton
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance

local numberSequence = NumberSequence.new(1, 0)
local stateLayer = { affordance = StateLayerAffordance.None }
local vector2 = Vector2.new(0.5, 0.5)
local udim = UDim2.fromScale(0.5, 0.5)

local function DescriptionWithChipsView(props, ref)
	local paddingTop = props.paddingTop
	local padding = React.useMemo(function()
		return { top = UDim.new(0, paddingTop) }
	end, { paddingTop })

	local canExpand = props.canExpand

	local fadeColor = props.fadeColor
	local backgroundStyle = React.useMemo(function()
		return { Color3 = fadeColor, Transparency = 0 }
	end, { fadeColor })

	local onContentHeightChanged = props.onContentHeightChanged
	local onAbsoluteSizeChanged = React.useCallback(function(p)
		onContentHeightChanged(p.AbsoluteSize.Y)
	end, { onContentHeightChanged })

	local blocks = props.blocks
	local renderLink = props.renderLink
	local v = React.useMemo(function()
		local children = {}

		for k, block in blocks do
			if block.kind == "link" then
				children["Link" .. k] = React.createElement(View, {
					tag = "auto-xy",
					LayoutOrder = k
				}, {
					Chip = renderLink(block.url, k)
				})
			else
				children["Text" .. k] = React.createElement(DescriptionTextBlock, {
					text = block.text,
					LayoutOrder = k
				})
			end
		end

		return children
	end, { blocks, renderLink })

	if props.isLoading then
		return React.createElement(View, {
			tag = "size-full-0 auto-y",
			padding = padding,
			LayoutOrder = props.LayoutOrder,
			ref = ref,
			testId = "--item-description-loading"
		}, {
			Shimmer = React.createElement(Skeleton, {
				Size = UDim2.new(1, 0, 0, props.visibleHeight + props.paddingBottom)
			})
		})
	end

	local v2 = canExpand and not props.isExpanded
	local name

	if props.isExpanded then
		name = IconName.ChevronLargeUp
	else
		name = IconName.ChevronLargeDown
	end

	local createElement = React.createElement
	local v3 = {
		tag = "col gap-small size-full-0 auto-y",
		padding = padding,
		LayoutOrder = props.LayoutOrder,
		ref = 0,
		testId = "--item-description"
	}
	local ref2

	if not canExpand then
		ref2 = ref
	end

	v3.ref = ref2

	local createElement2 = React.createElement
	local v4 = {
		height = props.visibleHeight + props.paddingBottom,
		isExpanded = props.isExpanded,
		LayoutOrder = 1,
		testId = "--item-description-content"
	}

	local v5 = {
		Content = React.createElement(
			View,
			{
				tag = "col gap-small size-full-0 auto-y",
				onAbsoluteSizeChanged = onAbsoluteSizeChanged
			},
			v
		),
		Fade = 0
	}
	local fade

	if v2 then
		fade = React.createElement(
			View,
			{
				tag = "position-bottom-left anchor-bottom-left size-full-800",
				backgroundStyle = backgroundStyle,
				ZIndex = 2,
				testId = "--item-description-fade"
			},
			{
				Gradient = React.createElement("UIGradient", {
					Rotation = 90,
					Transparency = numberSequence
				})
			}
		)
	end

	v5.Fade = fade
	local v6 = {
		Expandable = createElement2(DescriptionCollapseFrame, v4, v5),
		Chevron = 0
	}
	local chevron

	if canExpand then
		chevron = React.createElement(View, {
			tag = "size-full-900",
			LayoutOrder = 2,
			onActivated = props.onToggleExpanded,
			stateLayer = stateLayer,
			ref = ref,
			testId = "--item-description-expand"
		}, {
			Arrow = React.createElement(Icon, {
				AnchorPoint = vector2,
				Position = udim,
				name = name,
				size = IconSize.Large,
				style = props.chevronStyle,
				testId = "--item-description-expand-icon"
			})
		})
	end

	v6.Chevron = chevron
	return createElement(View, v3, v6)
end

return React.forwardRef(DescriptionWithChipsView)
