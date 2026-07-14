local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)

local configResolvers = require(script.Parent.configResolvers)

return {
	DEFAULT_START_NODE_ID = "root",
	resolveStartNode = function(p1) -- line: 26
		-- upvalues: configResolvers (copy)
		if p1.startNode == nil or p1.startNode == "" then
			return "root"
		end

		local v4 = configResolvers.resolveConfig(p1.startNode, {
			attribute = p1.attributes or {},
			resources = {},
			store = {}
		})

		if type(v4) == "string" then
			return v4
		end

		return "root"
	end
}
