local AcpProtocol = require(script.Parent.Parent.Acp.AcpProtocol)

require(script.Parent.Parent.createTurnHandle)
require(script.Parent.Parent.types)

local t1 = {
	agent_message = true,
	agent_message_chunk = true,
	agent_thought = true,
	agent_thought_chunk = true,
	tool_call_update = true,
	tool_call_content_chunk = true,
	state_change = true
}

local function getHistorySequenceId(p1) -- line: 21
	local sequenceId = p1.sequenceId

	if typeof(sequenceId) == "number" then
		return sequenceId
	end

	return nil
end
local function isAssistantSessionUpdate(p2) -- line: 26
	-- upvalues: t1 (copy)
	local sessionUpdate = p2.sessionUpdate

	return typeof(sessionUpdate) == "string" and t1[sessionUpdate] == true
end
local function orderHistoryItems(t2: {[any]: any}) -- line: 37
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

	table.sort(t3, function(p3, p4) -- line: 47
		if p3.sequenceId ~= nil and p4.sequenceId ~= nil then
			return p3.sequenceId < p4.sequenceId
		end

		return p3.originalIndex < p4.originalIndex
	end)

	return t3
end

return {
	ingestSessionHistory = function(t5: {[any]: any}, s1: string, t6: {[any]: any}, n1: number?) -- line: 62
		-- upvalues: orderHistoryItems (copy), t1 (copy), AcpProtocol (copy)
		assert(typeof(s1) == "string" and s1 ~= "", "sessionId is required")

		local v20 = t5.getActiveTurnInternals(s1)

		if v20 == nil then
			return false
		end

		local v21 = false

		for _, v23 in orderHistoryItems(t6) do
			local sequenceId = v23.sequenceId

			if sequenceId == nil or n1 ~= nil and not (n1 < sequenceId) then
				continue
			end

			local sessionUpdate = v23.update.sessionUpdate

			if typeof(sessionUpdate) == "string" and t1[sessionUpdate] == true then
				local v26 = v20.dispatchFrame({
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
				}, false)

				v21 = v21 or v26

				if not v20.isDone() then
					continue
				end

				t5.onTurnDone(v20)

				return v21
			end
		end

		return v21
	end
}
