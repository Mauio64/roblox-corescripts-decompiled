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

			for v38, v39 in t1.getOverlayBySequenceId() do
				if t3[v38] == nil then
					t4[v38] = v39
				end
			end

			t1.setLoadedBySequenceId(t3)
			t1.setOverlayBySequenceId(t4)
			t1.setNextHistoryPageToken(s8)
			t1.noteHistorySequenceIds(t2)
			t1.notifyMergedHistoryChanged()
			t1.markHistoryLoaded()

			return true
		end
		local function prefetchOlderHistoryPagesInBackground(s9: string, s10: string?, p5: ((...any) -> ...any), n7: number, n8: number) -- line: 133
			-- upvalues: constants (copy), t1 (copy), n1 (ref), loadHistoryPage (copy)
			task.spawn(function() -- line: 140
				-- upvalues: s10 (copy), constants (copy), s9 (copy), n7 (copy), n8 (copy), p5 (copy), t1 (copy), n1 (ref), loadHistoryPage (copy)
				local v72 = s10
				local v73 = constants.getPrefetchHistoryPagesOnRefresh()

				while v73 > 0 and v72 ~= nil do
					local v74 = s9
					local v75 = n7
					local v76 = n8

					if p5() or (v74 ~= t1.getCasSessionId() or v76 ~= t1.getRefreshGeneration()) or v75 ~= n1 then
						return
					end

					local v77, v78

					v77, v78, v72 = loadHistoryPage(s9, v72, p5)

					if not v77 then
						return
					end

					local v79 = s9
					local v80 = n7
					local v81 = n8

					if p5() or (v79 ~= t1.getCasSessionId() or v81 ~= t1.getRefreshGeneration()) or v80 ~= n1 then
						return
					end

					t1.mergeHistoryPage(v78, v72)
					v73 -= 1
				end
			end)
		end
		local function beginPrefetchGeneration() -- line: 158
			-- upvalues: n1 (ref)
			n1 += 1

			return n1
		end

		return {
			refreshSession = function(p6: ((...any) -> ...any)) -- line: 163
				-- upvalues: t1 (copy), u6 (ref), historyPageUtils (copy), loadHistoryPage (copy), constants (copy), commitRefreshedHistory (copy), n1 (ref)
				local v46 = t1.getCasSessionId()

				if v46 == nil or v46 == "" then
					return false
				end

				local v47 = t1.getRefreshGeneration()
				local g48 = nil
				local v49 = nil

				repeat
					if g48 or t1.getHistoryLoadInFlight() then
						if g48 or v46 == u6 then
							if not g48 then
								v49 = false
							end

							g48 = false

							if not v49 then
								return false
							end

							local v50 = t1.buildMergedHistory()
							local v51 = historyPageUtils.collectSequenceIds(v50)
							local v52 = #v50 > 0
							local v53 = not v52
							local t5 = {}
							local t6 = {}
							local u56 = nil
							local n9 = 0

							repeat
								n9 += 1

								local v58, v59, v60 = loadHistoryPage(v46, u56, p6)

								if not v58 or (p6() or (v46 ~= t1.getCasSessionId() or v47 ~= t1.getRefreshGeneration())) then
									if v46 == u6 then
										t1.setHistoryLoadInFlight(false)
										u6 = nil
									end

									return false
								end

								if v52 and historyPageUtils.historyOverlapsSequenceIds(v59, v51) then
									v53 = true
								end

								historyPageUtils.appendUniqueHistoryBySequenceId(t5, v59, t6)
								u56 = v60
							until not v52 or v53 or u56 == nil or n9 >= constants.getMaxReconciliationHistoryPages()

							if v52 and v53 then
								if historyPageUtils.appendUniqueHistoryBySequenceId(t5, v50, t6) > 0 then
									u56 = t1.getNextHistoryPageToken()
								end
							elseif v52 then
								historyPageUtils.appendUniqueHistoryBySequenceId(t5, v50, t6)
							end

							if not commitRefreshedHistory(v46, v47, t5, u56, p6) then
								if v46 == u6 then
									t1.setHistoryLoadInFlight(false)
									u6 = nil
								end

								return false
							end

							if v46 == u6 then
								t1.setHistoryLoadInFlight(false)
								u6 = nil
							end

							if not v52 and u56 ~= nil then
								n1 += 1

								local v61 = n1

								task.defer(function() -- line: 224
									-- upvalues: v46 (copy), u56 (ref), p6 (copy), v61 (copy), v47 (copy), constants (copy), t1 (copy), n1 (ref), loadHistoryPage (copy)
									local v82 = v46
									local v83 = u56
									local v84 = p6
									local v85 = v61
									local v86 = v47

									task.spawn(function() -- line: 140
										-- upvalues: v83 (copy), constants (copy), v82 (copy), v85 (copy), v86 (copy), v84 (copy), t1 (copy), n1 (ref), loadHistoryPage (copy)
										local v92 = v83
										local v93 = constants.getPrefetchHistoryPagesOnRefresh()

										while v93 > 0 and v92 ~= nil do
											local v94 = v82
											local v95 = v85
											local v96 = v86

											if v84() or (v94 ~= t1.getCasSessionId() or v96 ~= t1.getRefreshGeneration()) or v95 ~= n1 then
												return
											end

											local v97, v98

											v97, v98, v92 = loadHistoryPage(v82, v92, v84)

											if not v97 then
												return
											end

											local v99 = v82
											local v100 = v85
											local v101 = v86

											if v84() or (v99 ~= t1.getCasSessionId() or v101 ~= t1.getRefreshGeneration()) or v100 ~= n1 then
												return
											end

											t1.mergeHistoryPage(v98, v92)
											v93 -= 1
										end
									end)
								end)
							end

							return true
						end

						t1.setHistoryLoadInFlight(false)
						u6 = nil
					end

					u6 = v46
					t1.setHistoryLoadInFlight(true)
					v49 = true
					g48 = true
				until not g48
			end,
			loadOlderHistory = function(p7: ((...any) -> ...any)) -- line: 238
				-- upvalues: t1 (copy), u6 (ref), loadHistoryPage (copy), n1 (ref), constants (copy)
				local v63 = t1.getCasSessionId()
				local v64 = t1.getNextHistoryPageToken()

				if v63 == nil or v64 == nil then
					return false
				end

				local v65 = t1.getRefreshGeneration()
				local g66 = nil
				local v67 = nil

				repeat
					if g66 or t1.getHistoryLoadInFlight() then
						if g66 or v63 == u6 then
							if not g66 then
								v67 = false
							end

							g66 = false

							if not v67 then
								return false
							end

							local v68, v69, v70 = loadHistoryPage(v63, v64, p7)

							if not v68 or (p7() or (v63 ~= t1.getCasSessionId() or v65 ~= t1.getRefreshGeneration())) then
								if v63 == u6 then
									t1.setHistoryLoadInFlight(false)
									u6 = nil
								end

								return false
							end

							t1.mergeHistoryPage(v69, v70)

							if v63 == u6 then
								t1.setHistoryLoadInFlight(false)
								u6 = nil
							end

							if p7() or (v63 ~= t1.getCasSessionId() or v65 ~= t1.getRefreshGeneration()) then
								return false
							end

							if v70 ~= nil then
								n1 += 1

								local v71 = n1

								task.defer(function() -- line: 264
									-- upvalues: v63 (copy), v70 (copy), p7 (copy), v71 (copy), v65 (copy), constants (copy), t1 (copy), n1 (ref), loadHistoryPage (copy)
									local v87 = v63
									local v88 = v70
									local v89 = p7
									local v90 = v71
									local v91 = v65

									task.spawn(function() -- line: 140
										-- upvalues: v88 (copy), constants (copy), v87 (copy), v90 (copy), v91 (copy), v89 (copy), t1 (copy), n1 (ref), loadHistoryPage (copy)
										local v102 = v88
										local v103 = constants.getPrefetchHistoryPagesOnRefresh()

										while v103 > 0 and v102 ~= nil do
											local v104 = v87
											local v105 = v90
											local v106 = v91

											if v89() or (v104 ~= t1.getCasSessionId() or v106 ~= t1.getRefreshGeneration()) or v105 ~= n1 then
												return
											end

											local v107, v108

											v107, v108, v102 = loadHistoryPage(v87, v102, v89)

											if not v107 then
												return
											end

											local v109 = v87
											local v110 = v90
											local v111 = v91

											if v89() or (v109 ~= t1.getCasSessionId() or v111 ~= t1.getRefreshGeneration()) or v110 ~= n1 then
												return
											end

											t1.mergeHistoryPage(v108, v102)
											v103 -= 1
										end
									end)
								end)
							end

							return true
						end

						t1.setHistoryLoadInFlight(false)
						u6 = nil
					end

					u6 = v63
					t1.setHistoryLoadInFlight(true)
					v67 = true
					g66 = true
				until not g66
			end
		}
	end
}
