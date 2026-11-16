local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)
local configResolvers = require(script.Parent.configResolvers)

return {
	resolveStartNode = function(p)
		if p.startNode == nil or p.startNode == "" then
			return "root"
		end

		local config = configResolvers.resolveConfig(p.startNode, {
			attribute = p.attributes or {},
			resources = {},
			store = {}
		})

		return if type(config) == "string" then config else "root"
	end,
	DEFAULT_START_NODE_ID = "root"
}
