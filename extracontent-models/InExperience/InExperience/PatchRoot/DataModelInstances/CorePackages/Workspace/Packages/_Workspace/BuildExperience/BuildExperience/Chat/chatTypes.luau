local parent = script:FindFirstAncestor("BuildExperience").Parent

require(parent.DataHydration.CreatorAgentChat)
require(parent.Signals)
local ChatTypes = {}
ChatTypes.PENDING_USER_MESSAGE_ID_SUFFIX = ":pending"

function ChatTypes.getResourceAttachmentUri(data)
	if data.type == "resource_link" then
		return data.uri
	end

	return data.resource.uri
end

function ChatTypes.makeAssistantTurnAnchorKey(value: string?, p: number?)
	if p == nil then
		return nil
	end

	return `turn:{value or "project"}:sequence:{p}`
end

return ChatTypes
