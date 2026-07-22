local _DateTime = DateTime
local WhatsNew = script:FindFirstAncestor("WhatsNew")
local WhatsNewParent = WhatsNew.Parent
local Enums = require(WhatsNew.Enums)
local EntryStorage = require(WhatsNew.storage.EntryStorage)
local Signals = require(WhatsNewParent.Signals)

require(WhatsNew.Types)

local TourTipCtaAccess = require(WhatsNew.TourTipCtaAccess)
local WhatsNewTelemetry = require(WhatsNew.telemetry.WhatsNewTelemetry)
local LoadWhatsNewRegistry = require(WhatsNew.registry.LoadWhatsNewRegistry)

require(WhatsNew.registry.ScopeActions)

local function createIdleState() -- line: 31
	-- upvalues: Enums (copy)
	return {
		screenScopeId = "",
		activeTourType = nil,
		globalTotalSteps = 0,
		globalStepIndex = nil,
		currentScopeTour = nil,
		currentEntry = nil,
		currentTipIndex = 0,
		openMenu = nil,
		scopeStack = {},
		surface = Enums.WhatsNewSurface.Idle
	}
end
local function tourHasEligibleTips(p1) -- line: 46
	-- upvalues: TourTipCtaAccess (copy), Enums (copy), tourHasEligibleTips (copy)
	for _, v22 in p1.tourTips do
		if v22.toShow then
			return true
		end

		local v23 = TourTipCtaAccess.wrap(v22.cta)

		if v23:getKind() == Enums.TourTipCtaKind.Nested and tourHasEligibleTips(v23:getScope()) then
			return true
		end
	end

	return false
end
local function findFirstVisibleTipIndex(p2) -- line: 59
	for v25, v26 in p2.tourTips do
		if v26.toShow then
			return v25
		end
	end

	return nil
end
local function findNextVisibleTipIndexFrom(p3, n1: number) -- line: 68
	for i = n1, #p3.tourTips do
		if p3.tourTips[i].toShow then
			return i
		end
	end

	return nil
end
local function findPreviousVisibleTipIndexFrom(p4, n2: number) -- line: 77
	for i = n2, 1, -1 do
		if p4.tourTips[i].toShow then
			return i
		end
	end

	return nil
end
local function getCloseActionKeyForFrame(p5) -- line: 86
	-- upvalues: TourTipCtaAccess (copy)
	local v34 = p5.parentScopeTour.tourTips[p5.parentTipIndex]

	return TourTipCtaAccess.wrap(v34.cta):getCloseActionKey()
end
local function popScopeStack(t1: {[any]: any}) -- line: 92
	local v36 = t1[#t1]
	local v37 = table.clone(t1)

	table.remove(v37)

	return v36, v37
end
local function markEntrySeen(s1: string) -- line: 99
	-- upvalues: EntryStorage (copy), _DateTime (copy)
	EntryStorage.markSeen(s1, _DateTime.now():ToIsoDate())
end
local function markTipsSeenFromCurrent(p6, s2: string, p7) -- line: 103
	-- upvalues: EntryStorage (copy), _DateTime (copy), WhatsNewTelemetry (copy), TourTipCtaAccess (copy), Enums (copy)
	local u42 = false

	local function runtimeStateForTip(p8) -- line: 110
		-- upvalues: p7 (copy)
		local v64 = table.clone(p7)

		v64.currentEntry = p8

		return v64
	end
	local function walkScope(p9) -- line: 116
		-- upvalues: s2 (copy), u42 (ref), EntryStorage (copy), _DateTime (copy), WhatsNewTelemetry (copy), p7 (copy), TourTipCtaAccess (copy), Enums (copy), walkScope (copy)
		for _, v67 in p9.tourTips do
			local v68 = v67.id == s2

			if v68 then
				u42 = true
			end

			if u42 then
				local id = v67.id

				EntryStorage.markSeen(id, _DateTime.now():ToIsoDate())

				if not v68 then
					local logTourtipInteraction = WhatsNewTelemetry.logTourtipInteraction
					local id2 = v67.id
					local v72 = table.clone(p7)

					v72.currentEntry = v67
					logTourtipInteraction("skip", id2, nil, v72, "tour_ended_early")
				end
			end

			local v73 = TourTipCtaAccess.wrap(v67.cta)

			if v73:getKind() == Enums.TourTipCtaKind.Nested then
				walkScope(v73:getScope())
			end
		end
	end

	walkScope(p6)
end
local function createWhatsNewStore() -- line: 144
	-- upvalues: Signals (copy), createIdleState (copy), Enums (copy), WhatsNewTelemetry (copy), getCloseActionKeyForFrame (copy), LoadWhatsNewRegistry (copy), EntryStorage (copy), _DateTime (copy), TourTipCtaAccess (copy), tourHasEligibleTips (copy)
	local rootTourMap = nil
	local scopeActions = nil
	local u47 = false

	local function assertInitialized() -- line: 149
		-- upvalues: u47 (ref), rootTourMap (ref), scopeActions (ref)
		assert(u47 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")
	end
	local function getRootTourAndScopeActions() -- line: 153
		-- upvalues: u47 (ref), rootTourMap (ref), scopeActions (ref)
		assert(u47 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

		return rootTourMap, scopeActions
	end

	local t2 = {}
	local v51, v52 = Signals.createSignal((createIdleState()))

	local function resolveSurfaceForAnchor(s3: string) -- line: 161
		-- upvalues: t2 (copy), Enums (copy)
		local v75 = t2[s3]

		if v75 ~= nil and v75.isReady then
			return Enums.WhatsNewSurface.TourTip
		end

		return Enums.WhatsNewSurface.WaitingForAnchor
	end
	local function refreshSurfaceForCurrentEntry() -- line: 169
		-- upvalues: v51 (copy), v52 (copy), t2 (copy), Enums (copy)
		local v76 = v51(false)
		local currentEntry = v76.currentEntry

		if currentEntry == nil then
			return
		end

		local v78 = v52
		local t3 = {
			scopeStack = v76.scopeStack,
			screenScopeId = v76.screenScopeId,
			activeTourType = v76.activeTourType,
			globalTotalSteps = v76.globalTotalSteps,
			globalStepIndex = v76.globalStepIndex,
			currentScopeTour = v76.currentScopeTour,
			currentEntry = currentEntry,
			currentTipIndex = v76.currentTipIndex,
			openMenu = v76.openMenu
		}
		local v80 = t2[currentEntry.anchorId]

		t3.surface = if v80 == nil or not v80.isReady then Enums.WhatsNewSurface.WaitingForAnchor else Enums.WhatsNewSurface.TourTip
		v78(t3)
	end
	local function showTipAt(p10, n3: number, p11, t4: {[any]: any}) -- line: 189
		-- upvalues: v51 (copy), v52 (copy), t2 (copy), Enums (copy)
		local v85 = v51(false)
		local v86 = v52
		local t5 = {
			openMenu = nil,
			screenScopeId = t4.screenScopeId or v85.screenScopeId,
			activeTourType = if t4.activeTourType == nil then v85.activeTourType else t4.activeTourType,
			globalTotalSteps = t4.globalTotalSteps or v85.globalTotalSteps,
			globalStepIndex = if t4.globalStepIndex == nil then v85.globalStepIndex else t4.globalStepIndex,
			currentScopeTour = p10,
			currentEntry = p11,
			currentTipIndex = n3,
			scopeStack = t4.scopeStack or v85.scopeStack
		}
		local v88 = t2[p11.anchorId]

		t5.surface = if v88 == nil or not v88.isReady then Enums.WhatsNewSurface.WaitingForAnchor else Enums.WhatsNewSurface.TourTip
		v86(t5)
	end
	local function resetToIdle() -- line: 216
		-- upvalues: v52 (copy), createIdleState (copy)
		v52((createIdleState()))
	end
	local function closeScopeStack(t6: {[any]: any}) -- line: 228
		-- upvalues: u47 (ref), rootTourMap (ref), scopeActions (ref), getCloseActionKeyForFrame (copy)
		assert(u47 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

		local _ = rootTourMap
		local v92 = scopeActions

		for i = #t6, 1, -1 do
			v92:invoke(getCloseActionKeyForFrame(t6[i]))
		end
	end
	local function completeTour(p12) -- line: 235
		-- upvalues: v51 (copy), Enums (copy), WhatsNewTelemetry (copy), u47 (ref), rootTourMap (ref), scopeActions (ref), LoadWhatsNewRegistry (copy), EntryStorage (copy), _DateTime (copy), TourTipCtaAccess (copy), closeScopeStack (copy), v52 (copy), createIdleState (copy)
		local v95 = v51(false)

		if v95.surface == Enums.WhatsNewSurface.Idle or v95.surface == Enums.WhatsNewSurface.UpdateMenu then
			return
		end

		if p12 ~= nil and p12.earlyDismiss == true then
			if v95.currentEntry ~= nil then
				WhatsNewTelemetry.logTourtipInteraction("dismiss", v95.currentEntry.id, "close", v95)
			end

			if v95.activeTourType ~= nil then
				assert(u47 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

				local v96 = rootTourMap
				local _ = scopeActions
				local v98 = v96[LoadWhatsNewRegistry.makeRootTourKey(v95.screenScopeId, v95.activeTourType)]
				local currentEntry = v95.currentEntry

				if v98 ~= nil and currentEntry ~= nil then
					local scopeTree = v98.scopeTree
					local id = currentEntry.id
					local u102 = false

					local function runtimeStateForTip(p13) -- line: 110
						-- upvalues: v95 (copy)
						local v196 = table.clone(v95)

						v196.currentEntry = p13

						return v196
					end
					local function walkScope(p14) -- line: 116
						-- upvalues: id (copy), u102 (ref), EntryStorage (copy), _DateTime (copy), WhatsNewTelemetry (copy), v95 (copy), TourTipCtaAccess (copy), Enums (copy), walkScope (copy)
						for _, v199 in p14.tourTips do
							local v200 = v199.id == id

							if v200 then
								u102 = true
							end

							if u102 then
								local id3 = v199.id

								EntryStorage.markSeen(id3, _DateTime.now():ToIsoDate())

								if not v200 then
									local logTourtipInteraction = WhatsNewTelemetry.logTourtipInteraction
									local id4 = v199.id
									local v204 = table.clone(v95)

									v204.currentEntry = v199
									logTourtipInteraction("skip", id4, nil, v204, "tour_ended_early")
								end
							end

							local v205 = TourTipCtaAccess.wrap(v199.cta)

							if v205:getKind() == Enums.TourTipCtaKind.Nested then
								walkScope(v205:getScope())
							end
						end
					end

					walkScope(scopeTree)
				end
			end

			WhatsNewTelemetry.logTourLifecycle("tour_stopped", v95, "dismiss")
		else
			WhatsNewTelemetry.logTourLifecycle("tour_completed", v95)
		end

		closeScopeStack(v95.scopeStack)
		v52((createIdleState()))
	end
	local function exitNestedScope(p15, t7: {[any]: any}) -- line: 267
		-- upvalues: getCloseActionKeyForFrame (copy)
		local v107 = t7[#t7]
		local v108 = table.clone(t7)

		table.remove(v108)
		p15:invoke(getCloseActionKeyForFrame(v107))

		return v107, v108
	end
	local function resumeAfterScopeEnd(t8: {[any]: any}, p16, n4: number, n5: number) -- line: 276
		-- upvalues: showTipAt (copy), v52 (copy), createIdleState (copy), u47 (ref), rootTourMap (ref), scopeActions (ref), getCloseActionKeyForFrame (copy), resumeAfterScopeEnd (copy)
		local g115 = nil
		local v114 = nil

		for i = n4 + 1, #p16.tourTips do
			if p16.tourTips[i].toShow then
				v114 = i
				g115 = true
			end

			if g115 then
				break
			end
		end

		if not g115 then
			v114 = nil
		end

		g115 = false

		if v114 ~= nil then
			showTipAt(p16, v114, p16.tourTips[v114], {
				scopeStack = t8,
				globalStepIndex = n5
			})

			return
		end

		if #t8 == 0 then
			v52((createIdleState()))

			return
		end

		assert(u47 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

		local _ = rootTourMap
		local v117 = scopeActions
		local v118 = t8[#t8]
		local v119 = table.clone(t8)

		table.remove(v119)
		v117:invoke(getCloseActionKeyForFrame(v118))
		resumeAfterScopeEnd(v119, v118.parentScopeTour, v118.parentTipIndex, n5)
	end
	local function startTour(s4: string, p17) -- line: 301
		-- upvalues: u47 (ref), rootTourMap (ref), scopeActions (ref), LoadWhatsNewRegistry (copy), showTipAt (copy), WhatsNewTelemetry (copy), v51 (copy)
		assert(u47 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

		local v122 = rootTourMap
		local _ = scopeActions
		local v124 = v122[LoadWhatsNewRegistry.makeRootTourKey(s4, p17)]

		if v124 == nil or v124.globalTotalSteps == 0 then
			return
		end

		local g128 = nil
		local v127 = nil

		for v125, v126 in v124.scopeTree.tourTips do
			if v126.toShow then
				v127 = v125
				g128 = true
			end

			if g128 then
				break
			end
		end

		if not g128 then
			v127 = nil
		end

		g128 = false

		if v127 == nil then
			return
		end

		local v129 = v124.scopeTree.tourTips[v127]

		showTipAt(v124.scopeTree, v127, v129, {
			globalStepIndex = 0,
			screenScopeId = s4,
			activeTourType = p17,
			globalTotalSteps = v124.globalTotalSteps,
			scopeStack = {}
		})
		WhatsNewTelemetry.logTourLifecycle("tour_started", v51(false))
	end
	local function tryStartTour(s5: string, p18) -- line: 325
		-- upvalues: u47 (ref), rootTourMap (ref), scopeActions (ref), LoadWhatsNewRegistry (copy), tourHasEligibleTips (copy), startTour (copy)
		assert(u47 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

		local v132 = rootTourMap
		local _ = scopeActions
		local v134 = v132[LoadWhatsNewRegistry.makeRootTourKey(s5, p18)]

		if v134 ~= nil and v134.globalTotalSteps > 0 and tourHasEligibleTips(v134.scopeTree) then
			startTour(s5, p18)

			return true
		end

		return false
	end

	return {
		initialize = function(p19) -- line: 518
			-- upvalues: u47 (ref), rootTourMap (ref), scopeActions (ref)
			if u47 then
				return
			end

			rootTourMap = p19.rootTourMap
			scopeActions = p19.scopeActions
			u47 = true
		end,
		resetForTests = function() -- line: 527
			-- upvalues: u47 (ref), rootTourMap (ref), scopeActions (ref), t2 (copy), v52 (copy), createIdleState (copy)
			u47 = false
			rootTourMap = nil
			scopeActions = nil
			table.clear(t2)
			v52((createIdleState()))
		end,
		getRuntimeState = function() -- line: 539
			-- upvalues: v51 (copy)
			return v51(false)
		end,
		getRuntimeStateSignal = v51,
		getCurrentScope = function() -- line: 545
			-- upvalues: v51 (copy)
			return v51(false).currentScopeTour
		end,
		getCurrentEntry = function() -- line: 549
			-- upvalues: v51 (copy)
			return v51(false).currentEntry
		end,
		getOpenMenu = function() -- line: 553
			-- upvalues: v51 (copy)
			return v51(false).openMenu
		end,
		getGlobalStepIndex = function() -- line: 557
			-- upvalues: v51 (copy)
			return v51(false).globalStepIndex
		end,
		getGlobalTotalSteps = function() -- line: 561
			-- upvalues: v51 (copy)
			local v193 = v51(false)

			if v193.activeTourType == nil then
				return 0
			end

			return v193.globalTotalSteps
		end,
		registerAnchor = function(s6: string, p20) -- line: 346
			-- upvalues: t2 (copy), v51 (copy), refreshSurfaceForCurrentEntry (copy)
			local v144 = t2[s6]

			if v144 ~= nil and p20 == v144.ref then
				return
			end

			if v144 ~= nil and v144.ref.Parent ~= nil then
				warn(`WhatsNew anchor '{ s6 }' is already registered; replacing with new registration`)
			end

			t2[s6] = {
				isReady = false,
				ref = p20
			}

			local v145 = v51(false)

			if v145.currentEntry ~= nil and s6 == v145.currentEntry.anchorId then
				refreshSurfaceForCurrentEntry()
			end
		end,
		getAnchorRef = function(s7: string) -- line: 366
			-- upvalues: t2 (copy)
			local v147 = t2[s7]

			if v147 == nil then
				return nil
			end

			return v147.ref
		end,
		setAnchorReady = function(s8: string, b1: boolean, p21) -- line: 374
			-- upvalues: t2 (copy), v51 (copy), refreshSurfaceForCurrentEntry (copy)
			local v151 = t2[s8]

			if v151 == nil then
				return
			end

			if p21 ~= nil and p21 ~= v151.ref then
				return
			end

			v151.isReady = b1

			local v152 = v51(false)

			if v152.currentEntry ~= nil and s8 == v152.currentEntry.anchorId then
				refreshSurfaceForCurrentEntry()
			end
		end,
		unregisterAnchor = function(s9: string, p22) -- line: 389
			-- upvalues: t2 (copy), v51 (copy), refreshSurfaceForCurrentEntry (copy)
			local v155 = t2[s9]

			if v155 == nil then
				return
			end

			if p22 ~= nil and p22 ~= v155.ref then
				return
			end

			t2[s9] = nil

			local v156 = v51(false)

			if v156.currentEntry ~= nil and s9 == v156.currentEntry.anchorId then
				refreshSurfaceForCurrentEntry()
			end
		end,
		startEligibleTour = function(s10: string) -- line: 336
			-- upvalues: u47 (ref), rootTourMap (ref), scopeActions (ref), Enums (copy), LoadWhatsNewRegistry (copy), tourHasEligibleTips (copy), startTour (copy)
			assert(u47 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

			for _, v137 in {
				Enums.TourType.Onboarding,
				Enums.TourType.WhatsNew
			} do
				assert(u47 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

				local v138 = rootTourMap
				local _ = scopeActions
				local v140 = v138[LoadWhatsNewRegistry.makeRootTourKey(s10, v137)]
				local v141

				if v140 ~= nil and v140.globalTotalSteps > 0 and tourHasEligibleTips(v140.scopeTree) then
					startTour(s10, v137)
					v141 = true
				else
					v141 = false
				end

				if v141 then
					return
				end
			end
		end,
		startTour = startTour,
		stopTour = function() -- line: 220
			-- upvalues: v51 (copy), Enums (copy), WhatsNewTelemetry (copy), v52 (copy), createIdleState (copy)
			local v89 = v51(false)

			if v89.surface ~= Enums.WhatsNewSurface.Idle and v89.surface ~= Enums.WhatsNewSurface.UpdateMenu then
				WhatsNewTelemetry.logTourLifecycle("tour_stopped", v89, "abort")
			end

			v52((createIdleState()))
		end,
		next = function() -- line: 404
			-- upvalues: v51 (copy), Enums (copy), EntryStorage (copy), _DateTime (copy), WhatsNewTelemetry (copy), TourTipCtaAccess (copy), u47 (ref), rootTourMap (ref), scopeActions (ref), showTipAt (copy), completeTour (copy), getCloseActionKeyForFrame (copy), resumeAfterScopeEnd (copy)
			local v157 = v51(false)

			if v157.surface == Enums.WhatsNewSurface.Idle or v157.surface == Enums.WhatsNewSurface.UpdateMenu then
				return
			end

			assert(v157.currentEntry ~= nil and (v157.currentScopeTour ~= nil and v157.globalStepIndex ~= nil), "next() called with inconsistent active tour state")

			local currentEntry = v157.currentEntry
			local id = currentEntry.id

			EntryStorage.markSeen(id, _DateTime.now():ToIsoDate())
			WhatsNewTelemetry.logTourtipInteraction("click", currentEntry.id, "next", v157)

			local currentScopeTour = v157.currentScopeTour
			local v161 = TourTipCtaAccess.wrap(currentEntry.cta)
			local v162 = v161:getKind()

			if v162 == Enums.TourTipCtaKind.Nested then
				local v163 = v161:getScope()
				local g167 = nil
				local v166 = nil

				for v164, v165 in v163.tourTips do
					if v165.toShow then
						v166 = v164
						g167 = true
					end

					if g167 then
						break
					end
				end

				if not g167 then
					v166 = nil
				end

				g167 = false
				assert(v166 ~= nil, `nested tour tip '{ currentEntry.id }' has no visible child tips; loader should not emit empty nested gateways`)
				assert(u47 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

				local _ = rootTourMap

				scopeActions:invoke(v161:getOpenActionKey())

				local v169 = table.clone(v157.scopeStack)

				table.insert(v169, {
					parentTipIndex = v157.currentTipIndex,
					parentScopeTour = currentScopeTour
				})

				local v170 = v163.tourTips[v166]

				showTipAt(v163, v166, v170, {
					scopeStack = v169,
					globalStepIndex = v157.globalStepIndex + 1
				})

				return
			end

			if v162 ~= Enums.TourTipCtaKind.None then
				return
			end

			local v171 = v157.globalStepIndex + 1

			if v171 >= v157.globalTotalSteps then
				completeTour()

				return
			end

			local g174 = nil
			local v173 = nil

			for i = v157.currentTipIndex + 1, #currentScopeTour.tourTips do
				if currentScopeTour.tourTips[i].toShow then
					v173 = i
					g174 = true
				end

				if g174 then
					break
				end
			end

			if not g174 then
				v173 = nil
			end

			g174 = false

			if v173 ~= nil then
				showTipAt(currentScopeTour, v173, currentScopeTour.tourTips[v173], {
					globalStepIndex = v171
				})

				return
			end

			if #v157.scopeStack == 0 then
				completeTour()

				return
			end

			assert(u47 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

			local _ = rootTourMap
			local v176 = scopeActions
			local scopeStack = v157.scopeStack
			local v178 = scopeStack[#scopeStack]
			local v179 = table.clone(scopeStack)

			table.remove(v179)
			v176:invoke(getCloseActionKeyForFrame(v178))
			resumeAfterScopeEnd(v179, v178.parentScopeTour, v178.parentTipIndex, v171)
		end,
		back = function() -- line: 479
			-- upvalues: v51 (copy), Enums (copy), WhatsNewTelemetry (copy), showTipAt (copy), u47 (ref), rootTourMap (ref), scopeActions (ref), getCloseActionKeyForFrame (copy)
			local v180 = v51(false)

			if v180.surface == Enums.WhatsNewSurface.Idle or v180.surface == Enums.WhatsNewSurface.UpdateMenu then
				return
			end

			assert(v180.currentEntry ~= nil and (v180.currentScopeTour ~= nil and v180.globalStepIndex ~= nil), "back() called with inconsistent active tour state")

			if v180.globalStepIndex == 0 then
				return
			end

			WhatsNewTelemetry.logTourtipInteraction("click", v180.currentEntry.id, "back", v180)

			local currentScopeTour = v180.currentScopeTour
			local v182 = v180.globalStepIndex - 1
			local g185 = nil
			local v184 = nil

			for i = v180.currentTipIndex - 1, 1, -1 do
				if currentScopeTour.tourTips[i].toShow then
					v184 = i
					g185 = true
				end

				if g185 then
					break
				end
			end

			if not g185 then
				v184 = nil
			end

			g185 = false

			if v184 ~= nil then
				showTipAt(currentScopeTour, v184, currentScopeTour.tourTips[v184], {
					globalStepIndex = v182
				})

				return
			end

			assert(#v180.scopeStack > 0, "back() cannot resolve previous tip at globalStepIndex > 0")
			assert(u47 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

			local _ = rootTourMap
			local v187 = scopeActions
			local scopeStack = v180.scopeStack
			local v189 = scopeStack[#scopeStack]
			local v190 = table.clone(scopeStack)

			table.remove(v190)
			v187:invoke(getCloseActionKeyForFrame(v189))

			local v191 = v189.parentScopeTour.tourTips[v189.parentTipIndex]

			showTipAt(v189.parentScopeTour, v189.parentTipIndex, v191, {
				scopeStack = v190,
				globalStepIndex = v182
			})
		end,
		completeTour = completeTour,
		openUpdateMenu = function(_: string) -- line: 579
		end,
		closeUpdateMenu = function() -- line: 580
		end
	}
end

return createWhatsNewStore
