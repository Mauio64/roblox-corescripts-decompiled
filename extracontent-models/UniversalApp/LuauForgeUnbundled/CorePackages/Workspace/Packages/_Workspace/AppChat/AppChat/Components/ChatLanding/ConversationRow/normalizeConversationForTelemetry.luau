local function normalizeParticipants(participants)
	if type(participants) ~= "table" then
		return participants
	end

	local result = {}

	for k, item in participants do
		result[k] = type(item) ~= "table" and { id = tostring(item) } or item
	end

	return result
end

local function normalizeConversationForTelemetry(p2)
	local clone = table.clone(p2)
	clone.participants = normalizeParticipants(p2.participants)
	return clone
end

return normalizeConversationForTelemetry
