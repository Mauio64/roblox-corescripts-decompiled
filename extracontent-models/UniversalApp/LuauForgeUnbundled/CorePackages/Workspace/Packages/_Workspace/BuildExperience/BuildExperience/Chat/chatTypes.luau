require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")

return {
	PENDING_USER_MESSAGE_ID_SUFFIX = ":pending",
	getResourceAttachmentUri = function(data)
		if data.type == "resource_link" then
			return data.uri
		end

		return data.resource.uri
	end,
	makeAssistantTurnAnchorKey = function(value, p2)
		if p2 == nil then
			return nil
		end

		return `turn:{value or "project"}:sequence:{p2}`
	end
}
