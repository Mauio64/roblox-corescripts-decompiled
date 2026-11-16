local module = require("@luauforge/bundled/hKQ")

require("@luauforge/bundled/hKM")

require("@luauforge/bundled/hKL")

local function OverlayLayout(p2)
	local children = {}

	for k, route in p2.state.routes do
		children[route.key] = module.createElement(
			"Frame",
			{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) },
			{
				Route = p2.descriptors[route.key].render({ visible = true })
			}
		)
	end

	return module.createElement(
		"Frame",
		{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) },
		children
	)
end

return OverlayLayout
