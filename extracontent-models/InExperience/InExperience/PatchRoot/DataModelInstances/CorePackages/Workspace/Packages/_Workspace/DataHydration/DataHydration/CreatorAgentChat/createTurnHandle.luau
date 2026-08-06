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
	local t3 = {}
	local u16 = nil
	local u17 = nil
	local n2 = 0

	if t1 ~= nil then
		for _, v20 in t1 do
			if typeof(v20) == "number" and t3[v20] ~= true then
				t3[v20] = true

				if u16 == nil then
					u16 = v20
					u17 = v20
				elseif v20 > u16 then
					n2 += v20 - u16 - 1
					u16 = v20
				elseif v20 < u17 then
					n2 += u17 - v20 - 1
					u17 = v20
				else
					n2 -= 1
				end
			end
		end
	end

	local function mutate(p4: ((...any) -> ...any)) -- line: 93
		-- upvalues: v12 (copy)
		v12(function(p5) -- line: 94
			-- upvalues: p4 (copy)
			if p5.isDone then
				return p5
			end

			local v63 = table.clone(p5)

			p4(v63)

			return v63
		end)
	end
	local function fireHandlers(p6) -- line: 104
		-- upvalues: t2 (copy)
		for _, v32 in t2 do
			local ok, result = pcall(function() -- line: 107
				-- upvalues: v32 (copy), p6 (copy)
				v32(p6)
			end)

			if not ok then
				warn(("CreatorAgentClient onNotification handler errored: %s"):format((tostring(result))))
			end
		end
	end
	local function completeFromResponse(p7) -- line: 116
		-- upvalues: v12 (copy)
		if p7.error then
			local error = p7.error

			local function v37(p8) -- line: 119
				-- upvalues: error (copy)
				p8.error = tostring(error.message or "JSON-RPC error")
				p8.errorCode = tonumber(error.code)
				p8.status = "failed"
				p8.isDone = true
			end

			v12(function(p9) -- line: 94
				-- upvalues: v37 (copy)
				if p9.isDone then
					return p9
				end

				local v66 = table.clone(p9)

				v37(v66)

				return v66
			end)
		end
	end
	local function getEventSequenceId(p10, p11) -- line: 128
		local sequenceId = p10.sequenceId

		if typeof(sequenceId) == "number" then
			return sequenceId
		end

		local v41 = if p11 == nil then nil else p11.sequenceNumber

		if typeof(v41) == "number" then
			return v41
		end

		return nil
	end
	local function applyTerminalUpdate(p12) -- line: 142
		-- upvalues: v11 (copy), v12 (copy)
		local v43 = p12.sessionUpdate == "state_change" and p12.state == "idle"

		if not v43 and v11(false).status ~= "queued" then
			return
		end

		local function v44(p13) -- line: 147
			-- upvalues: v43 (copy), p12 (copy)
			if p13.status == "queued" then
				p13.status = "streaming"
			end

			if v43 then
				local v68 = typeof(p12.stop_reason) ~= "string" and "end_turn" or p12.stop_reason

				p13.stopReason = v68
				p13.status = v68 ~= "cancelled" and "succeeded" or "cancelled"
				p13.isDone = true
			end
		end

		v12(function(p14) -- line: 94
			-- upvalues: v44 (copy)
			if p14.isDone then
				return p14
			end

			local v70 = table.clone(p14)

			v44(v70)

			return v70
		end)
	end

	return {
		state = v11,
		onNotification = function(p15) -- line: 83
			-- upvalues: n1 (ref), t2 (copy)
			local v28 = n1

			n1 += 1
			t2[v28] = p15

			return function() -- line: 87
				-- upvalues: t2 (copy), v28 (copy)
				t2[v28] = nil
			end
		end,
		getLatestProcessedSequenceNumber = function() -- line: 213
			-- upvalues: u16 (ref)
			return u16
		end,
		hasSequenceGap = function() -- line: 70
			-- upvalues: n2 (ref)
			return n2 > 0
		end,
		noteProcessedSequenceNumber = function(n3: number) -- line: 217
			-- upvalues: t3 (copy), u16 (ref), u17 (ref), n2 (ref)
			if t3[n3] == true then
				return
			end

			t3[n3] = true

			if u16 == nil then
				u16 = n3
				u17 = n3

				return
			end

			if n3 > u16 then
				n2 += n3 - u16 - 1
				u16 = n3

				return
			end

			if n3 < u17 then
				n2 += u17 - n3 - 1
				u17 = n3

				return
			end

			n2 -= 1
		end,
		cancel = p2
	}, {
		dispatchFrame = function(p16, p17, b1: boolean?) -- line: 160
			-- upvalues: v11 (copy), AcpProtocol (copy), t3 (copy), u16 (ref), u17 (ref), n2 (ref), v12 (copy), fireHandlers (copy)
			if v11(false).isDone then
				return false
			end

			local v48 = false

			if p16.kind == "notification" then
				if p16.notification.method == AcpProtocol.Notifications.SessionUpdate then
					local v49 = p16.notification.params and p16.notification.params.update

					if v49 ~= nil then
						local sequenceId = v49.sequenceId

						if typeof(sequenceId) == "number" then
						else
							local v51 = if p17 == nil then nil else p17.sequenceNumber

							sequenceId = if typeof(v51) ~= "number" then nil else v51
						end

						v48 = true

						if sequenceId ~= nil then
							if t3[sequenceId] == true then
								v48 = false
							else
								t3[sequenceId] = true

								if u16 == nil then
									u16 = sequenceId
									u17 = sequenceId
								elseif sequenceId > u16 then
									n2 += sequenceId - u16 - 1
									u16 = sequenceId
								elseif sequenceId < u17 then
									n2 += u17 - sequenceId - 1
									u17 = sequenceId
								else
									n2 -= 1
								end

								v48 = true
							end
						end

						local v52 = v49.sessionUpdate == "state_change" and v49.state == "idle"

						if v52 or v11(false).status == "queued" then
							local function v53(p18) -- line: 147
								-- upvalues: v52 (copy), v49 (copy)
								if p18.status == "queued" then
									p18.status = "streaming"
								end

								if v52 then
									local v72 = typeof(v49.stop_reason) ~= "string" and "end_turn" or v49.stop_reason

									p18.stopReason = v72
									p18.status = v72 ~= "cancelled" and "succeeded" or "cancelled"
									p18.isDone = true
								end
							end

							v12(function(p19) -- line: 94
								-- upvalues: v53 (copy)
								if p19.isDone then
									return p19
								end

								local v74 = table.clone(p19)

								v53(v74)

								return v74
							end)
						end
					end
				end

				if b1 ~= false then
					fireHandlers(p16.notification)

					return v48
				end
			elseif p16.kind == "response" then
				local response = p16.response

				if response.error then
					local error = response.error

					local function v56(p20) -- line: 119
						-- upvalues: error (copy)
						p20.error = tostring(error.message or "JSON-RPC error")
						p20.errorCode = tonumber(error.code)
						p20.status = "failed"
						p20.isDone = true
					end

					v12(function(p21) -- line: 94
						-- upvalues: v56 (copy)
						if p21.isDone then
							return p21
						end

						local v77 = table.clone(p21)

						v56(v77)

						return v77
					end)
				end

				v48 = p16.response.error ~= nil
			end

			return v48
		end,
		noteProcessedSequenceNumber = function(n4: number) -- line: 49
			-- upvalues: t3 (copy), u16 (ref), u17 (ref), n2 (ref)
			if t3[n4] == true then
				return false
			end

			t3[n4] = true

			if u16 == nil then
				u16 = n4
				u17 = n4
			elseif n4 > u16 then
				n2 += n4 - u16 - 1
				u16 = n4
			elseif n4 < u17 then
				n2 += u17 - n4 - 1
				u17 = n4
			else
				n2 -= 1
			end

			return true
		end,
		fail = function(s2: string, n5: number?) -- line: 193
			-- upvalues: v12 (copy)
			local function v59(p22) -- line: 194
				-- upvalues: s2 (copy), n5 (copy)
				p22.error = s2
				p22.errorCode = n5
				p22.status = "failed"
				p22.isDone = true
			end

			v12(function(p23) -- line: 94
				-- upvalues: v59 (copy)
				if p23.isDone then
					return p23
				end

				local v80 = table.clone(p23)

				v59(v80)

				return v80
			end)
		end,
		markCancelled = function() -- line: 202
			-- upvalues: v12 (copy)
			local function v60(p24) -- line: 203
				p24.status = "cancelled"
				p24.stopReason = "cancelled"
				p24.isDone = true
			end

			v12(function(p25) -- line: 94
				-- upvalues: v60 (copy)
				if p25.isDone then
					return p25
				end

				local v83 = table.clone(p25)

				v60(v83)

				return v83
			end)
		end,
		isDone = function() -- line: 228
			-- upvalues: v11 (copy)
			return v11(false).isDone
		end,
		requestId = p1
	}
end

return createTurnHandle
