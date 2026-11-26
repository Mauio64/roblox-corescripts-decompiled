require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Types")
local ComponentRegistry = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/ComponentRegistry")

local function buildEntrypointRequest(p2, p3, p4, p5, p6)
	return {
		target = p2,
		flow = p3,
		surface = p4,
		client = { clientCapabilities = ComponentRegistry.capabilities(p5) },
		extraProps = p6
	}
end

return buildEntrypointRequest
