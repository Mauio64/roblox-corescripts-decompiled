local Parent = script:FindFirstAncestor("DataHydration").Parent
local createSignal = require(Parent.Signals).createSignal
local AcpProtocol = require(script.Parent.Acp.AcpProtocol)
local turnState = require(script.Parent.turnState)

require(script.Parent.types)

local function createTurnHandle(s1: string, p1, p2: ((...any) -> ...any), p3, t1: {[any]: any}?) -- line: 33
	-- upvalues: createSignal (copy), turnState (copy), AcpProtocol (copy)
	local v11, v12 = createSignal(p3 or turnState.createEmptyTurnState(s1, p1))
	local t2 = {}
	local n1 = 1
	local u15 = nil

	local function noteProcessedSequenceNumber(n2: number) -- line: 46
		-- upvalues: u15 (ref)
		if u15 == nil or n2 > u15 then
			u15 = n2
		end
	end

	if t1 ~= nil then
		for _, v18 in t1 do
			if typeof(v18) == "number" and (u15 == nil or v18 > u15) then
				u15 = v18
			end
		end
	end

	local function mutate(p4: ((...any) -> ...any)) -- line: 71
		-- upvalues: v12 (copy)
		v12(function(p5) -- line: 72
			-- upvalues: p4 (copy)
			if p5.isDone then
				return p5
			end

			local v60 = table.clone(p5)

			p4(v60)

			return v60
		end)
	end
	local function fireHandlers(p6) -- line: 82
		-- upvalues: t2 (copy)
		for _, v30 in t2 do
			local ok, result = pcall(function() -- line: 85
				-- upvalues: v30 (copy), p6 (copy)
				v30(p6)
			end)

			if not ok then
				warn(("CreatorAgentClient onNotification handler errored: %s"):format((tostring(result))))
			end
		end
	end
	local function completeFromResponse(p7) -- line: 94
		-- upvalues: v12 (copy)
		if p7.error then
			local error = p7.error

			local function v35(p8) -- line: 97
				-- upvalues: error (copy)
				p8.error = tostring(error.message or "JSON-RPC error")
				p8.errorCode = tonumber(error.code)
				p8.status = "failed"
				p8.isDone = true
			end

			v12(function(p9) -- line: 72
				-- upvalues: v35 (copy)
				if p9.isDone then
					return p9
				end

				local v63 = table.clone(p9)

				v35(v63)

				return v63
			end)
		end
	end
	local function getEventSequenceId(p10, p11) -- line: 106
		local sequenceId = p10.sequenceId

		if typeof(sequenceId) == "number" then
			return sequenceId
		end

		local v39 = if p11 == nil then nil else p11.sequenceNumber

		if typeof(v39) == "number" then
			return v39
		end

		return nil
	end
	local function applyTerminalUpdate(p12) -- line: 120
		-- upvalues: v11 (copy), v12 (copy)
		local v41 = p12.sessionUpdate == "state_change" and p12.state == "idle"

		if not v41 and v11(false).status ~= "queued" then
			return
		end

		local function v42(p13) -- line: 125
			-- upvalues: v41 (copy), p12 (copy)
			if p13.status == "queued" then
				p13.status = "streaming"
			end

			if v41 then
				local v65 = typeof(p12.stop_reason) ~= "string" and "end_turn" or p12.stop_reason

				p13.stopReason = v65
				p13.status = v65 ~= "cancelled" and "succeeded" or "cancelled"
				p13.isDone = true
			end
		end

		v12(function(p14) -- line: 72
			-- upvalues: v42 (copy)
			if p14.isDone then
				return p14
			end

			local v67 = table.clone(p14)

			v42(v67)

			return v67
		end)
	end

	return {
		state = v11,
		onNotification = function(p15) -- line: 61
			-- upvalues: n1 (ref), t2 (copy)
			local v26 = n1

			n1 += 1
			t2[v26] = p15

			return function() -- line: 65
				-- upvalues: t2 (copy), v26 (copy)
				t2[v26] = nil
			end
		end,
		getLatestProcessedSequenceNumber = function() -- line: 193
			-- upvalues: u15 (ref)
			return u15
		end,
		cancel = p2
	}, {
		dispatchFrame = function(p16, p17, b1: boolean?) -- line: 138
			-- upvalues: v11 (copy), AcpProtocol (copy), u15 (ref), v12 (copy), fireHandlers (copy)
			if v11(false).isDone then
				return false
			end

			local v46 = false

			if p16.kind == "notification" then
				if p16.notification.method == AcpProtocol.Notifications.SessionUpdate then
					local v47 = p16.notification.params and p16.notification.params.update

					if v47 ~= nil then
						local sequenceId = v47.sequenceId

						if typeof(sequenceId) == "number" then
						else
							local v49 = if p17 == nil then nil else p17.sequenceNumber

							sequenceId = if typeof(v49) ~= "number" then nil else v49
						end

						v46 = sequenceId == nil or (u15 == nil or sequenceId > u15)

						if sequenceId ~= nil and (u15 == nil or sequenceId > u15) then
							u15 = sequenceId
						end

						local v50 = v47.sessionUpdate == "state_change" and v47.state == "idle"

						if v50 or v11(false).status == "queued" then
							local function v51(p18) -- line: 125
								-- upvalues: v50 (copy), v47 (copy)
								if p18.status == "queued" then
									p18.status = "streaming"
								end

								if v50 then
									local v69 = typeof(v47.stop_reason) ~= "string" and "end_turn" or v47.stop_reason

									p18.stopReason = v69
									p18.status = v69 ~= "cancelled" and "succeeded" or "cancelled"
									p18.isDone = true
								end
							end

							v12(function(p19) -- line: 72
								-- upvalues: v51 (copy)
								if p19.isDone then
									return p19
								end

								local v71 = table.clone(p19)

								v51(v71)

								return v71
							end)
						end
					end
				end

				if b1 ~= false then
					fireHandlers(p16.notification)

					return v46
				end
			elseif p16.kind == "response" then
				local response = p16.response

				if response.error then
					local error = response.error

					local function v54(p20) -- line: 97
						-- upvalues: error (copy)
						p20.error = tostring(error.message or "JSON-RPC error")
						p20.errorCode = tonumber(error.code)
						p20.status = "failed"
						p20.isDone = true
					end

					v12(function(p21) -- line: 72
						-- upvalues: v54 (copy)
						if p21.isDone then
							return p21
						end

						local v74 = table.clone(p21)

						v54(v74)

						return v74
					end)
				end

				v46 = p16.response.error ~= nil
			end

			return v46
		end,
		fail = function(s2: string, n3: number?) -- line: 173
			-- upvalues: v12 (copy)
			local function v57(p22) -- line: 174
				-- upvalues: s2 (copy), n3 (copy)
				p22.error = s2
				p22.errorCode = n3
				p22.status = "failed"
				p22.isDone = true
			end

			v12(function(p23) -- line: 72
				-- upvalues: v57 (copy)
				if p23.isDone then
					return p23
				end

				local v77 = table.clone(p23)

				v57(v77)

				return v77
			end)
		end,
		markCancelled = function() -- line: 182
			-- upvalues: v12 (copy)
			local function v58(p24) -- line: 183
				p24.status = "cancelled"
				p24.stopReason = "cancelled"
				p24.isDone = true
			end

			v12(function(p25) -- line: 72
				-- upvalues: v58 (copy)
				if p25.isDone then
					return p25
				end

				local v80 = table.clone(p25)

				v58(v80)

				return v80
			end)
		end,
		isDone = function() -- line: 203
			-- upvalues: v11 (copy)
			return v11(false).isDone
		end,
		requestId = p1
	}
end

return createTurnHandle
