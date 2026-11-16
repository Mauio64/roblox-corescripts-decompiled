local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Foundation")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/DescriptionWithChips/DescriptionWithChipsTypes")
local DescriptionTextBlock = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/DescriptionWithChips/DescriptionTextBlock")
local DescriptionCollapseFrame = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/DescriptionWithChips/DescriptionCollapseFrame")

local view = Foundation.View
local icon = Foundation.Icon
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local skeleton = Foundation.Skeleton
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance

local numberSequence = NumberSequence.new(1, 0)
local v5 = { affordance = stateLayerAffordance.None }
local vector2 = Vector2.new(0.5, 0.5)
local udim = UDim2.fromScale(0.5, 0.5)

local function DescriptionWithChipsView(props, p2)
	local paddingTop = props.paddingTop
	local v6 = React.useMemo(function()
		return { top = UDim.new(0, paddingTop) }
	end, { paddingTop })

	local canExpand = props.canExpand

	local fadeColor = props.fadeColor
	local v7 = React.useMemo(function()
		return { Color3 = fadeColor, Transparency = 0 }
	end, { fadeColor })

	local onContentHeightChanged = props.onContentHeightChanged
	local v8 = React.useCallback(function(p3)
		onContentHeightChanged(p3.AbsoluteSize.Y)
	end, { onContentHeightChanged })

	local blocks = props.blocks
	local renderLink = props.renderLink
	local v9 = React.useMemo(function()
		local children = {}

		for k, block in blocks do
			if block.kind == "link" then
				children["Link" .. k] = React.createElement(view, {
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
		return React.createElement(view, {
			tag = "size-full-0 auto-y",
			padding = v6,
			LayoutOrder = props.LayoutOrder,
			ref = p2,
			testId = "--item-description-loading"
		}, {
			Shimmer = React.createElement(skeleton, {
				Size = UDim2.new(1, 0, 0, props.visibleHeight + props.paddingBottom)
			})
		})
	end

	local v10 = canExpand and not props.isExpanded

	local v11 = if props.isExpanded then iconName.ChevronLargeUp else iconName.ChevronLargeDown

	local createElement = React.createElement
	local v13 = {
		tag = "col gap-small size-full-0 auto-y",
		padding = v6,
		LayoutOrder = props.LayoutOrder,
		ref = if not canExpand then p2 else nil,
		testId = "--item-description"
	}

	local createElement2 = React.createElement
	local v17 = {
		height = props.visibleHeight + props.paddingBottom,
		isExpanded = props.isExpanded,
		LayoutOrder = 1,
		testId = "--item-description-content"
	}

	local v18 = {
		Content = React.createElement(
			view,
			{ tag = "col gap-small size-full-0 auto-y", onAbsoluteSizeChanged = v8 },
			v9
		),
		Fade = 0
	}

	local v19 = if v10 then React.createElement(
		view,
		{
			tag = "position-bottom-left anchor-bottom-left size-full-800",
			backgroundStyle = v7,
			ZIndex = 2,
			testId = "--item-description-fade"
		},
		{
			Gradient = React.createElement("UIGradient", {
				Rotation = 90,
				Transparency = numberSequence
			})
		}
	) else nil
	v18.Fade = v19
	local v15 = {
		Expandable = createElement2(DescriptionCollapseFrame, v17, v18),
		Chevron = 0
	}

	local v20 = if canExpand then React.createElement(view, {
		tag = "size-full-900",
		LayoutOrder = 2,
		onActivated = props.onToggleExpanded,
		stateLayer = v5,
		ref = p2,
		testId = "--item-description-expand"
	}, {
		Arrow = React.createElement(icon, {
			AnchorPoint = vector2,
			Position = udim,
			name = v11,
			size = iconSize.Large,
			style = props.chevronStyle,
			testId = "--item-description-expand-icon"
		})
	}) else nil
	v15.Chevron = v20
	return createElement(view, v13, v15)
end

return React.forwardRef(DescriptionWithChipsView)
