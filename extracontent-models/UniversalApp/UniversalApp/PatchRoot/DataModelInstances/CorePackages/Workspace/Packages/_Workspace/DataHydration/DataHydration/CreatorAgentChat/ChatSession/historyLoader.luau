require(script.Parent.Parent.types)

local sessionHistoryMerge = require(script.Parent.Parent.sessionHistoryMerge)
local constants = require(script.Parent.constants)
local historyPageUtils = require(script.Parent.historyPageUtils)

require(script.Parent.sessionDeps)

return {
	createHistoryLoader = function(t1: {[any]: any}) -- line: 39
		-- upvalues: historyPageUtils (copy), sessionHistoryMerge (copy), constants (copy)
		local n1 = 0
		local u6 = nil

		local function isRefreshGenerationStale(n2: number) -- line: 43
			-- upvalues: t1 (copy)
			return n2 ~= t1.getRefreshGeneration()
		end
		local function clearHistoryLoadInFlightIfOwned(s1: string) -- line: 47
			-- upvalues: u6 (ref), t1 (copy)
			if s1 == u6 then
				t1.setHistoryLoadInFlight(false)
				u6 = nil
			end
		end
		local function tryAcquireHistoryLoad(s2: string) -- line: 54
			-- upvalues: t1 (copy), u6 (ref)
			if t1.getHistoryLoadInFlight() then
				if s2 == u6 then
					return false
				end

				t1.setHistoryLoadInFlight(false)
				u6 = nil
			end

			u6 = s2
			t1.setHistoryLoadInFlight(true)

			return true
		end
		local function loadHistoryPage(s3: string, s4: string?, p1: ((...any) -> ...any)) -- line: 67
			-- upvalues: t1 (copy), historyPageUtils (copy)
			local v22 = t1.deps.sessionLoad(s3, {
				historyPageToken = s4
			})
			local v23 = historyPageUtils.awaitRequestStateCancelled(v22.state, p1)

			if p1() or v23.status ~= "succeeded" then
				return false, {}, nil
			end

			return true, historyPageUtils.getSessionLoadHistory(v23.result), historyPageUtils.getNextHistoryPageToken(v23.result)
		end
		local function isSessionLoadStale(s5: string, n3: number, p2: ((...any) -> ...any)) -- line: 85
			-- upvalues: t1 (copy)
			return p2() or (s5 ~= t1.getCasSessionId() or n3 ~= t1.getRefreshGeneration())
		end
		local function isPrefetchStale(s6: string, n4: number, n5: number, p3: ((...any) -> ...any)) -- line: 93
			-- upvalues: t1 (copy), n1 (ref)
			return p3() or (s6 ~= t1.getCasSessionId() or n5 ~= t1.getRefreshGeneration()) or n4 ~= n1
		end
		local function commitRefreshedHistory(s7: string, n6: number, t2: {[any]: any}, s8: string?, p4: ((...any) -> ...any)) -- line: 103
			-- upvalues: t1 (copy), sessionHistoryMerge (copy)
			if p4() or (s7 ~= t1.getCasSessionId() or n6 ~= t1.getRefreshGeneration()) then
				return false
			end

			local t3 = {}
			local t4 = {}

			sessionHistoryMerge.mergeHistoryIntoMap(t3, t2, t4)
			t1.setLoadedBySequenceId(t3)
			t1.setOverlayBySequenceId(t4)
			t1.setNextHistoryPageToken(s8)
			t1.noteHistorySequenceIds(t2)
			t1.notifyMergedHistoryChanged()
			t1.markHistoryLoaded()

			return true
		end
		local function prefetchOlderHistoryPagesInBackground(s9: string, s10: string?, p5: ((...any) -> ...any), n7: number, n8: number) -- line: 126
			-- upvalues: constants (copy), t1 (copy), n1 (ref), loadHistoryPage (copy)
			task.spawn(function() -- line: 133
				-- upvalues: s10 (copy), constants (copy), s9 (copy), n7 (copy), n8 (copy), p5 (copy), t1 (copy), n1 (ref), loadHistoryPage (copy)
				local v70 = s10
				local v71 = constants.getPrefetchHistoryPagesOnRefresh()

				while v71 > 0 and v70 ~= nil do
					local v72 = s9
					local v73 = n7
					local v74 = n8

					if p5() or (v72 ~= t1.getCasSessionId() or v74 ~= t1.getRefreshGeneration()) or v73 ~= n1 then
						return
					end

					local v75, v76

					v75, v76, v70 = loadHistoryPage(s9, v70, p5)

					if not v75 then
						return
					end

					local v77 = s9
					local v78 = n7
					local v79 = n8

					if p5() or (v77 ~= t1.getCasSessionId() or v79 ~= t1.getRefreshGeneration()) or v78 ~= n1 then
						return
					end

					t1.mergeHistoryPage(v76, v70)
					v71 -= 1
				end
			end)
		end
		local function beginPrefetchGeneration() -- line: 151
			-- upvalues: n1 (ref)
			n1 += 1

			return n1
		end

		return {
			refreshSession = function(p6: ((...any) -> ...any)) -- line: 156
				-- upvalues: t1 (copy), u6 (ref), historyPageUtils (copy), loadHistoryPage (copy), constants (copy), commitRefreshedHistory (copy), n1 (ref)
				local v44 = t1.getCasSessionId()

				if v44 == nil or v44 == "" then
					return false
				end

				local v45 = t1.getRefreshGeneration()
				local g46 = nil
				local v47 = nil

				repeat
					if g46 or t1.getHistoryLoadInFlight() then
						if g46 or v44 == u6 then
							if not g46 then
								v47 = false
							end

							g46 = false

							if not v47 then
								return false
							end

							local v48 = t1.buildMergedHistory()
							local v49 = historyPageUtils.collectSequenceIds(v48)
							local v50 = #v48 > 0
							local v51 = not v50
							local t5 = {}
							local t6 = {}
							local u54 = nil
							local n9 = 0

							repeat
								n9 += 1

								local v56, v57, v58 = loadHistoryPage(v44, u54, p6)

								if not v56 or (p6() or (v44 ~= t1.getCasSessionId() or v45 ~= t1.getRefreshGeneration())) then
									if v44 == u6 then
										t1.setHistoryLoadInFlight(false)
										u6 = nil
									end

									return false
								end

								if v50 and historyPageUtils.historyOverlapsSequenceIds(v57, v49) then
									v51 = true
								end

								historyPageUtils.appendUniqueHistoryBySequenceId(t5, v57, t6)
								u54 = v58
							until not v50 or v51 or u54 == nil or n9 >= constants.getMaxReconciliationHistoryPages()

							if v50 and v51 then
								if historyPageUtils.appendUniqueHistoryBySequenceId(t5, v48, t6) > 0 then
									u54 = t1.getNextHistoryPageToken()
								end
							elseif v50 then
								historyPageUtils.appendUniqueHistoryBySequenceId(t5, v48, t6)
							end

							if not commitRefreshedHistory(v44, v45, t5, u54, p6) then
								if v44 == u6 then
									t1.setHistoryLoadInFlight(false)
									u6 = nil
								end

								return false
							end

							if v44 == u6 then
								t1.setHistoryLoadInFlight(false)
								u6 = nil
							end

							if not v50 and u54 ~= nil then
								n1 += 1

								local v59 = n1

								task.defer(function() -- line: 217
									-- upvalues: v44 (copy), u54 (ref), p6 (copy), v59 (copy), v45 (copy), constants (copy), t1 (copy), n1 (ref), loadHistoryPage (copy)
									local v80 = v44
									local v81 = u54
									local v82 = p6
									local v83 = v59
									local v84 = v45

									task.spawn(function() -- line: 133
										-- upvalues: v81 (copy), constants (copy), v80 (copy), v83 (copy), v84 (copy), v82 (copy), t1 (copy), n1 (ref), loadHistoryPage (copy)
										local v90 = v81
										local v91 = constants.getPrefetchHistoryPagesOnRefresh()

										while v91 > 0 and v90 ~= nil do
											local v92 = v80
											local v93 = v83
											local v94 = v84

											if v82() or (v92 ~= t1.getCasSessionId() or v94 ~= t1.getRefreshGeneration()) or v93 ~= n1 then
												return
											end

											local v95, v96

											v95, v96, v90 = loadHistoryPage(v80, v90, v82)

											if not v95 then
												return
											end

											local v97 = v80
											local v98 = v83
											local v99 = v84

											if v82() or (v97 ~= t1.getCasSessionId() or v99 ~= t1.getRefreshGeneration()) or v98 ~= n1 then
												return
											end

											t1.mergeHistoryPage(v96, v90)
											v91 -= 1
										end
									end)
								end)
							end

							return true
						end

						t1.setHistoryLoadInFlight(false)
						u6 = nil
					end

					u6 = v44
					t1.setHistoryLoadInFlight(true)
					v47 = true
					g46 = true
				until not g46
			end,
			loadOlderHistory = function(p7: ((...any) -> ...any)) -- line: 231
				-- upvalues: t1 (copy), u6 (ref), loadHistoryPage (copy), n1 (ref), constants (copy)
				local v61 = t1.getCasSessionId()
				local v62 = t1.getNextHistoryPageToken()

				if v61 == nil or v62 == nil then
					return false
				end

				local v63 = t1.getRefreshGeneration()
				local g64 = nil
				local v65 = nil

				repeat
					if g64 or t1.getHistoryLoadInFlight() then
						if g64 or v61 == u6 then
							if not g64 then
								v65 = false
							end

							g64 = false

							if not v65 then
								return false
							end

							local v66, v67, v68 = loadHistoryPage(v61, v62, p7)

							if not v66 or (p7() or (v61 ~= t1.getCasSessionId() or v63 ~= t1.getRefreshGeneration())) then
								if v61 == u6 then
									t1.setHistoryLoadInFlight(false)
									u6 = nil
								end

								return false
							end

							t1.mergeHistoryPage(v67, v68)

							if v61 == u6 then
								t1.setHistoryLoadInFlight(false)
								u6 = nil
							end

							if p7() or (v61 ~= t1.getCasSessionId() or v63 ~= t1.getRefreshGeneration()) then
								return false
							end

							if v68 ~= nil then
								n1 += 1

								local v69 = n1

								task.defer(function() -- line: 257
									-- upvalues: v61 (copy), v68 (copy), p7 (copy), v69 (copy), v63 (copy), constants (copy), t1 (copy), n1 (ref), loadHistoryPage (copy)
									local v85 = v61
									local v86 = v68
									local v87 = p7
									local v88 = v69
									local v89 = v63

									task.spawn(function() -- line: 133
										-- upvalues: v86 (copy), constants (copy), v85 (copy), v88 (copy), v89 (copy), v87 (copy), t1 (copy), n1 (ref), loadHistoryPage (copy)
										local v100 = v86
										local v101 = constants.getPrefetchHistoryPagesOnRefresh()

										while v101 > 0 and v100 ~= nil do
											local v102 = v85
											local v103 = v88
											local v104 = v89

											if v87() or (v102 ~= t1.getCasSessionId() or v104 ~= t1.getRefreshGeneration()) or v103 ~= n1 then
												return
											end

											local v105, v106

											v105, v106, v100 = loadHistoryPage(v85, v100, v87)

											if not v105 then
												return
											end

											local v107 = v85
											local v108 = v88
											local v109 = v89

											if v87() or (v107 ~= t1.getCasSessionId() or v109 ~= t1.getRefreshGeneration()) or v108 ~= n1 then
												return
											end

											t1.mergeHistoryPage(v106, v100)
											v101 -= 1
										end
									end)
								end)
							end

							return true
						end

						t1.setHistoryLoadInFlight(false)
						u6 = nil
					end

					u6 = v61
					t1.setHistoryLoadInFlight(true)
					v65 = true
					g64 = true
				until not g64
			end
		}
	end
}
