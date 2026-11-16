local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local SduiCoreSystem = require(parent.SduiCoreSystem)

local View = Foundation.View
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper

local function SduiAssociatedItemsRow(props)
	local layoutOrder = props.layoutOrder
	local children = {}

	for k, item in props.items do
		local sduiComponentWrapper = getSduiComponentWrapper(item)

		children[`Item_${k}`] = React.createElement(sduiComponentWrapper, {
			componentConfig = item,
			sduiContext = props.sduiContext,
			parentAnalyticsContext = props.analyticsContext,
			extraLocalProps = { index = k, layoutOrder = k },
			debugName = `AssociatedItemsRow-Item-${k}`
		})
	end

	return React.createElement(View, {
		tag = "col gap-medium size-full-0 auto-y",
		LayoutOrder = layoutOrder
	}, {
		ItemsScroll = React.createElement("ScrollingFrame", {
			AutomaticCanvasSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			ClipsDescendants = false,
			ElasticBehavior = Enum.ElasticBehavior.Always,
			ScrollBarThickness = 0,
			ScrollingDirection = Enum.ScrollingDirection.X,
			Selectable = false
		}, {
			ItemsRow = React.createElement(View, { tag = "row gap-small auto-xy size-full-0" }, children)
		}),
		Footer = props.footerComponent
	})
end

return React.memo(SduiAssociatedItemsRow)
