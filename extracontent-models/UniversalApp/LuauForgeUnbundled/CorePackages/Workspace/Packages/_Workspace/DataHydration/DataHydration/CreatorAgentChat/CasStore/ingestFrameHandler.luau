local AcpProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Acp/AcpProtocol")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/createTurnHandle")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")

return {
	ingestFrame = function(data, data2, p2)
		assert(
			data2 and (data2.kind == "notification" or data2.kind == "response"),
			"ingestFrame requires an IncomingFrame"
		)
		local v5

		if data2.kind == "notification" then
			local sessionId = data2.notification.params and data2.notification.params.sessionId

			if typeof(sessionId) ~= "string" or sessionId == "" then
				warn(("[CAS] dropped notification without sessionId: %s"):format(data2.notification.method))
				return
			end

			if data2.notification.method == AcpProtocol.Notifications.SessionUpdate then
				local update = data2.notification.params and data2.notification.params.update
				local sequenceNumber = if p2 ~= nil then p2.sequenceNumber else nil

				if update ~= nil and typeof(sequenceNumber) == "number" then
					local v6 = data.getSessionByCasSessionId(sessionId)

					if v6 == nil then
						local universeId = data2.notification.params
							and data2.notification.params.universeId

						if typeof(universeId) == "number" then
							v6 = data.getSessionForProject(universeId, nil, sessionId)
						end
					end

					if v6 ~= nil then
						v6.ingestRealtimeUpdate(update, sequenceNumber)
					end
				end
			end

			v5 = data.getActiveTurnBySession(sessionId)

			if v5 == nil then
				return
			end
		else
			local id = data2.response.id

			if id == nil then
				warn("[CAS] dropped response frame with no id")
				return
			end

			local v6 = tostring(id)
			v5 = data.getActiveTurnByRequestId(v6)

			if v5 == nil then
				data.logger:debug(`[CAS] no active handle for response id={v6}`)
				return
			end
		end

		if v5 == nil then
			return
		end

		v5.dispatchFrame(data2, p2)

		if v5.isDone() then
			data.onTurnDone(v5)
		end
	end
}
