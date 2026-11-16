local parent = script.Parent.Parent.Parent.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View

local function DiagramLayoutView(props)
	local layout = props.layout
	local v = Foundation.Hooks.useTokens()
	local v2 = layout.columnWidth ~= 0.5 and 0 or -v.Gap.XXLarge
	local createElement = React.createElement
	local v3 = {
		tag = "size-full-0 auto-y",
		padding = { top = layout.topPadding, bottom = layout.bottomPadding },
		onAbsoluteSizeChanged = props.onSizeChanged,
		testId = props.testId
	}

	local createElement2 = React.createElement
	local v4 = {
		tag = {
			["auto-y"] = layout.columnWidth ~= nil,
			["auto-xy"] = layout.columnWidth == nil
		},
		Size = 0,
		padding = 0,
		AnchorPoint = 0,
		Position = 0,
		scale = 0,
		testId = 0,
		onAbsoluteSizeChanged = 0
	}
	local size

	if layout.columnWidth then
		size = UDim2.new(layout.columnWidth, v2, 0, 0)
	end

	v4.Size = size
	v4.padding = { top = layout.columnTopPadding }
	v4.AnchorPoint = layout.leftAnchor
	v4.Position = layout.leftPosition
	v4.scale = layout.columnScale
	local testId

	if props.testId then
		testId = props.testId .. "LeftColumn"
	end

	v4.testId = testId
	v4.onAbsoluteSizeChanged = props.onLeftSizeChanged
	local children = {
		LeftColContainer = createElement2(View, v4, { LeftCol = props.left }),
		ImageComponentContainer = 0,
		RightColContainer = 0
	}
	local createElement3 = React.createElement
	local v5 = {
		tag = "anchor-top-center",
		Position = UDim2.new(0.5, 0, 0, layout.diagramOffsetY or 0),
		Size = UDim2.fromOffset(layout.diagramSize.X, layout.diagramSize.Y),
		testId = props.diagramTestId
	}
	local imageComponent

	if props.renderDiagram then
		imageComponent = props.renderDiagram(layout.diagramSize)
	else
		imageComponent = props.diagram
	end

	children.ImageComponentContainer = createElement3(View, v5, { ImageComponent = imageComponent })

	local createElement4 = React.createElement
	local v6 = {
		tag = {
			["auto-y"] = layout.columnWidth ~= nil,
			["auto-xy"] = layout.columnWidth == nil
		},
		Size = 0,
		padding = 0,
		AnchorPoint = 0,
		Position = 0,
		scale = 0,
		testId = 0,
		onAbsoluteSizeChanged = 0
	}
	local size2

	if layout.columnWidth then
		size2 = UDim2.new(layout.columnWidth, v2, 0, 0)
	end

	v6.Size = size2
	v6.padding = { top = layout.columnTopPadding }
	v6.AnchorPoint = layout.rightAnchor
	v6.Position = layout.rightPosition
	v6.scale = layout.columnScale
	local testId2

	if props.testId then
		testId2 = props.testId .. "RightColumn"
	end

	v6.testId = testId2
	v6.onAbsoluteSizeChanged = props.onRightSizeChanged
	children.RightColContainer = createElement4(View, v6, { RightCol = props.right })
	return createElement(View, v3, children)
end

return React.memo(DiagramLayoutView)
