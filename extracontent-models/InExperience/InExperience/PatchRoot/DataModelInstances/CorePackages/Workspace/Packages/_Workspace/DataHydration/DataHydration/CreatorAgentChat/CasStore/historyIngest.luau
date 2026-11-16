local AcpProtocol = require(script.Parent.Parent.Acp.AcpProtocol)
require(script.Parent.Parent.createTurnHandle)
require(script.Parent.Parent.types)

local v = {
	agent_message = true,
	agent_message_chunk = true,
	tool_call_update = true,
	tool_call_content_chunk = true,
	state_change = true
}

local function getHistorySequenceId(item) -- 1 equivalent call inferred from this helper
	local sequenceId = item.sequenceId
	return if typeof(sequenceId) == "number" then sequenceId else nil
end

local function isAssistantSessionUpdate(update): boolean -- 1 equivalent call inferred from this helper
	local sessionUpdate = update.sessionUpdate
	return typeof(sessionUpdate) == "string" and v[sessionUpdate] == true
end

local function orderHistoryItems(items)
	local result = {}

	for k, item in items do
		local v2 = { update = item, originalIndex = k, sequenceId = getHistorySequenceId(item) } -- inferred equivalent call
		table.insert(result, v2)
	end

	table.sort(result, function(a, b): boolean
		if a.sequenceId == nil or b.sequenceId == nil then
			return a.originalIndex < b.originalIndex
		end

		return a.sequenceId < b.sequenceId
	end)

	return result
end

return {
	ingestSessionHistory = function(p, sessionId: string, p2, p3: number?)
		local v2 = typeof(sessionId) == "string" and sessionId ~= ""
		assert(v2, "sessionId is required")
		local activeTurnInternals = p.getActiveTurnInternals(sessionId)

		if activeTurnInternals == nil then
			return {}
		end

		local sequenceIds = {}

		for _, v3 in orderHistoryItems(p2) do
			local sequenceId = v3.sequenceId

			if not (sequenceId ~= nil and (p3 == nil or p3 < sequenceId)) then
				continue
			end

			local assistantSessionUpdate = isAssistantSessionUpdate(v3.update) -- inferred equivalent call
			local v4

			if assistantSessionUpdate then
				v4 = activeTurnInternals.dispatchFrame({
					kind = "notification",
					notification = {
						method = AcpProtocol.Notifications.SessionUpdate,
						params = { sessionId = sessionId, update = v3.update }
					}
				}, { sequenceNumber = sequenceId }, false)
			else
				v4 = activeTurnInternals.noteProcessedSequenceNumber(sequenceId)
			end

			if v4 then
				table.insert(sequenceIds, sequenceId)
			end

			if activeTurnInternals.isDone() then
				p.onTurnDone(activeTurnInternals)
				return sequenceIds
			end
		end

		return sequenceIds
	end
}
