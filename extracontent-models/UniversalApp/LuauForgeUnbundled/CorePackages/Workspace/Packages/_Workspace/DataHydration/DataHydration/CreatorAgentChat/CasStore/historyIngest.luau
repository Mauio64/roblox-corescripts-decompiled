local AcpProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Acp/AcpProtocol")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/createTurnHandle")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")

local v5 = {
	agent_message = true,
	agent_message_chunk = true,
	tool_call_update = true,
	tool_call_content_chunk = true,
	state_change = true
}

local function getHistorySequenceId(p2)
	local sequenceId = p2.sequenceId

	if typeof(sequenceId) == "number" then
		return sequenceId
	end

	return nil
end

local function isAssistantSessionUpdate(p2): boolean
	local sessionUpdate = p2.sessionUpdate
	return typeof(sessionUpdate) == "string" and v5[sessionUpdate] == true
end

local function orderHistoryItems(items)
	local result = {}

	for k, item in items do
		local sequenceId = item.sequenceId

		if typeof(sequenceId) ~= "number" then
			sequenceId = nil
		end

		table.insert(result, {
			update = item,
			originalIndex = k,
			sequenceId = sequenceId
		})
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
	ingestSessionHistory = function(p2, value, p3, p4)
		local v6 = typeof(value) == "string" and value ~= ""
		assert(v6, "sessionId is required")
		local activeTurnInternals = p2.getActiveTurnInternals(value)

		if activeTurnInternals == nil then
			return {}
		end

		local sequenceIds = {}

		for k, v7 in orderHistoryItems(p3) do
			local sequenceId = v7.sequenceId

			if not (sequenceId ~= nil and (p4 == nil or p4 < sequenceId)) then
				continue
			end

			local sessionUpdate = v7.update.sessionUpdate
			local v8 = typeof(sessionUpdate) == "string" and v5[sessionUpdate] == true
			local v9

			if v8 then
				v9 = activeTurnInternals.dispatchFrame({
					kind = "notification",
					notification = {
						method = AcpProtocol.Notifications.SessionUpdate,
						params = { sessionId = value, update = v7.update }
					}
				}, { sequenceNumber = sequenceId }, false)
			else
				v9 = activeTurnInternals.noteProcessedSequenceNumber(sequenceId)
			end

			if v9 then
				table.insert(sequenceIds, sequenceId)
			end

			if activeTurnInternals.isDone() then
				p2.onTurnDone(activeTurnInternals)
				return sequenceIds
			end
		end

		return sequenceIds
	end
}
