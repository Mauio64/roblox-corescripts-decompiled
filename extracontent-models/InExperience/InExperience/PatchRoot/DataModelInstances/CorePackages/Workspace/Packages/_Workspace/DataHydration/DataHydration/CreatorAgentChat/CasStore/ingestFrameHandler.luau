local AcpProtocol = require(script.Parent.Parent.Acp.AcpProtocol)
require(script.Parent.Parent.createTurnHandle)
require(script.Parent.Parent.types)

return {
	ingestFrame = function(data, data2, p)
		assert(
			data2 and (data2.kind == "notification" or data2.kind == "response"),
			"ingestFrame requires an IncomingFrame"
		)
		local v

		if data2.kind == "notification" then
			local sessionId = data2.notification.params and data2.notification.params.sessionId

			if typeof(sessionId) ~= "string" or sessionId == "" then
				warn(("[CAS] dropped notification without sessionId: %s"):format(data2.notification.method))
				return
			end

			if data2.notification.method == AcpProtocol.Notifications.SessionUpdate then
				local update = data2.notification.params and data2.notification.params.update
				local sequenceNumber

				if p ~= nil then
					sequenceNumber = p.sequenceNumber
				end

				if update ~= nil and typeof(sequenceNumber) == "number" then
					local v2 = data.getSessionByCasSessionId(sessionId)

					if v2 == nil then
						local universeId = data2.notification.params and data2.notification.params.universeId

						if typeof(universeId) == "number" then
							v2 = data.getSessionForProject(universeId, nil, sessionId)
						end
					end

					if v2 ~= nil then
						v2.ingestRealtimeUpdate(update, sequenceNumber)
					end
				end
			end

			v = data.getActiveTurnBySession(sessionId)

			if v == nil then
				return
			end
		else
			local id = data2.response.id

			if id == nil then
				warn("[CAS] dropped response frame with no id")
				return
			end

			local v2 = tostring(id)
			v = data.getActiveTurnByRequestId(v2)

			if v == nil then
				data.logger:debug(`[CAS] no active handle for response id={v2}`)
				return
			end
		end

		if v == nil then
			return
		end

		v.dispatchFrame(data2, p)

		if v.isDone() then
			data.onTurnDone(v)
		end
	end
}
