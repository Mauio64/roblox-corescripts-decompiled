local AcpProtocol = require(script.Parent.Parent.Acp.AcpProtocol)

require(script.Parent.Parent.createTurnHandle)
require(script.Parent.Parent.types)

return {
	ingestFrame = function(t1: {[any]: any}, p1, p2) -- line: 22
		-- upvalues: AcpProtocol (copy)
		assert(p1 and (p1.kind == "notification" or p1.kind == "response"), "ingestFrame requires an IncomingFrame")

		local v10

		if p1.kind == "notification" then
			local v5 = p1.notification.params and p1.notification.params.sessionId

			if typeof(v5) ~= "string" or v5 == "" then
				warn(("[CAS] dropped notification without sessionId: %s"):format(p1.notification.method))

				return
			end

			if p1.notification.method == AcpProtocol.Notifications.SessionUpdate then
				local v6 = p1.notification.params and p1.notification.params.update
				local v7 = if p2 == nil then nil else p2.sequenceNumber

				if v6 ~= nil and typeof(v7) == "number" then
					local v8 = t1.getSessionByCasSessionId(v5)

					if v8 == nil then
						local v9 = p1.notification.params and p1.notification.params.universeId

						if typeof(v9) == "number" then
							v8 = t1.getSessionForProject(v9, nil, v5)
						end
					end

					if v8 ~= nil then
						v8.ingestRealtimeUpdate(v6, v7)
					end
				end
			end

			v10 = t1.getActiveTurnBySession(v5)

			if v10 == nil then
				return
			end
		else
			local id = p1.response.id

			if id == nil then
				warn("[CAS] dropped response frame with no id")

				return
			end

			local str = tostring(id)

			v10 = t1.getActiveTurnByRequestId(str)

			if v10 == nil then
				t1.logger:debug(`[CAS] no active handle for response id={ str }`)

				return
			end
		end

		if v10 == nil then
			return
		end

		v10.dispatchFrame(p1, p2)

		if v10.isDone() then
			t1.onTurnDone(v10)
		end
	end
}
