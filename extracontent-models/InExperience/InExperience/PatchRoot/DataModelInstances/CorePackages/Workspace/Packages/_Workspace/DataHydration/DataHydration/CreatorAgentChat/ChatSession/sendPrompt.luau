local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)

require(script.Parent.Parent.types)

return {
	createSendPrompt = function(t1: {[any]: any}) -- line: 30
		-- upvalues: Signals (copy)
		return {
			sendPrompt = function(p1) -- line: 31
				-- upvalues: t1 (copy), Signals (copy)
				local v5 = t1.incrementAssistantTurnSequence()
				local v6, v7 = Signals.createSignal(nil)
				local v8, v9 = Signals.createSignal(nil)
				local u10 = false
				local u11 = false
				local u12 = false
				local u13 = nil
				local u14 = nil
				local u15 = nil

				local function fireCompleted(p2) -- line: 44
					-- upvalues: u11 (ref), v5 (copy), t1 (copy), u15 (ref), u14 (ref), u13 (ref), p1 (copy)
					if u11 then
						return
					end

					if v5 ~= t1.getAssistantTurnSequence() then
						return
					end

					u11 = true
					t1.setActiveStop(nil)

					if u15 ~= nil then
						u15()
						u15 = nil
					end

					if u14 ~= nil then
						u14()
						u14 = nil
					end

					if u13 ~= nil then
						t1.noteTurnSequenceIds(u13)
					end

					if p1.onCompleted ~= nil then
						p1.onCompleted(p2)
					end
				end
				local function stop() -- line: 131
					-- upvalues: u11 (ref), u12 (ref), u13 (ref), u15 (ref), u14 (ref), fireCompleted (copy)
					if u11 then
						return
					end

					u12 = true

					if u13 ~= nil then
						u13.cancel()

						return
					end

					if u15 ~= nil then
						u15()
						u15 = nil
					end

					if u14 ~= nil then
						u14()
						u14 = nil
					end

					fireCompleted(nil)
				end

				t1.setActiveStop(stop)

				return {
					getTurnHandle = v6,
					getSetupError = v8,
					start = function() -- line: 69
						-- upvalues: u10 (ref), u12 (ref), fireCompleted (copy), t1 (copy), v9 (copy), p1 (copy), u13 (ref), v7 (copy), u14 (ref), u15 (ref), Signals (copy)
						if u10 then
							return
						end

						u10 = true
						task.spawn(function() -- line: 75
							-- upvalues: u12 (ref), fireCompleted (copy), t1 (copy), v9 (copy), p1 (copy), u13 (ref), v7 (copy), u14 (ref), u15 (ref), Signals (copy)
							if u12 then
								fireCompleted(nil)

								return
							end

							local v19, v20 = t1.ensureInitialized()

							if not v19 then
								v9({
									stage = "initialize",
									errorCode = v20
								})
								fireCompleted(nil)

								return
							end

							local v21, v22 = t1.ensureCasSession()

							if v21 == nil then
								local v23 = v9

								if not v22 then
									v22 = {
										stage = "session_new"
									}
								end

								v23(v22)
								fireCompleted(nil)

								return
							end

							if u12 then
								fireCompleted(nil)

								return
							end

							local v24 = t1.sessionPrompt({
								sessionId = v21,
								prompt = p1.prompt,
								_meta = p1.promptMeta
							})

							u13 = v24
							v7(v24)

							if u12 then
								v24.cancel()
							end

							u14 = t1.startPollingTurnFromHistory(v21, v24, {
								rtnIdleFallbackSeconds = p1.rtnIdleFallbackSeconds,
								rtnSequenceGapFallbackSeconds = p1.rtnSequenceGapFallbackSeconds,
								pollMinIntervalSeconds = p1.pollMinIntervalSeconds,
								pollMaxIntervalSeconds = p1.pollMaxIntervalSeconds,
								afterSequenceId = t1.getLatestObservedHistorySequenceId(),
								onDroppedChatMessage = p1.onDroppedChatMessage
							})
							u15 = Signals.createEffect(function(p3) -- line: 123
								-- upvalues: v24 (copy), fireCompleted (copy)
								if v24.state(p3).isDone then
									fireCompleted(v24.state(false))
								end
							end)
						end)
					end,
					stop = stop
				}
			end
		}
	end
}
