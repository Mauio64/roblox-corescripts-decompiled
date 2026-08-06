local AcpProtocol = require(script.Parent.Parent.Acp.AcpProtocol)

require(script.Parent.Parent.createTurnHandle)
require(script.Parent.Parent.types)

local t1 = {
	agent_message = true,
	agent_message_chunk = true,
	tool_call_update = true,
	tool_call_content_chunk = true,
	state_change = true
}

local function getHistorySequenceId(p1) -- line: 18
	local sequenceId = p1.sequenceId

	if typeof(sequenceId) == "number" then
		return sequenceId
	end

	return nil
end
local function isAssistantSessionUpdate(p2) -- line: 23
	-- upvalues: t1 (copy)
	local sessionUpdate = p2.sessionUpdate

	return typeof(sessionUpdate) == "string" and t1[sessionUpdate] == true
end
local function orderHistoryItems(t2: {[any]: any}) -- line: 34
	local t3 = {}

	for v12, v13 in t2 do
		local t4 = {
			update = v13,
			originalIndex = v12
		}
		local sequenceId = v13.sequenceId

		t4.sequenceId = if typeof(sequenceId) ~= "number" then nil else sequenceId
		table.insert(t3, t4)
	end

	table.sort(t3, function(p3, p4) -- line: 44
		if p3.sequenceId ~= nil and p4.sequenceId ~= nil then
			return p3.sequenceId < p4.sequenceId
		end

		return p3.originalIndex < p4.originalIndex
	end)

	return t3
end

return {
	ingestSessionHistory = function(t5: {[any]: any}, s1: string, t6: {[any]: any}, n1: number?) -- line: 59
		-- upvalues: orderHistoryItems (copy), t1 (copy), AcpProtocol (copy)
		assert(typeof(s1) == "string" and s1 ~= "", "sessionId is required")

		local v20 = t5.getActiveTurnInternals(s1)

		if v20 == nil then
			return {}
		end

		local t7 = {}

		for _, v23 in orderHistoryItems(t6) do
			local sequenceId = v23.sequenceId

			if sequenceId == nil or n1 ~= nil and not (n1 < sequenceId) then
				continue
			end

			local sessionUpdate = v23.update.sessionUpdate

			if if not (typeof(sessionUpdate) == "string" and t1[sessionUpdate] == true) then v20.noteProcessedSequenceNumber(sequenceId) else v20.dispatchFrame({
				kind = "notification",
				notification = {
					method = AcpProtocol.Notifications.SessionUpdate,
					params = {
						sessionId = s1,
						update = v23.update
					}
				}
			}, {
				sequenceNumber = sequenceId
			}, false) then
				table.insert(t7, sequenceId)
			end

			if v20.isDone() then
				t5.onTurnDone(v20)

				return t7
			end
		end

		return t7
	end
}
