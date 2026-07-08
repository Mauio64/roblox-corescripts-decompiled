local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)

require(script.Parent.Parent.types)

return {
	createSendPrompt = function(t1: {[any]: any}) -- line: 31
		-- upvalues: Signals (copy)
		return {
			sendPrompt = function(p1) -- line: 32
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

				local function fireCompleted(p2) -- line: 45
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
				local function stop() -- line: 129
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
					start = function() -- line: 70
						-- upvalues: u10 (ref), u12 (ref), fireCompleted (copy), t1 (copy), v9 (copy), p1 (copy), u13 (ref), v7 (copy), u14 (ref), u15 (ref), Signals (copy)
						if u10 then
							return
						end

						u10 = true
						task.spawn(function() -- line: 76
							-- upvalues: u12 (ref), fireCompleted (copy), t1 (copy), v9 (copy), p1 (copy), u13 (ref), v7 (copy), u14 (ref), u15 (ref), Signals (copy)
							if u12 then
								fireCompleted(nil)

								return
							end

							if not t1.ensureInitialized() then
								v9({
									stage = "initialize"
								})
								fireCompleted(nil)

								return
							end

							local v19, v20 = t1.ensureCasSession()

							if v19 == nil then
								local v21 = v9

								if not v20 then
									v20 = {
										stage = "session_new"
									}
								end

								v21(v20)
								fireCompleted(nil)

								return
							end

							if u12 then
								fireCompleted(nil)

								return
							end

							local v22 = t1.sessionPrompt({
								sessionId = v19,
								prompt = p1.prompt,
								_meta = p1.promptMeta
							})

							u13 = v22
							v7(v22)

							if u12 then
								v22.cancel()
							end

							u14 = t1.startPollingTurnFromHistory(v19, v22, {
								rtnIdleFallbackSeconds = p1.rtnIdleFallbackSeconds,
								pollMinIntervalSeconds = p1.pollMinIntervalSeconds,
								pollMaxIntervalSeconds = p1.pollMaxIntervalSeconds,
								afterSequenceId = t1.getLatestObservedHistorySequenceId()
							})
							u15 = Signals.createEffect(function(p3) -- line: 121
								-- upvalues: v22 (copy), fireCompleted (copy)
								if v22.state(p3).isDone then
									fireCompleted(v22.state(false))
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
