local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")

require(AmpV2Wizard.Types)
local ComponentRegistry = require(AmpV2Wizard.ComponentRegistry)

local function buildEntrypointRequest(target, flow, surface: string, p, extraProps)
	return {
		target = target,
		flow = flow,
		surface = surface,
		client = {
			clientCapabilities = ComponentRegistry.capabilities(p)
		},
		extraProps = extraProps
	}
end

return buildEntrypointRequest
