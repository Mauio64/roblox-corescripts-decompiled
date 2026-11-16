require("@luauforge/bundled/gvc")
local module = require("@luauforge/bundled/gvh")

local function buildEntrypointRequest(p2, p3, p4, p5, p6)
	return {
		target = p2,
		flow = p3,
		surface = p4,
		client = { clientCapabilities = module.capabilities(p5) },
		extraProps = p6
	}
end

return buildEntrypointRequest
