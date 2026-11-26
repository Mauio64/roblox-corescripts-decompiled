require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/AbuseSheetFlowTypes")
local configResolvers = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Resolver/configResolvers")

return {
	resolveStartNode = function(p2)
		if p2.startNode == nil or p2.startNode == "" then
			return "root"
		end

		local config = configResolvers.resolveConfig(p2.startNode, {
			attribute = p2.attributes or {},
			resources = {},
			store = {}
		})

		if type(config) == "string" then
			return config
		end

		return "root"
	end,
	DEFAULT_START_NODE_ID = "root"
}
