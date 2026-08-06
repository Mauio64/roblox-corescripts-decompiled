local _DateTime = DateTime
local WhatsNew = script:FindFirstAncestor("WhatsNew")
local WhatsNewParent = WhatsNew.Parent
local Enums = require(WhatsNew.Enums)
local EntryStorage = require(WhatsNew.storage.EntryStorage)
local Signals = require(WhatsNewParent.Signals)

require(WhatsNew.Types)

local WhatsNewTelemetry = require(WhatsNew.telemetry.WhatsNewTelemetry)
local LoadWhatsNewRegistry = require(WhatsNew.registry.LoadWhatsNewRegistry)

require(WhatsNew.registry.ScopeActions)

local function createIdleState(s1: string) -- line: 30
	-- upvalues: Enums (copy)
	return {
		activeTourType = nil,
		globalTotalSteps = 0,
		globalStepIndex = nil,
		currentScopeTour = nil,
		currentEntry = nil,
		currentTipIndex = 0,
		screenScopeId = s1,
		scopeStack = {},
		surface = Enums.WhatsNewSurface.Idle
	}
end
local function hasBeenSeen(s2: string) -- line: 45
	-- upvalues: EntryStorage (copy)
	local v26 = EntryStorage.getEntries()[s2]

	return v26 ~= nil and v26.seen ~= nil
end
local function isEligibleForNewSession(p1) -- line: 51
	-- upvalues: EntryStorage (copy)
	local toShow = p1.toShow

	if toShow then
		local id = p1.id
		local v30 = EntryStorage.getEntries()[id]

		toShow = not (v30 ~= nil and v30.seen ~= nil)
	end

	return toShow
end
local function countEligibleTips(p2) -- line: 55
	-- upvalues: EntryStorage (copy)
	local n1 = 0

	for _, v34 in p2.tourTips do
		local toShow = v34.toShow

		if toShow then
			local id = v34.id
			local v37 = EntryStorage.getEntries()[id]

			toShow = not (v37 ~= nil and v37.seen ~= nil)
		end

		if toShow then
			n1 += v34.stepCount
		end
	end

	return n1
end
local function tourHasEligibleRootTips(p3) -- line: 66
	-- upvalues: EntryStorage (copy)
	for _, v40 in p3.tourTips do
		local toShow = v40.toShow

		if toShow then
			local id = v40.id
			local v43 = EntryStorage.getEntries()[id]

			toShow = not (v43 ~= nil and v43.seen ~= nil)
		end

		if toShow then
			return true
		end
	end

	return false
end
local function findFirstEligibleTipIndex(p4) -- line: 75
	-- upvalues: EntryStorage (copy)
	for v45, v46 in p4.tourTips do
		local toShow = v46.toShow

		if toShow then
			local id = v46.id
			local v49 = EntryStorage.getEntries()[id]

			toShow = not (v49 ~= nil and v49.seen ~= nil)
		end

		if toShow then
			return v45
		end
	end

	return nil
end
local function findNextVisibleTipIndexFrom(p5, n2: number) -- line: 85
	for i = n2, #p5.tourTips do
		if p5.tourTips[i].toShow then
			return i
		end
	end

	return nil
end
local function findPreviousVisibleTipIndexFrom(p6, n3: number) -- line: 94
	for i = n3, 1, -1 do
		if p6.tourTips[i].toShow then
			return i
		end
	end

	return nil
end
local function findGatewayTipByOpenActionKey(p7, s3: string) -- line: 103
	-- upvalues: findGatewayTipByOpenActionKey (copy)
	for _, v59 in p7.tourTips do
		local gateway = v59.gateway

		if gateway ~= nil and s3 == gateway.openActionKey then
			return v59
		end

		if gateway ~= nil then
			local v61 = findGatewayTipByOpenActionKey(gateway.scope, s3)

			if v61 == nil then
				continue
			end

			return v61
		end
	end

	return nil
end
local function findCloseActionKeyForScope(p8, s4: string) -- line: 119
	-- upvalues: findCloseActionKeyForScope (copy)
	for _, v65 in p8.tourTips do
		local gateway = v65.gateway

		if gateway == nil then
			continue
		end

		if s4 == gateway.scope.id then
			return gateway.closeActionKey
		end

		local v67 = findCloseActionKeyForScope(gateway.scope, s4)

		if v67 ~= nil then
			return v67
		end
	end

	return nil
end
local function getCloseActionKeyForFrame(p9) -- line: 135
	local v69 = p9.parentScopeTour.tourTips[p9.parentTipIndex]
	local gateway = v69.gateway

	assert(gateway ~= nil, `parent tip '{ v69.id }' is missing gateway for scope stack frame`)

	return gateway.closeActionKey
end
local function popScopeStack(t1: {[any]: any}) -- line: 143
	local v72 = t1[#t1]
	local v73 = table.clone(t1)

	table.remove(v73)

	return v72, v73
end
local function markEntrySeen(s5: string) -- line: 150
	-- upvalues: EntryStorage (copy), _DateTime (copy)
	EntryStorage.markSeen(s5, _DateTime.now():ToIsoDate())
end
local function markTipsSeenFromCurrent(p10, s6: string, p11) -- line: 154
	-- upvalues: EntryStorage (copy), _DateTime (copy), WhatsNewTelemetry (copy)
	local v78 = false

	local function runtimeStateForTip(p12) -- line: 161
		-- upvalues: p11 (copy)
		local v113 = table.clone(p11)

		v113.currentEntry = p12

		return v113
	end

	for _, v81 in p10.tourTips do
		local v82 = s6 == v81.id

		if v82 then
			v78 = true
		end

		if v78 then
			local id = v81.id

			EntryStorage.markSeen(id, _DateTime.now():ToIsoDate())

			if not v82 then
				local logTourtipInteraction = WhatsNewTelemetry.logTourtipInteraction
				local SKIP = WhatsNewTelemetry.InteractionType.SKIP
				local id2 = v81.id
				local v87 = table.clone(p11)

				v87.currentEntry = v81
				logTourtipInteraction(SKIP, id2, nil, v87, WhatsNewTelemetry.SkipReason.TOUR_ENDED_EARLY)
			end
		end
	end
end
local function createWhatsNewStore() -- line: 187
	-- upvalues: Signals (copy), createIdleState (copy), Enums (copy), WhatsNewTelemetry (copy), markTipsSeenFromCurrent (copy), LoadWhatsNewRegistry (copy), findCloseActionKeyForScope (copy), EntryStorage (copy), findGatewayTipByOpenActionKey (copy), _DateTime (copy)
	local rootTourMap = nil
	local scopeActions = nil
	local u90 = false

	local function assertInitialized() -- line: 192
		-- upvalues: u90 (ref), rootTourMap (ref), scopeActions (ref)
		assert(u90 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")
	end
	local function getRootTourAndScopeActions() -- line: 196
		-- upvalues: u90 (ref), rootTourMap (ref), scopeActions (ref)
		assert(u90 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

		return rootTourMap, scopeActions
	end

	local t2 = {}
	local v94, v95 = Signals.createSignal((createIdleState("")))

	local function resolveSurfaceForAnchor(s7: string) -- line: 204
		-- upvalues: t2 (copy), Enums (copy)
		local v115 = t2[s7]

		if v115 ~= nil and v115.isReady then
			return Enums.WhatsNewSurface.TourTip
		end

		return Enums.WhatsNewSurface.WaitingForAnchor
	end
	local function refreshSurfaceForCurrentEntry() -- line: 212
		-- upvalues: v94 (copy), v95 (copy), t2 (copy), Enums (copy)
		local v116 = v94(false)
		local currentEntry = v116.currentEntry

		if currentEntry == nil then
			return
		end

		local v118 = v95
		local t3 = {
			scopeStack = v116.scopeStack,
			screenScopeId = v116.screenScopeId,
			activeTourType = v116.activeTourType,
			globalTotalSteps = v116.globalTotalSteps,
			globalStepIndex = v116.globalStepIndex,
			currentScopeTour = v116.currentScopeTour,
			currentEntry = currentEntry,
			currentTipIndex = v116.currentTipIndex
		}
		local v120 = t2[currentEntry.anchorId]

		t3.surface = if v120 == nil or not v120.isReady then Enums.WhatsNewSurface.WaitingForAnchor else Enums.WhatsNewSurface.TourTip
		v118(t3)
	end
	local function showTipAt(p13, n4: number, p14, t4: {[any]: any}) -- line: 231
		-- upvalues: v94 (copy), v95 (copy), t2 (copy), Enums (copy)
		local v125 = v94(false)
		local v126 = v95
		local t5 = {
			screenScopeId = t4.screenScopeId or v125.screenScopeId,
			activeTourType = if t4.activeTourType == nil then v125.activeTourType else t4.activeTourType,
			globalTotalSteps = t4.globalTotalSteps or v125.globalTotalSteps,
			globalStepIndex = if t4.globalStepIndex == nil then v125.globalStepIndex else t4.globalStepIndex,
			currentScopeTour = p13,
			currentEntry = p14,
			currentTipIndex = n4,
			scopeStack = t4.scopeStack or v125.scopeStack
		}
		local v128 = t2[p14.anchorId]

		t5.surface = if v128 == nil or not v128.isReady then Enums.WhatsNewSurface.WaitingForAnchor else Enums.WhatsNewSurface.TourTip
		v126(t5)
	end
	local function resetToIdle() -- line: 257
		-- upvalues: v95 (copy), createIdleState (copy), v94 (copy)
		v95((createIdleState(v94(false).screenScopeId)))
	end

	local u100 = false

	local function invokeCloseAction(p15, s8: string) -- line: 277
		-- upvalues: u100 (ref)
		u100 = true

		local ok, result = pcall(function() -- line: 279
			-- upvalues: p15 (copy), s8 (copy)
			p15:invoke(s8)
		end)

		u100 = false

		if not ok then
			error(result)
		end
	end
	local function exitNestedScope(p16, t6: {[any]: any}) -- line: 288
		-- upvalues: u100 (ref)
		local v136 = t6[#t6]
		local v137 = table.clone(t6)

		table.remove(v137)

		local v138 = v136.parentScopeTour.tourTips[v136.parentTipIndex]
		local gateway = v138.gateway

		assert(gateway ~= nil, `parent tip '{ v138.id }' is missing gateway for scope stack frame`)

		local closeActionKey = gateway.closeActionKey

		u100 = true

		local ok, result = pcall(function() -- line: 279
			-- upvalues: p16 (copy), closeActionKey (copy)
			p16:invoke(closeActionKey)
		end)

		u100 = false

		if not ok then
			error(result)
		end

		return v136, v137
	end
	local function markActiveScopeEndedEarly(p17) -- line: 297
		-- upvalues: WhatsNewTelemetry (copy), markTipsSeenFromCurrent (copy)
		if p17.currentEntry ~= nil then
			WhatsNewTelemetry.logTourtipInteraction(WhatsNewTelemetry.InteractionType.DISMISS, p17.currentEntry.id, WhatsNewTelemetry.Button.CLOSE, p17)
		end

		local currentScopeTour = p17.currentScopeTour
		local currentEntry = p17.currentEntry

		if currentScopeTour ~= nil and currentEntry ~= nil then
			markTipsSeenFromCurrent(currentScopeTour, currentEntry.id, p17)
		end

		WhatsNewTelemetry.logTourLifecycle(WhatsNewTelemetry.LifecycleType.TOUR_STOPPED, p17, WhatsNewTelemetry.StopReason.DISMISS)
	end
	local function completeTour(p18) -- line: 321
		-- upvalues: v94 (copy), Enums (copy), markActiveScopeEndedEarly (copy), u90 (ref), rootTourMap (ref), scopeActions (ref), WhatsNewTelemetry (copy), u100 (ref), showTipAt (copy), v95 (copy), createIdleState (copy), LoadWhatsNewRegistry (copy), findCloseActionKeyForScope (copy)
		local v147 = v94(false)

		if v147.surface == Enums.WhatsNewSurface.Idle then
			return
		end

		local v148 = p18 ~= nil and p18.earlyDismiss == true
		local g161 = nil
		local v160 = nil

		if v148 then
			markActiveScopeEndedEarly(v147)
		end

		local scopeStack = v147.scopeStack

		assert(u90 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

		local _ = rootTourMap
		local v151 = scopeActions

		if #scopeStack > 0 then
			if not v148 then
				WhatsNewTelemetry.logTourLifecycle(WhatsNewTelemetry.LifecycleType.TOUR_COMPLETED, v147)
			end

			while #scopeStack > 0 do
				local v152 = scopeStack[#scopeStack]

				scopeStack = table.clone(scopeStack)
				table.remove(scopeStack)

				local v153 = v152.parentScopeTour.tourTips[v152.parentTipIndex]
				local gateway = v153.gateway

				assert(gateway ~= nil, `parent tip '{ v153.id }' is missing gateway for scope stack frame`)

				local closeActionKey = gateway.closeActionKey

				u100 = true

				local ok, result = pcall(function() -- line: 279
					-- upvalues: v151 (copy), closeActionKey (copy)
					v151:invoke(closeActionKey)
				end)

				u100 = false

				if not ok then
					error(result)
				end

				local parentScopeTour = v152.parentScopeTour

				for i = v152.parentTipIndex + 1, #parentScopeTour.tourTips do
					if parentScopeTour.tourTips[i].toShow then
						v160 = i
						g161 = true
					end

					if g161 then
						break
					end
				end

				if not g161 then
					v160 = nil
				end

				g161 = false

				if v160 ~= nil then
					showTipAt(v152.parentScopeTour, v160, v152.parentScopeTour.tourTips[v160], {
						scopeStack = scopeStack,
						globalStepIndex = v152.parentGlobalStepIndex + 1,
						globalTotalSteps = v152.parentGlobalTotalSteps
					})

					return
				end

				local v162 = v152.parentScopeTour.tourTips[v152.parentTipIndex]
				local t7 = {
					screenScopeId = v147.screenScopeId,
					activeTourType = v147.activeTourType,
					globalTotalSteps = v152.parentGlobalTotalSteps,
					globalStepIndex = v152.parentGlobalStepIndex,
					currentScopeTour = v152.parentScopeTour,
					currentEntry = v162,
					currentTipIndex = v152.parentTipIndex,
					scopeStack = scopeStack,
					surface = v147.surface
				}

				WhatsNewTelemetry.logTourLifecycle(WhatsNewTelemetry.LifecycleType.TOUR_COMPLETED, t7)
			end

			v95((createIdleState(v94(false).screenScopeId)))

			return
		end

		if not v148 then
			WhatsNewTelemetry.logTourLifecycle(WhatsNewTelemetry.LifecycleType.TOUR_COMPLETED, v147)
		end

		local currentScopeTour = v147.currentScopeTour

		if currentScopeTour ~= nil and v147.activeTourType ~= nil and v147.screenScopeId ~= "" then
			assert(u90 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

			local v165 = rootTourMap
			local _ = scopeActions
			local v167 = v165[LoadWhatsNewRegistry.makeRootTourKey(v147.screenScopeId, v147.activeTourType)]

			if v167 ~= nil then
				local v168 = findCloseActionKeyForScope(v167.scopeTree, currentScopeTour.id)

				if v168 ~= nil then
					u100 = true

					local ok, result = pcall(function() -- line: 279
						-- upvalues: v151 (copy), v168 (copy)
						v151:invoke(v168)
					end)

					u100 = false

					if not ok then
						error(result)
					end
				end
			end
		end

		v95((createIdleState(v94(false).screenScopeId)))
	end
	local function startTour(s9: string, p19) -- line: 395
		-- upvalues: u90 (ref), rootTourMap (ref), scopeActions (ref), LoadWhatsNewRegistry (copy), EntryStorage (copy), showTipAt (copy), WhatsNewTelemetry (copy), v94 (copy)
		assert(u90 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

		local v173 = rootTourMap
		local _ = scopeActions
		local v175 = v173[LoadWhatsNewRegistry.makeRootTourKey(s9, p19)]

		if v175 == nil then
			return
		end

		local g182 = nil
		local v181 = nil

		for v176, v177 in v175.scopeTree.tourTips do
			local toShow = v177.toShow

			if toShow then
				local id = v177.id
				local v180 = EntryStorage.getEntries()[id]

				toShow = not (v180 ~= nil and v180.seen ~= nil)
			end

			if toShow then
				v181 = v176
				g182 = true
			end

			if g182 then
				break
			end
		end

		if not g182 then
			v181 = nil
		end

		g182 = false

		if v181 == nil then
			return
		end

		local v183 = v175.scopeTree.tourTips[v181]
		local v184 = showTipAt
		local scopeTree = v175.scopeTree
		local t8 = {
			globalStepIndex = 0,
			screenScopeId = s9,
			activeTourType = p19
		}
		local n5 = 0

		for _, v189 in v175.scopeTree.tourTips do
			local toShow = v189.toShow

			if toShow then
				local id = v189.id
				local v192 = EntryStorage.getEntries()[id]

				toShow = not (v192 ~= nil and v192.seen ~= nil)
			end

			if toShow then
				n5 += v189.stepCount
			end
		end

		t8.globalTotalSteps = n5
		t8.scopeStack = {}
		v184(scopeTree, v181, v183, t8)
		WhatsNewTelemetry.logTourLifecycle(WhatsNewTelemetry.LifecycleType.TOUR_STARTED, v94(false), nil, WhatsNewTelemetry.StartContext.ROOT)
	end
	local function tryStartTour(s10: string, p20) -- line: 424
		-- upvalues: u90 (ref), rootTourMap (ref), scopeActions (ref), LoadWhatsNewRegistry (copy), EntryStorage (copy), startTour (copy)
		assert(u90 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

		local v195 = rootTourMap
		local _ = scopeActions
		local v197 = v195[LoadWhatsNewRegistry.makeRootTourKey(s10, p20)]

		if v197 ~= nil then
			local g204 = nil
			local v203 = nil

			for _, v199 in v197.scopeTree.tourTips do
				local toShow = v199.toShow

				if toShow then
					local id = v199.id
					local v202 = EntryStorage.getEntries()[id]

					toShow = not (v202 ~= nil and v202.seen ~= nil)
				end

				if toShow then
					v203 = true
					g204 = true
				end

				if g204 then
					break
				end
			end

			if not g204 then
				v203 = false
			end

			g204 = false

			if v203 then
				startTour(s10, p20)

				return true
			end
		end

		return false
	end

	local u107 = false

	local function tryEnterNestedScope(t9: {[any]: any}) -- line: 510
		-- upvalues: u107 (ref), v94 (copy), Enums (copy), EntryStorage (copy), showTipAt (copy), WhatsNewTelemetry (copy)
		if u107 then
			return false
		end

		local v236 = v94(false)

		if v236.surface == Enums.WhatsNewSurface.Idle or v236.currentEntry == nil or v236.currentScopeTour == nil or v236.globalStepIndex == nil then
			return false
		end

		local currentEntry = v236.currentEntry
		local currentScopeTour = v236.currentScopeTour
		local gateway = currentEntry.gateway

		if gateway == nil or t9.openActionKey ~= nil and gateway.openActionKey ~= t9.openActionKey then
			return false
		end

		local scope = gateway.scope
		local g247 = nil
		local v246 = nil

		for v241, v242 in scope.tourTips do
			local toShow = v242.toShow

			if toShow then
				local id = v242.id
				local v245 = EntryStorage.getEntries()[id]

				toShow = not (v245 ~= nil and v245.seen ~= nil)
			end

			if toShow then
				v246 = v241
				g247 = true
			end

			if g247 then
				break
			end
		end

		if not g247 then
			v246 = nil
		end

		g247 = false

		local v248 = v246

		if v248 == nil then
			return false
		end

		u107 = true

		local ok, result = pcall(function() -- line: 541
			-- upvalues: v236 (copy), currentScopeTour (copy), scope (copy), v248 (copy), showTipAt (copy), EntryStorage (copy), WhatsNewTelemetry (copy), v94 (copy)
			local v315 = table.clone(v236.scopeStack)

			table.insert(v315, {
				parentTipIndex = v236.currentTipIndex,
				parentScopeTour = currentScopeTour,
				parentGlobalStepIndex = v236.globalStepIndex,
				parentGlobalTotalSteps = v236.globalTotalSteps
			})

			local v316 = scope.tourTips[v248]
			local v317 = showTipAt
			local v318 = scope
			local v319 = v248
			local t10 = {
				globalStepIndex = 0,
				scopeStack = v315
			}
			local n6 = 0

			for _, v323 in scope.tourTips do
				local toShow = v323.toShow

				if toShow then
					local id = v323.id
					local v326 = EntryStorage.getEntries()[id]

					toShow = not (v326 ~= nil and v326.seen ~= nil)
				end

				if toShow then
					n6 += v323.stepCount
				end
			end

			t10.globalTotalSteps = n6
			v317(v318, v319, v316, t10)
			WhatsNewTelemetry.logTourLifecycle(WhatsNewTelemetry.LifecycleType.TOUR_STARTED, v94(false), nil, WhatsNewTelemetry.StartContext.GATEWAY)
		end)

		u107 = false

		if not ok then
			error(result)
		end

		return true
	end
	local function tryStartNestedFromIdle(s11: string) -- line: 570
		-- upvalues: v94 (copy), u90 (ref), rootTourMap (ref), scopeActions (ref), Enums (copy), LoadWhatsNewRegistry (copy), findGatewayTipByOpenActionKey (copy), EntryStorage (copy), showTipAt (copy), WhatsNewTelemetry (copy)
		local screenScopeId = v94(false).screenScopeId

		if screenScopeId == "" then
			return false
		end

		assert(u90 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

		local v253 = rootTourMap
		local _ = scopeActions
		local g267 = nil
		local v266 = nil

		for _, v256 in Enums.TourTypeList do
			local v257 = v253[LoadWhatsNewRegistry.makeRootTourKey(screenScopeId, v256)]

			if v257 == nil then
				continue
			end

			local v258 = findGatewayTipByOpenActionKey(v257.scopeTree, s11)
			local v259 = if v258 == nil then nil else v258.gateway

			if v259 ~= nil then
				local scope = v259.scope

				for v261, v262 in scope.tourTips do
					local toShow = v262.toShow

					if toShow then
						local id = v262.id
						local v265 = EntryStorage.getEntries()[id]

						toShow = not (v265 ~= nil and v265.seen ~= nil)
					end

					if toShow then
						v266 = v261
						g267 = true
					end

					if g267 then
						break
					end
				end

				if not g267 then
					v266 = nil
				end

				g267 = false

				if v266 == nil then
					continue
				end

				local v268 = scope.tourTips[v266]
				local v269 = showTipAt
				local t11 = {
					globalStepIndex = 0,
					screenScopeId = screenScopeId,
					activeTourType = v256,
					scopeStack = {}
				}
				local n7 = 0

				for _, v273 in scope.tourTips do
					local toShow = v273.toShow

					if toShow then
						local id = v273.id
						local v276 = EntryStorage.getEntries()[id]

						toShow = not (v276 ~= nil and v276.seen ~= nil)
					end

					if toShow then
						n7 += v273.stepCount
					end
				end

				t11.globalTotalSteps = n7
				v269(scope, v266, v268, t11)
				WhatsNewTelemetry.logTourLifecycle(WhatsNewTelemetry.LifecycleType.TOUR_STARTED, v94(false), nil, WhatsNewTelemetry.StartContext.IDLE)

				return true
			end
		end

		return false
	end
	local function notifyScopeOpened(s12: string) -- line: 610
		-- upvalues: v94 (copy), Enums (copy), tryStartNestedFromIdle (copy), EntryStorage (copy), _DateTime (copy), tryEnterNestedScope (copy)
		local v278 = v94(false)

		if v278.surface == Enums.WhatsNewSurface.Idle then
			tryStartNestedFromIdle(s12)

			return
		end

		if v278.currentEntry == nil then
			return
		end

		local currentEntry = v278.currentEntry
		local gateway = currentEntry.gateway

		if gateway == nil or s12 ~= gateway.openActionKey then
			return
		end

		if v278.currentScopeTour ~= nil and v278.currentScopeTour.id == gateway.scope.id then
			return
		end

		local g287 = nil
		local v286 = nil

		for v281, v282 in gateway.scope.tourTips do
			local toShow = v282.toShow

			if toShow then
				local id = v282.id
				local v285 = EntryStorage.getEntries()[id]

				toShow = not (v285 ~= nil and v285.seen ~= nil)
			end

			if toShow then
				v286 = v281
				g287 = true
			end

			if g287 then
				break
			end
		end

		if not g287 then
			v286 = nil
		end

		g287 = false

		if v286 == nil then
			return
		end

		local id = currentEntry.id

		EntryStorage.markSeen(id, _DateTime.now():ToIsoDate())
		tryEnterNestedScope({
			openActionKey = s12
		})
	end
	local function notifyScopeClosed(s13: string) -- line: 643
		-- upvalues: v94 (copy), u100 (ref), u107 (ref), Enums (copy), completeTour (copy), u90 (ref), rootTourMap (ref), scopeActions (ref), LoadWhatsNewRegistry (copy), findCloseActionKeyForScope (copy)
		local v290 = v94(false)

		if u100 or (u107 or v290.surface == Enums.WhatsNewSurface.Idle) then
			return
		end

		local scopeStack = v290.scopeStack
		local v292 = scopeStack[#scopeStack]

		if v292 ~= nil then
			local v293 = v292.parentScopeTour.tourTips[v292.parentTipIndex]
			local gateway = v293.gateway

			assert(gateway ~= nil, `parent tip '{ v293.id }' is missing gateway for scope stack frame`)

			if s13 ~= gateway.closeActionKey then
				return
			end

			completeTour({
				earlyDismiss = true
			})

			return
		end

		local currentScopeTour = v290.currentScopeTour

		if currentScopeTour == nil or v290.activeTourType == nil or v290.screenScopeId == "" then
			return
		end

		assert(u90 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

		local v296 = rootTourMap
		local _ = scopeActions
		local v298 = v296[LoadWhatsNewRegistry.makeRootTourKey(v290.screenScopeId, v290.activeTourType)]

		if v298 == nil then
			return
		end

		if s13 ~= findCloseActionKeyForScope(v298.scopeTree, currentScopeTour.id) then
			return
		end

		completeTour({
			earlyDismiss = true
		})
	end

	return {
		initialize = function(p21) -- line: 754
			-- upvalues: u90 (ref), rootTourMap (ref), scopeActions (ref), notifyScopeOpened (copy), notifyScopeClosed (copy), v94 (copy)
			if u90 then
				return
			end

			rootTourMap = p21.rootTourMap
			scopeActions = p21.scopeActions
			assert(scopeActions ~= nil, "scopeActions is required")
			u90 = true
			scopeActions:startOpenStateWiring({
				notifyScopeOpened = notifyScopeOpened,
				notifyScopeClosed = notifyScopeClosed,
				getRuntimeStateSignal = v94
			})
		end,
		resetForTests = function() -- line: 769
			-- upvalues: scopeActions (ref), u90 (ref), rootTourMap (ref), t2 (copy), v95 (copy), createIdleState (copy)
			if scopeActions ~= nil then
				scopeActions:stopOpenStateWiring()
			end

			u90 = false
			rootTourMap = nil
			scopeActions = nil
			table.clear(t2)
			v95((createIdleState("")))
		end,
		getRuntimeState = function() -- line: 784
			-- upvalues: v94 (copy)
			return v94(false)
		end,
		getRuntimeStateSignal = v94,
		getCurrentScope = function() -- line: 790
			-- upvalues: v94 (copy)
			return v94(false).currentScopeTour
		end,
		getCurrentEntry = function() -- line: 794
			-- upvalues: v94 (copy)
			return v94(false).currentEntry
		end,
		getGlobalStepIndex = function() -- line: 798
			-- upvalues: v94 (copy)
			return v94(false).globalStepIndex
		end,
		getGlobalTotalSteps = function() -- line: 802
			-- upvalues: v94 (copy)
			local v314 = v94(false)

			if v314.activeTourType == nil then
				return 0
			end

			return v314.globalTotalSteps
		end,
		registerAnchor = function(s14: string, p22) -- line: 449
			-- upvalues: t2 (copy), v94 (copy), refreshSurfaceForCurrentEntry (copy)
			local v222 = t2[s14]

			if v222 ~= nil and p22 == v222.ref then
				return
			end

			if v222 ~= nil and v222.ref.Parent ~= nil then
				warn(`WhatsNew anchor '{ s14 }' is already registered; replacing with new registration`)
			end

			t2[s14] = {
				isReady = false,
				ref = p22
			}

			local v223 = v94(false)

			if v223.currentEntry ~= nil and s14 == v223.currentEntry.anchorId then
				refreshSurfaceForCurrentEntry()
			end
		end,
		getAnchorRef = function(s15: string) -- line: 469
			-- upvalues: t2 (copy)
			local v225 = t2[s15]

			if v225 == nil then
				return nil
			end

			return v225.ref
		end,
		setAnchorReady = function(s16: string, b1: boolean, p23) -- line: 477
			-- upvalues: t2 (copy), v94 (copy), refreshSurfaceForCurrentEntry (copy)
			local v229 = t2[s16]

			if v229 == nil then
				return
			end

			if p23 ~= nil and p23 ~= v229.ref then
				return
			end

			v229.isReady = b1

			local v230 = v94(false)

			if v230.currentEntry ~= nil and s16 == v230.currentEntry.anchorId then
				refreshSurfaceForCurrentEntry()
			end
		end,
		unregisterAnchor = function(s17: string, p24) -- line: 492
			-- upvalues: t2 (copy), v94 (copy), refreshSurfaceForCurrentEntry (copy)
			local v233 = t2[s17]

			if v233 == nil then
				return
			end

			if p24 ~= nil and p24 ~= v233.ref then
				return
			end

			t2[s17] = nil

			local v234 = v94(false)

			if v234.currentEntry ~= nil and s17 == v234.currentEntry.anchorId then
				refreshSurfaceForCurrentEntry()
			end
		end,
		startEligibleTour = function(s18: string) -- line: 434
			-- upvalues: u90 (ref), rootTourMap (ref), scopeActions (ref), v94 (copy), Enums (copy), v95 (copy), createIdleState (copy), LoadWhatsNewRegistry (copy), EntryStorage (copy), startTour (copy)
			assert(u90 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

			local g211 = nil
			local g218 = nil
			local v217 = nil
			local v219 = nil

			if v94(false).surface == Enums.WhatsNewSurface.Idle then
				v95((createIdleState(s18)))
			end

			for _, v207 in Enums.TourTypeList do
				assert(u90 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

				local v208 = rootTourMap
				local _ = scopeActions
				local v210 = v208[LoadWhatsNewRegistry.makeRootTourKey(s18, v207)]

				repeat
					if not g211 and v210 ~= nil then
						for _, v213 in v210.scopeTree.tourTips do
							local toShow = v213.toShow

							if toShow then
								local id = v213.id
								local v216 = EntryStorage.getEntries()[id]

								toShow = not (v216 ~= nil and v216.seen ~= nil)
							end

							if toShow then
								v217 = true
								g218 = true
							end

							if g218 then
								break
							end
						end

						if not g218 then
							v217 = false
						end

						g218 = false

						if not v217 then
							g211 = true
						end

						if not g211 then
							startTour(s18, v207)
							v219 = true
						end
					else
						g211 = false
						v219 = false
					end
				until not g211

				if v219 then
					return
				end
			end
		end,
		startTour = startTour,
		stopTour = function() -- line: 261
			-- upvalues: v94 (copy), Enums (copy), WhatsNewTelemetry (copy), v95 (copy), createIdleState (copy)
			local v129 = v94(false)

			if v129.surface ~= Enums.WhatsNewSurface.Idle then
				WhatsNewTelemetry.logTourLifecycle(WhatsNewTelemetry.LifecycleType.TOUR_STOPPED, v129, WhatsNewTelemetry.StopReason.ABORT)
			end

			v95((createIdleState(v94(false).screenScopeId)))
		end,
		next = function() -- line: 678
			-- upvalues: v94 (copy), Enums (copy), EntryStorage (copy), _DateTime (copy), WhatsNewTelemetry (copy), completeTour (copy), showTipAt (copy)
			local v299 = v94(false)

			if v299.surface == Enums.WhatsNewSurface.Idle then
				return
			end

			assert(v299.currentEntry ~= nil and (v299.currentScopeTour ~= nil and v299.globalStepIndex ~= nil), "next() called with inconsistent active tour state")

			local currentEntry = v299.currentEntry
			local id = currentEntry.id

			EntryStorage.markSeen(id, _DateTime.now():ToIsoDate())
			WhatsNewTelemetry.logTourtipInteraction(WhatsNewTelemetry.InteractionType.CLICK, currentEntry.id, WhatsNewTelemetry.Button.NEXT, v299)

			local currentScopeTour = v299.currentScopeTour
			local v303 = v299.globalStepIndex + 1

			if v303 >= v299.globalTotalSteps then
				completeTour()

				return
			end

			local g306 = nil
			local v305 = nil

			for i = v299.currentTipIndex + 1, #currentScopeTour.tourTips do
				if currentScopeTour.tourTips[i].toShow then
					v305 = i
					g306 = true
				end

				if g306 then
					break
				end
			end

			if not g306 then
				v305 = nil
			end

			g306 = false

			if v305 ~= nil then
				showTipAt(currentScopeTour, v305, currentScopeTour.tourTips[v305], {
					globalStepIndex = v303
				})

				return
			end

			completeTour()
		end,
		back = function() -- line: 718
			-- upvalues: v94 (copy), Enums (copy), WhatsNewTelemetry (copy), showTipAt (copy)
			local v307 = v94(false)

			if v307.surface == Enums.WhatsNewSurface.Idle then
				return
			end

			assert(v307.currentEntry ~= nil and (v307.currentScopeTour ~= nil and v307.globalStepIndex ~= nil), "back() called with inconsistent active tour state")

			if v307.globalStepIndex == 0 then
				return
			end

			WhatsNewTelemetry.logTourtipInteraction(WhatsNewTelemetry.InteractionType.CLICK, v307.currentEntry.id, WhatsNewTelemetry.Button.BACK, v307)

			local currentScopeTour = v307.currentScopeTour
			local v309 = v307.globalStepIndex - 1
			local g312 = nil
			local v311 = nil

			for i = v307.currentTipIndex - 1, 1, -1 do
				if currentScopeTour.tourTips[i].toShow then
					v311 = i
					g312 = true
				end

				if g312 then
					break
				end
			end

			if not g312 then
				v311 = nil
			end

			g312 = false

			if v311 ~= nil then
				showTipAt(currentScopeTour, v311, currentScopeTour.tourTips[v311], {
					globalStepIndex = v309
				})

				return
			end

			assert(false, "back() cannot resolve previous tip at globalStepIndex > 0 within current scope")
		end,
		notifyScopeOpened = notifyScopeOpened,
		notifyScopeClosed = notifyScopeClosed,
		completeTour = completeTour
	}
end

return createWhatsNewStore
