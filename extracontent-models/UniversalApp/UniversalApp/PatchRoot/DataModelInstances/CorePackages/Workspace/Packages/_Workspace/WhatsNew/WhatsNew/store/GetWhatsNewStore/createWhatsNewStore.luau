local WhatsNew = script:FindFirstAncestor("WhatsNew")
local WhatsNewParent = WhatsNew.Parent
local Enums = require(WhatsNew.Enums)
local Signals = require(WhatsNewParent.Signals)

require(WhatsNew.Types)

local TourTipCtaAccess = require(WhatsNew.TourTipCtaAccess)
local LoadWhatsNewRegistry = require(WhatsNew.registry.LoadWhatsNewRegistry)

require(WhatsNew.registry.ScopeActions)

local function createIdleState() -- line: 27
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
local function tourHasEligibleTips(p1) -- line: 42
	-- upvalues: TourTipCtaAccess (copy), Enums (copy), tourHasEligibleTips (copy)
	for _, v18 in p1.tourTips do
		if v18.toShow then
			return true
		end

		local v19 = TourTipCtaAccess.wrap(v18.cta)

		if v19:getKind() == Enums.TourTipCtaKind.Nested and tourHasEligibleTips(v19:getScope()) then
			return true
		end
	end

	return false
end
local function findFirstVisibleTipIndex(p2) -- line: 55
	for v21, v22 in p2.tourTips do
		if v22.toShow then
			return v21
		end
	end

	return nil
end
local function findNextVisibleTipIndexFrom(p3, n1: number) -- line: 64
	for i = n1, #p3.tourTips do
		if p3.tourTips[i].toShow then
			return i
		end
	end

	return nil
end
local function findPreviousVisibleTipIndexFrom(p4, n2: number) -- line: 73
	for i = n2, 1, -1 do
		if p4.tourTips[i].toShow then
			return i
		end
	end

	return nil
end
local function getCloseActionKeyForFrame(p5) -- line: 82
	-- upvalues: TourTipCtaAccess (copy)
	local v30 = p5.parentScopeTour.tourTips[p5.parentTipIndex]

	return TourTipCtaAccess.wrap(v30.cta):getCloseActionKey()
end
local function popScopeStack(t1: {[any]: any}) -- line: 88
	local v32 = t1[#t1]
	local v33 = table.clone(t1)

	table.remove(v33)

	return v32, v33
end
local function exitNestedScope(p6, t2: {[any]: any}) -- line: 96
	-- upvalues: getCloseActionKeyForFrame (copy)
	local v36 = t2[#t2]
	local v37 = table.clone(t2)

	table.remove(v37)
	p6:invoke(getCloseActionKeyForFrame(v36))

	return v36, v37
end
local function createWhatsNewStore() -- line: 105
	-- upvalues: Signals (copy), createIdleState (copy), Enums (copy), getCloseActionKeyForFrame (copy), LoadWhatsNewRegistry (copy), tourHasEligibleTips (copy), TourTipCtaAccess (copy)
	local rootTourMap = nil
	local scopeActions = nil
	local u40 = false

	local function assertInitialized() -- line: 110
		-- upvalues: u40 (ref), rootTourMap (ref), scopeActions (ref)
		assert(u40 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")
	end
	local function getRootTourAndScopeActions() -- line: 114
		-- upvalues: u40 (ref), rootTourMap (ref), scopeActions (ref)
		assert(u40 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

		return rootTourMap, scopeActions
	end

	local t3 = {}
	local v44, v45 = Signals.createSignal((createIdleState()))

	local function resolveSurfaceForAnchor(s1: string) -- line: 122
		-- upvalues: t3 (copy), Enums (copy)
		local v54 = t3[s1]

		if v54 ~= nil and v54.isReady then
			return Enums.WhatsNewSurface.TourTip
		end

		return Enums.WhatsNewSurface.WaitingForAnchor
	end
	local function refreshSurfaceForCurrentEntry() -- line: 130
		-- upvalues: v44 (copy), v45 (copy), t3 (copy), Enums (copy)
		local v55 = v44(false)
		local currentEntry = v55.currentEntry

		if currentEntry == nil then
			return
		end

		local v57 = v45
		local t4 = {
			scopeStack = v55.scopeStack,
			screenScopeId = v55.screenScopeId,
			activeTourType = v55.activeTourType,
			globalTotalSteps = v55.globalTotalSteps,
			globalStepIndex = v55.globalStepIndex,
			currentScopeTour = v55.currentScopeTour,
			currentEntry = currentEntry,
			currentTipIndex = v55.currentTipIndex,
			openMenu = v55.openMenu
		}
		local v59 = t3[currentEntry.anchorId]

		t4.surface = if v59 == nil or not v59.isReady then Enums.WhatsNewSurface.WaitingForAnchor else Enums.WhatsNewSurface.TourTip
		v57(t4)
	end
	local function showTipAt(p7, n3: number, p8, t5: {[any]: any}) -- line: 150
		-- upvalues: v44 (copy), v45 (copy), t3 (copy), Enums (copy)
		local v64 = v44(false)
		local v65 = v45
		local t6 = {
			openMenu = nil,
			screenScopeId = t5.screenScopeId or v64.screenScopeId,
			activeTourType = if t5.activeTourType == nil then v64.activeTourType else t5.activeTourType,
			globalTotalSteps = t5.globalTotalSteps or v64.globalTotalSteps,
			globalStepIndex = if t5.globalStepIndex == nil then v64.globalStepIndex else t5.globalStepIndex,
			currentScopeTour = p7,
			currentEntry = p8,
			currentTipIndex = n3,
			scopeStack = t5.scopeStack or v64.scopeStack
		}
		local v67 = t3[p8.anchorId]

		t6.surface = if v67 == nil or not v67.isReady then Enums.WhatsNewSurface.WaitingForAnchor else Enums.WhatsNewSurface.TourTip
		v65(t6)
	end
	local function closeScopeStack(t7: {[any]: any}) -- line: 181
		-- upvalues: u40 (ref), rootTourMap (ref), scopeActions (ref), getCloseActionKeyForFrame (copy)
		assert(u40 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

		local _ = rootTourMap
		local v70 = scopeActions

		for i = #t7, 1, -1 do
			v70:invoke(getCloseActionKeyForFrame(t7[i]))
		end
	end
	local function resumeAfterScopeEnd(t8: {[any]: any}, p9, n4: number, n5: number) -- line: 194
		-- upvalues: showTipAt (copy), v45 (copy), createIdleState (copy), u40 (ref), rootTourMap (ref), scopeActions (ref), getCloseActionKeyForFrame (copy), resumeAfterScopeEnd (copy)
		local g79 = nil
		local v78 = nil

		for i = n4 + 1, #p9.tourTips do
			if p9.tourTips[i].toShow then
				v78 = i
				g79 = true
			end

			if g79 then
				break
			end
		end

		if not g79 then
			v78 = nil
		end

		g79 = false

		if v78 ~= nil then
			showTipAt(p9, v78, p9.tourTips[v78], {
				scopeStack = t8,
				globalStepIndex = n5
			})

			return
		end

		if #t8 == 0 then
			v45((createIdleState()))

			return
		end

		assert(u40 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

		local _ = rootTourMap
		local v81 = scopeActions
		local v82 = t8[#t8]
		local v83 = table.clone(t8)

		table.remove(v83)
		v81:invoke(getCloseActionKeyForFrame(v82))
		resumeAfterScopeEnd(v83, v82.parentScopeTour, v82.parentTipIndex, n5)
	end
	local function startTour(s2: string, p10) -- line: 219
		-- upvalues: u40 (ref), rootTourMap (ref), scopeActions (ref), LoadWhatsNewRegistry (copy), showTipAt (copy)
		assert(u40 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

		local v86 = rootTourMap
		local _ = scopeActions
		local v88 = v86[LoadWhatsNewRegistry.makeRootTourKey(s2, p10)]

		if v88 == nil or v88.globalTotalSteps == 0 then
			return
		end

		local g92 = nil
		local v91 = nil

		for v89, v90 in v88.scopeTree.tourTips do
			if v90.toShow then
				v91 = v89
				g92 = true
			end

			if g92 then
				break
			end
		end

		if not g92 then
			v91 = nil
		end

		g92 = false

		if v91 == nil then
			return
		end

		local v93 = v88.scopeTree.tourTips[v91]

		showTipAt(v88.scopeTree, v91, v93, {
			globalStepIndex = 0,
			screenScopeId = s2,
			activeTourType = p10,
			globalTotalSteps = v88.globalTotalSteps,
			scopeStack = {}
		})
	end
	local function tryStartTour(s3: string, p11) -- line: 242
		-- upvalues: u40 (ref), rootTourMap (ref), scopeActions (ref), LoadWhatsNewRegistry (copy), tourHasEligibleTips (copy), startTour (copy)
		assert(u40 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

		local v96 = rootTourMap
		local _ = scopeActions
		local v98 = v96[LoadWhatsNewRegistry.makeRootTourKey(s3, p11)]

		if v98 ~= nil and v98.globalTotalSteps > 0 and tourHasEligibleTips(v98.scopeTree) then
			startTour(s3, p11)

			return true
		end

		return false
	end

	return {
		initialize = function(p12) -- line: 401
			-- upvalues: u40 (ref), rootTourMap (ref), scopeActions (ref)
			if u40 then
				return
			end

			rootTourMap = p12.rootTourMap
			scopeActions = p12.scopeActions
			u40 = true
		end,
		resetForTests = function() -- line: 410
			-- upvalues: u40 (ref), rootTourMap (ref), scopeActions (ref), t3 (copy), v45 (copy), createIdleState (copy)
			u40 = false
			rootTourMap = nil
			scopeActions = nil
			table.clear(t3)
			v45((createIdleState()))
		end,
		getRuntimeState = function() -- line: 422
			-- upvalues: v44 (copy)
			return v44(false)
		end,
		getRuntimeStateSignal = v44,
		getCurrentScope = function() -- line: 428
			-- upvalues: v44 (copy)
			return v44(false).currentScopeTour
		end,
		getCurrentEntry = function() -- line: 432
			-- upvalues: v44 (copy)
			return v44(false).currentEntry
		end,
		getOpenMenu = function() -- line: 436
			-- upvalues: v44 (copy)
			return v44(false).openMenu
		end,
		getGlobalStepIndex = function() -- line: 440
			-- upvalues: v44 (copy)
			return v44(false).globalStepIndex
		end,
		getGlobalTotalSteps = function() -- line: 444
			-- upvalues: v44 (copy)
			local v151 = v44(false)

			if v151.activeTourType == nil then
				return 0
			end

			return v151.globalTotalSteps
		end,
		registerAnchor = function(s4: string, p13) -- line: 263
			-- upvalues: t3 (copy), v44 (copy), refreshSurfaceForCurrentEntry (copy)
			t3[s4] = {
				isReady = false,
				ref = p13
			}

			local v108 = v44(false)

			if v108.currentEntry ~= nil and s4 == v108.currentEntry.anchorId then
				refreshSurfaceForCurrentEntry()
			end
		end,
		setAnchorReady = function(s5: string, b1: boolean) -- line: 274
			-- upvalues: t3 (copy), v44 (copy), refreshSurfaceForCurrentEntry (copy)
			local v111 = t3[s5]

			if v111 == nil then
				return
			end

			v111.isReady = b1

			local v112 = v44(false)

			if v112.currentEntry ~= nil and s5 == v112.currentEntry.anchorId then
				refreshSurfaceForCurrentEntry()
			end
		end,
		unregisterAnchor = function(s6: string) -- line: 286
			-- upvalues: t3 (copy), v44 (copy), refreshSurfaceForCurrentEntry (copy)
			t3[s6] = nil

			local v114 = v44(false)

			if v114.currentEntry ~= nil and s6 == v114.currentEntry.anchorId then
				refreshSurfaceForCurrentEntry()
			end
		end,
		startEligibleTour = function(s7: string) -- line: 253
			-- upvalues: u40 (ref), rootTourMap (ref), scopeActions (ref), Enums (copy), LoadWhatsNewRegistry (copy), tourHasEligibleTips (copy), startTour (copy)
			assert(u40 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

			for _, v101 in {
				Enums.TourType.Onboarding,
				Enums.TourType.WhatsNew
			} do
				assert(u40 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

				local v102 = rootTourMap
				local _ = scopeActions
				local v104 = v102[LoadWhatsNewRegistry.makeRootTourKey(s7, v101)]
				local v105

				if v104 ~= nil and v104.globalTotalSteps > 0 and tourHasEligibleTips(v104.scopeTree) then
					startTour(s7, v101)
					v105 = true
				else
					v105 = false
				end

				if v105 then
					return
				end
			end
		end,
		startTour = startTour,
		stopTour = function() -- line: 177
			-- upvalues: v45 (copy), createIdleState (copy)
			v45((createIdleState()))
		end,
		next = function() -- line: 294
			-- upvalues: v44 (copy), Enums (copy), TourTipCtaAccess (copy), u40 (ref), rootTourMap (ref), scopeActions (ref), showTipAt (copy), closeScopeStack (copy), v45 (copy), createIdleState (copy), getCloseActionKeyForFrame (copy), resumeAfterScopeEnd (copy)
			local v115 = v44(false)

			if v115.surface == Enums.WhatsNewSurface.Idle or v115.surface == Enums.WhatsNewSurface.UpdateMenu then
				return
			end

			assert(v115.currentEntry ~= nil and (v115.currentScopeTour ~= nil and v115.globalStepIndex ~= nil), "next() called with inconsistent active tour state")

			local currentEntry = v115.currentEntry
			local currentScopeTour = v115.currentScopeTour
			local v118 = TourTipCtaAccess.wrap(currentEntry.cta)
			local v119 = v118:getKind()

			if v119 == Enums.TourTipCtaKind.Nested then
				local v120 = v118:getScope()
				local g124 = nil
				local v123 = nil

				for v121, v122 in v120.tourTips do
					if v122.toShow then
						v123 = v121
						g124 = true
					end

					if g124 then
						break
					end
				end

				if not g124 then
					v123 = nil
				end

				g124 = false
				assert(v123 ~= nil, `nested tour tip '{ currentEntry.id }' has no visible child tips; loader should not emit empty nested gateways`)
				assert(u40 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

				local _ = rootTourMap

				scopeActions:invoke(v118:getOpenActionKey())

				local v126 = table.clone(v115.scopeStack)

				table.insert(v126, {
					parentTipIndex = v115.currentTipIndex,
					parentScopeTour = currentScopeTour
				})
				showTipAt(v120, v123, v120.tourTips[v123], {
					scopeStack = v126,
					globalStepIndex = v115.globalStepIndex + 1
				})

				return
			end

			if v119 ~= Enums.TourTipCtaKind.None then
				return
			end

			local v127 = v115.globalStepIndex + 1

			if v127 >= v115.globalTotalSteps then
				local v128 = v44(false)

				closeScopeStack(v128.scopeStack)
				v45((createIdleState()))

				return
			end

			local g131 = nil
			local v130 = nil

			for i = v115.currentTipIndex + 1, #currentScopeTour.tourTips do
				if currentScopeTour.tourTips[i].toShow then
					v130 = i
					g131 = true
				end

				if g131 then
					break
				end
			end

			if not g131 then
				v130 = nil
			end

			g131 = false

			if v130 ~= nil then
				showTipAt(currentScopeTour, v130, currentScopeTour.tourTips[v130], {
					globalStepIndex = v127
				})

				return
			end

			if #v115.scopeStack == 0 then
				local v132 = v44(false)

				closeScopeStack(v132.scopeStack)
				v45((createIdleState()))

				return
			end

			assert(u40 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

			local _ = rootTourMap
			local v134 = scopeActions
			local scopeStack = v115.scopeStack
			local v136 = scopeStack[#scopeStack]
			local v137 = table.clone(scopeStack)

			table.remove(v137)
			v134:invoke(getCloseActionKeyForFrame(v136))
			resumeAfterScopeEnd(v137, v136.parentScopeTour, v136.parentTipIndex, v127)
		end,
		back = function() -- line: 364
			-- upvalues: v44 (copy), Enums (copy), showTipAt (copy), u40 (ref), rootTourMap (ref), scopeActions (ref), getCloseActionKeyForFrame (copy)
			local v138 = v44(false)

			if v138.surface == Enums.WhatsNewSurface.Idle or v138.surface == Enums.WhatsNewSurface.UpdateMenu then
				return
			end

			assert(v138.currentEntry ~= nil and (v138.currentScopeTour ~= nil and v138.globalStepIndex ~= nil), "back() called with inconsistent active tour state")

			if v138.globalStepIndex == 0 then
				return
			end

			local currentScopeTour = v138.currentScopeTour
			local v140 = v138.globalStepIndex - 1
			local g143 = nil
			local v142 = nil

			for i = v138.currentTipIndex - 1, 1, -1 do
				if currentScopeTour.tourTips[i].toShow then
					v142 = i
					g143 = true
				end

				if g143 then
					break
				end
			end

			if not g143 then
				v142 = nil
			end

			g143 = false

			if v142 ~= nil then
				showTipAt(currentScopeTour, v142, currentScopeTour.tourTips[v142], {
					globalStepIndex = v140
				})

				return
			end

			assert(#v138.scopeStack > 0, "back() cannot resolve previous tip at globalStepIndex > 0")
			assert(u40 and (rootTourMap ~= nil and scopeActions ~= nil), "WhatsNew store not initialized. Call initialize first.")

			local _ = rootTourMap
			local v145 = scopeActions
			local scopeStack = v138.scopeStack
			local v147 = scopeStack[#scopeStack]
			local v148 = table.clone(scopeStack)

			table.remove(v148)
			v145:invoke(getCloseActionKeyForFrame(v147))

			local v149 = v147.parentScopeTour.tourTips[v147.parentTipIndex]

			showTipAt(v147.parentScopeTour, v147.parentTipIndex, v149, {
				scopeStack = v148,
				globalStepIndex = v140
			})
		end,
		completeTour = function() -- line: 188
			-- upvalues: v44 (copy), closeScopeStack (copy), v45 (copy), createIdleState (copy)
			local v72 = v44(false)

			closeScopeStack(v72.scopeStack)
			v45((createIdleState()))
		end,
		openUpdateMenu = function(_: string) -- line: 461
		end,
		closeUpdateMenu = function() -- line: 462
		end
	}
end

return createWhatsNewStore
