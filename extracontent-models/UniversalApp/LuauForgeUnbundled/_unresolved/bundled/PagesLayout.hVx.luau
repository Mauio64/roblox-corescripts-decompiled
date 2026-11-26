local module = require("@luauforge/bundled/hVy")

require("@luauforge/bundled/hVu")

require("@luauforge/bundled/hVt")

local function PagesLayout(p2)
	local children = {}

	for k, route in p2.state.routes do
		children[route.key] = module.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Visible = k == p2.state.index
		}, {
			Route = p2.descriptors[route.key].render({
				visible = k == p2.state.index
			})
		})
	end

	return module.createElement(
		"Frame",
		{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) },
		children
	)
end

return PagesLayout
