local module = require("@luauforge/bundled/hKQ")

require("@luauforge/bundled/hKM")

require("@luauforge/bundled/hKL")

local function SwitchLayout(props)
	local index = props.state.index
	local children = {}
	local children2 = {}

	for k, route in props.state.routes do
		local descriptor = props.descriptors[route.key]
		children[route.key] = module.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Visible = k == index
		}, {
			Route = descriptor.render({
				visible = k == index
			})
		})

		local titleKey = if descriptor.options ~= nil then descriptor.options.titleKey else nil

		if titleKey == nil then
			continue
		end

		local key = route.key
		children2[key] = module.createElement("TextButton", {
			AutomaticSize = Enum.AutomaticSize.XY,
			LayoutOrder = k,
			Text = titleKey,
			[module.Event.Activated] = function()
				local v6 = { name = route.name }
				props.navigator.navigate(v6, {})
			end
		})
	end

	return module.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1)
	}, {
		Content = module.createElement(
			"Frame",
			{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) },
			children
		),
		Tabs = module.createElement(
			"Frame",
			{ AutomaticSize = Enum.AutomaticSize.XY, BackgroundTransparency = 1 },
			{
				Layout = module.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Items = module.createElement(module.Fragment, nil, children2)
			}
		)
	})
end

return SwitchLayout
