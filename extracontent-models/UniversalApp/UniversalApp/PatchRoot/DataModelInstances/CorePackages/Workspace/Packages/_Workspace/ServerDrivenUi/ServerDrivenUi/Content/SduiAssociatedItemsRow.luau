local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local View = Foundation.View
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper
local FFlagSduiExperienceDetailsSupport = require(Parent.SharedFlags).FFlagSduiExperienceDetailsSupport

local function SduiAssociatedItemsRow(t1: {[any]: any}) -- line: 27
	-- upvalues: getSduiComponentWrapper (copy), React (copy), FFlagSduiExperienceDetailsSupport (copy), View (copy)
	local layoutOrder = t1.layoutOrder
	local t2 = {}

	for v12, v13 in t1.items do
		local v14 = getSduiComponentWrapper(v13)

		t2[`Item_${ v12 }`] = React.createElement(v14, {
			componentConfig = v13,
			sduiContext = t1.sduiContext,
			parentAnalyticsContext = t1.analyticsContext,
			extraLocalProps = {
				index = v12,
				layoutOrder = v12
			},
			debugName = `AssociatedItemsRow-Item-${ v12 }`
		})
	end

	if FFlagSduiExperienceDetailsSupport then
		return React.createElement(View, {
			tag = "col gap-medium size-full-0 auto-y",
			LayoutOrder = layoutOrder
		}, {
			ItemsScroll = React.createElement("ScrollingFrame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				ClipsDescendants = false,
				ScrollBarThickness = 0,
				Selectable = false,
				AutomaticCanvasSize = Enum.AutomaticSize.X,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				ElasticBehavior = Enum.ElasticBehavior.Always,
				ScrollingDirection = Enum.ScrollingDirection.X
			}, {
				ItemsRow = React.createElement(View, {
					tag = "row gap-small auto-xy size-full-0"
				}, t2)
			}),
			Footer = t1.footerComponent
		})
	end

	return React.createElement("ScrollingFrame", {
		BackgroundTransparency = 1,
		ClipsDescendants = false,
		ScrollBarThickness = 0,
		AutomaticCanvasSize = Enum.AutomaticSize.X,
		LayoutOrder = layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ElasticBehavior = Enum.ElasticBehavior.Always,
		ScrollingDirection = Enum.ScrollingDirection.X
	}, {
		ItemsRow = React.createElement(View, {
			tag = "row gap-small auto-xy size-full-0"
		}, t2)
	})
end

return React.memo(SduiAssociatedItemsRow)
