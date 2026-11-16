local dateTime = DateTime

local WhatsNew = script:FindFirstAncestor("WhatsNew")
local parent = WhatsNew.Parent

local Enums = require(WhatsNew.Enums)
local EntryStorage = require(WhatsNew.storage.EntryStorage)
local Signals = require(parent.Signals)
require(WhatsNew.Types)
local WhatsNewTelemetry = require(WhatsNew.telemetry.WhatsNewTelemetry)
local LoadWhatsNewRegistry = require(WhatsNew.registry.LoadWhatsNewRegistry)
require(WhatsNew.registry.ScopeActions)

local function createIdleState(screenScopeId: string)
	return {
		screenScopeId = screenScopeId,
		activeTourType = nil,
		globalTotalSteps = 0,
		globalStepIndex = nil,
		currentScopeTour = nil,
		currentEntry = nil,
		currentTipIndex = 0,
		scopeStack = {},
		surface = Enums.WhatsNewSurface.Idle
	}
end

local function hasBeenSeen(id: string): boolean -- 1 equivalent call inferred from this helper
	local v = EntryStorage.getEntries()[id]
	return v ~= nil and v.seen ~= nil
end

local function isEligibleForNewSession(tourTip) -- 6 equivalent calls inferred from this helper
	return tourTip.toShow and not hasBeenSeen(tourTip.id) -- inferred equivalent call
end

local function countEligibleTips(p)
	local total = 0

	for _, tourTip in p.tourTips do
		if isEligibleForNewSession(tourTip) then -- inferred equivalent call
			total += tourTip.stepCount
		end
	end

	return total
end

local function tourHasEligibleRootTips(scopeTree): boolean -- 1 equivalent call inferred from this helper
	for _, tourTip in scopeTree.tourTips do
		if isEligibleForNewSession(tourTip) then -- inferred equivalent call
			return true
		end
	end

	return false
end

local function findFirstEligibleTipIndex(p) -- 4 equivalent calls inferred from this helper
	for k, tourTip in p.tourTips do
		if isEligibleForNewSession(tourTip) then -- inferred equivalent call
			return k
		end
	end

	return nil
end

local function findNextVisibleTipIndexFrom(p, p2: number) -- 2 equivalent calls inferred from this helper
	for i = p2, #p.tourTips do
		if p.tourTips[i].toShow then
			return i
		end
	end

	return nil
end

local function findPreviousVisibleTipIndexFrom(currentScopeTour, p: number) -- 1 equivalent call inferred from this helper
	for i = p, 1, -1 do
		if currentScopeTour.tourTips[i].toShow then
			return i
		end
	end

	return nil
end

local function findGatewayTipByOpenActionKey(scopeTree, p: string)
	for _, tourTip in scopeTree.tourTips do
		local gateway = tourTip.gateway

		if gateway ~= nil and gateway.openActionKey == p then
			return tourTip
		end

		if gateway == nil then
			continue
		end

		local v = findGatewayTipByOpenActionKey(gateway.scope, p)

		if v ~= nil then
			return v
		end
	end

	return nil
end

local function findCloseActionKeyForScope(scopeTree, id: string)
	for _, tourTip in scopeTree.tourTips do
		local gateway = tourTip.gateway

		if gateway == nil then
			continue
		end

		if gateway.scope.id == id then
			return gateway.closeActionKey
		end

		local v = findCloseActionKeyForScope(gateway.scope, id)

		if v ~= nil then
			return v
		end
	end

	return nil
end

local function getCloseActionKeyForFrame(p) -- 3 equivalent calls inferred from this helper
	local tourTip = p.parentScopeTour.tourTips[p.parentTipIndex]
	local gateway = tourTip.gateway
	assert(gateway ~= nil, `parent tip '{tourTip.id}' is missing gateway for scope stack frame`)
	return gateway.closeActionKey
end

local function popScopeStack(list) -- 1 equivalent call inferred from this helper
	local item = list[#list]
	local clone = table.clone(list)
	table.remove(clone)
	return item, clone
end

local function markEntrySeen(id: string) -- 3 equivalent calls inferred from this helper
	EntryStorage.markSeen(id, dateTime.now():ToIsoDate())
end

local function markTipsSeenFromCurrent(currentScopeTour, id: string, p)
	local function runtimeStateForTip(currentEntry) -- 1 equivalent call inferred from this helper
		local clone = table.clone(p)
		clone.currentEntry = currentEntry
		return clone
	end

	local v = false

	for _, tourTip in currentScopeTour.tourTips do
		local v2 = tourTip.id == id
		v = v2 and true or v

		if not v then
			continue
		end

		markEntrySeen(tourTip.id) -- inferred equivalent call

		if not v2 then
			WhatsNewTelemetry.logTourtipInteraction(
				WhatsNewTelemetry.InteractionType.SKIP,
				tourTip.id,
				nil,
				runtimeStateForTip(tourTip), -- inferred equivalent call
				WhatsNewTelemetry.SkipReason.TOUR_ENDED_EARLY
			)
		end
	end
end

local function createWhatsNewStore()
	local rootTourMap = nil
	local scopeActions = nil
	local flag = false

	local function assertInitialized() -- 8 equivalent calls inferred from this helper
		local v = flag

		if v then
			if rootTourMap == nil then
				v = false
			else
				v = scopeActions ~= nil
			end
		end

		assert(v, "WhatsNew store not initialized. Call initialize first.")
	end

	local function getRootTourAndScopeActions()
		assertInitialized() -- inferred equivalent call
		return rootTourMap, scopeActions
	end

	local v = {}
	local signal, v2 = Signals.createSignal(createIdleState(""))

	local function resolveSurfaceForAnchor(anchorId: string) -- 2 equivalent calls inferred from this helper
		local v3 = v[anchorId]

		if v3 == nil or not v3.isReady then
			return Enums.WhatsNewSurface.WaitingForAnchor
		end

		return Enums.WhatsNewSurface.TourTip
	end

	local function refreshSurfaceForCurrentEntry()
		local v3 = signal(false)
		local currentEntry = v3.currentEntry

		if currentEntry == nil then
			return
		end

		v2({
			scopeStack = v3.scopeStack,
			screenScopeId = v3.screenScopeId,
			activeTourType = v3.activeTourType,
			globalTotalSteps = v3.globalTotalSteps,
			globalStepIndex = v3.globalStepIndex,
			currentScopeTour = v3.currentScopeTour,
			currentEntry = currentEntry,
			currentTipIndex = v3.currentTipIndex,
			surface = resolveSurfaceForAnchor(currentEntry.anchorId) -- inferred equivalent call
		})
	end

	local function showTipAt(currentScopeTour, currentTipIndex: number, currentEntry, data)
		local v3 = signal(false)
		local v4 = {
			screenScopeId = data.screenScopeId or v3.screenScopeId,
			activeTourType = 0,
			globalTotalSteps = 0,
			globalStepIndex = 0,
			currentScopeTour = 0,
			currentEntry = 0,
			currentTipIndex = 0,
			scopeStack = 0,
			surface = 0
		}
		local activeTourType

		if data.activeTourType == nil then
			activeTourType = v3.activeTourType
		else
			activeTourType = data.activeTourType
		end

		v4.activeTourType = activeTourType
		v4.globalTotalSteps = data.globalTotalSteps or v3.globalTotalSteps
		local globalStepIndex

		if data.globalStepIndex == nil then
			globalStepIndex = v3.globalStepIndex
		else
			globalStepIndex = data.globalStepIndex
		end

		v4.globalStepIndex = globalStepIndex
		v4.currentScopeTour = currentScopeTour
		v4.currentEntry = currentEntry
		v4.currentTipIndex = currentTipIndex
		v4.scopeStack = data.scopeStack or v3.scopeStack
		v4.surface = resolveSurfaceForAnchor(currentEntry.anchorId) -- inferred equivalent call
		v2(v4)
	end

	local function resetToIdle() -- 3 equivalent calls inferred from this helper
		v2(createIdleState(signal(false).screenScopeId))
	end

	local v3 = false

	local function invokeCloseAction(object, p: string) -- 3 equivalent calls inferred from this helper
		v3 = true
		local success, result = pcall(function()
			object:invoke(p)
		end)
		v3 = false

		if not success then
			error(result)
		end
	end

	local function exitNestedScope(object, list)
		local item, clone = popScopeStack(list) -- inferred equivalent call
		invokeCloseAction(object, getCloseActionKeyForFrame(item)) -- inferred equivalent call
		return item, clone
	end

	local function markActiveScopeEndedEarly(p)
		if p.currentEntry ~= nil then
			WhatsNewTelemetry.logTourtipInteraction(
				WhatsNewTelemetry.InteractionType.DISMISS,
				p.currentEntry.id,
				WhatsNewTelemetry.Button.CLOSE,
				p
			)
		end

		local currentScopeTour = p.currentScopeTour
		local currentEntry = p.currentEntry

		if currentScopeTour ~= nil and currentEntry ~= nil then
			markTipsSeenFromCurrent(currentScopeTour, currentEntry.id, p)
		end

		WhatsNewTelemetry.logTourLifecycle(
			WhatsNewTelemetry.LifecycleType.TOUR_STOPPED,
			p,
			WhatsNewTelemetry.StopReason.DISMISS
		)
	end

	local function completeTour(p)
		local v4 = signal(false)

		if v4.surface == Enums.WhatsNewSurface.Idle then
			return
		end

		local v5

		if p == nil then
			v5 = false
		else
			v5 = p.earlyDismiss == true
		end

		if v5 then
			markActiveScopeEndedEarly(v4)
		end

		local scopeStack = v4.scopeStack
		assertInitialized() -- inferred equivalent call
		local v6 = scopeActions

		if #scopeStack > 0 then
			if not v5 then
				WhatsNewTelemetry.logTourLifecycle(WhatsNewTelemetry.LifecycleType.TOUR_COMPLETED, v4)
			end

			while #scopeStack > 0 do
				local v7 = scopeStack[#scopeStack]
				scopeStack = table.clone(scopeStack)
				table.remove(scopeStack)
				invokeCloseAction(v6, getCloseActionKeyForFrame(v7)) -- inferred equivalent call
				local nextVisibleTipIndexFrom = findNextVisibleTipIndexFrom(v7.parentScopeTour, v7.parentTipIndex + 1) -- inferred equivalent call

				if nextVisibleTipIndexFrom ~= nil then
					showTipAt(
						v7.parentScopeTour,
						nextVisibleTipIndexFrom,
						v7.parentScopeTour.tourTips[nextVisibleTipIndexFrom],
						{
							scopeStack = scopeStack,
							globalStepIndex = v7.parentGlobalStepIndex + 1,
							globalTotalSteps = v7.parentGlobalTotalSteps
						}
					)

					return
				end

				local tourTip = v7.parentScopeTour.tourTips[v7.parentTipIndex]
				local v8 = {
					screenScopeId = v4.screenScopeId,
					activeTourType = v4.activeTourType,
					globalTotalSteps = v7.parentGlobalTotalSteps,
					globalStepIndex = v7.parentGlobalStepIndex,
					currentScopeTour = v7.parentScopeTour,
					currentEntry = tourTip,
					currentTipIndex = v7.parentTipIndex,
					scopeStack = scopeStack,
					surface = v4.surface
				}

				WhatsNewTelemetry.logTourLifecycle(WhatsNewTelemetry.LifecycleType.TOUR_COMPLETED, v8)
			end

			resetToIdle() -- inferred equivalent call
		else
			if not v5 then
				WhatsNewTelemetry.logTourLifecycle(WhatsNewTelemetry.LifecycleType.TOUR_COMPLETED, v4)
			end

			local currentScopeTour = v4.currentScopeTour

			if currentScopeTour ~= nil and v4.activeTourType ~= nil and v4.screenScopeId ~= "" then
				assertInitialized() -- inferred equivalent call
				local v7 = rootTourMap[LoadWhatsNewRegistry.makeRootTourKey(v4.screenScopeId, v4.activeTourType)]

				if v7 ~= nil then
					local closeActionKeyForScope = findCloseActionKeyForScope(v7.scopeTree, currentScopeTour.id)

					if closeActionKeyForScope ~= nil then
						invokeCloseAction(v6, closeActionKeyForScope) -- inferred equivalent call
					end
				end
			end

			resetToIdle() -- inferred equivalent call
		end
	end

	local function startTour(screenScopeId: string, activeTourType)
		assertInitialized() -- inferred equivalent call
		local v4 = rootTourMap[LoadWhatsNewRegistry.makeRootTourKey(screenScopeId, activeTourType)]

		if v4 == nil then
			return
		end

		local firstEligibleTipIndex = findFirstEligibleTipIndex(v4.scopeTree) -- inferred equivalent call

		if firstEligibleTipIndex == nil then
			return
		end

		local tourTip = v4.scopeTree.tourTips[firstEligibleTipIndex]
		local scopeTree = v4.scopeTree
		local total = 0
		local v5 = {
			screenScopeId = screenScopeId,
			activeTourType = activeTourType,
			globalTotalSteps = 0,
			globalStepIndex = 0,
			scopeStack = 0
		}

		for _, tourTip2 in v4.scopeTree.tourTips do
			if isEligibleForNewSession(tourTip2) then -- inferred equivalent call
				total += tourTip2.stepCount
			end
		end

		v5.globalTotalSteps = total

		v5.scopeStack = {}
		showTipAt(scopeTree, firstEligibleTipIndex, tourTip, v5)

		WhatsNewTelemetry.logTourLifecycle(
			WhatsNewTelemetry.LifecycleType.TOUR_STARTED,
			signal(false),
			nil,
			WhatsNewTelemetry.StartContext.ROOT
		)
	end

	local function tryStartTour(screenScopeId: string, tourType): boolean -- 1 equivalent call inferred from this helper
		assertInitialized() -- inferred equivalent call
		local v4 = rootTourMap[LoadWhatsNewRegistry.makeRootTourKey(screenScopeId, tourType)]

		if v4 ~= nil and tourHasEligibleRootTips(v4.scopeTree) then -- inferred equivalent call
			startTour(screenScopeId, tourType)
			return true
		end

		return false
	end

	local flag2 = false

	local function tryEnterNestedScope(p): boolean
		if flag2 then
			return false
		end

		local v4 = signal(false)

		if
			v4.surface == Enums.WhatsNewSurface.Idle
			or v4.currentEntry == nil
			or v4.currentScopeTour == nil
			or v4.globalStepIndex == nil
		then
			return false
		end

		local currentEntry = v4.currentEntry
		local currentScopeTour = v4.currentScopeTour
		local gateway = currentEntry.gateway

		if gateway == nil or p.openActionKey ~= nil and gateway.openActionKey ~= p.openActionKey then
			return false
		end

		local scope = gateway.scope
		local firstEligibleTipIndex = findFirstEligibleTipIndex(scope) -- inferred equivalent call

		if firstEligibleTipIndex == nil then
			return false
		end

		flag2 = true
		local success, result = pcall(function()
			local clone = table.clone(v4.scopeStack)
			table.insert(clone, {
				parentTipIndex = v4.currentTipIndex,
				parentScopeTour = currentScopeTour,
				parentGlobalStepIndex = v4.globalStepIndex,
				parentGlobalTotalSteps = v4.globalTotalSteps
			})

			local tourTip = scope.tourTips[firstEligibleTipIndex]
			local total = 0
			local v5 = { scopeStack = clone, globalStepIndex = 0, globalTotalSteps = 0 }

			for _, tourTip2 in scope.tourTips do
				if isEligibleForNewSession(tourTip2) then -- inferred equivalent call
					total += tourTip2.stepCount
				end
			end

			v5.globalTotalSteps = total
			showTipAt(scope, firstEligibleTipIndex, tourTip, v5)

			WhatsNewTelemetry.logTourLifecycle(
				WhatsNewTelemetry.LifecycleType.TOUR_STARTED,
				signal(false),
				nil,
				WhatsNewTelemetry.StartContext.GATEWAY
			)
		end)
		flag2 = false

		if not success then
			error(result)
		end

		return true
	end

	local function tryStartNestedFromIdle(p: string): boolean
		local screenScopeId = signal(false).screenScopeId

		if screenScopeId == "" then
			return false
		end

		assertInitialized() -- inferred equivalent call
		local v4 = rootTourMap

		for _, tourType in Enums.TourTypeList do
			local v5 = v4[LoadWhatsNewRegistry.makeRootTourKey(screenScopeId, tourType)]

			if v5 == nil then
				continue
			end

			local gatewayTipByOpenActionKey = findGatewayTipByOpenActionKey(v5.scopeTree, p)
			local gateway

			if gatewayTipByOpenActionKey ~= nil then
				gateway = gatewayTipByOpenActionKey.gateway
			end

			if gateway == nil then
				continue
			end

			local scope = gateway.scope
			local firstEligibleTipIndex = findFirstEligibleTipIndex(scope) -- inferred equivalent call

			if firstEligibleTipIndex ~= nil then
				local tourTip = scope.tourTips[firstEligibleTipIndex]
				local total = 0
				local v6 = {
					screenScopeId = screenScopeId,
					activeTourType = tourType,
					scopeStack = {},
					globalStepIndex = 0,
					globalTotalSteps = 0
				}

				for _, tourTip2 in scope.tourTips do
					if isEligibleForNewSession(tourTip2) then -- inferred equivalent call
						total += tourTip2.stepCount
					end
				end

				v6.globalTotalSteps = total
				showTipAt(scope, firstEligibleTipIndex, tourTip, v6)

				WhatsNewTelemetry.logTourLifecycle(
					WhatsNewTelemetry.LifecycleType.TOUR_STARTED,
					signal(false),
					nil,
					WhatsNewTelemetry.StartContext.IDLE
				)

				return true
			end
		end

		return false
	end

	local function notifyScopeOpened(openActionKey: string)
		local v4 = signal(false)

		if v4.surface == Enums.WhatsNewSurface.Idle then
			tryStartNestedFromIdle(openActionKey)
			return
		end

		if v4.currentEntry == nil then
			return
		end

		local currentEntry = v4.currentEntry
		local gateway = currentEntry.gateway

		if
			gateway == nil
			or gateway.openActionKey ~= openActionKey
			or v4.currentScopeTour ~= nil and v4.currentScopeTour.id == gateway.scope.id
			or findFirstEligibleTipIndex(gateway.scope) == nil -- inferred equivalent call
		then
			return
		end

		markEntrySeen(currentEntry.id) -- inferred equivalent call
		tryEnterNestedScope({ openActionKey = openActionKey })
	end

	local function notifyScopeClosed(p: string)
		local v4 = signal(false)

		if v3 or flag2 or v4.surface == Enums.WhatsNewSurface.Idle then
			return
		end

		local scopeStack = v4.scopeStack
		local v5 = scopeStack[#scopeStack]

		if v5 == nil then
			local currentScopeTour = v4.currentScopeTour

			if currentScopeTour == nil or v4.activeTourType == nil or v4.screenScopeId == "" then
				return
			end

			assertInitialized() -- inferred equivalent call
			local v6 = rootTourMap[LoadWhatsNewRegistry.makeRootTourKey(v4.screenScopeId, v4.activeTourType)]

			if not (v6 ~= nil and findCloseActionKeyForScope(v6.scopeTree, currentScopeTour.id) == p) then
				return
			end

			completeTour({ earlyDismiss = true })
		else
			if getCloseActionKeyForFrame(v5) ~= p then -- inferred equivalent call
				return
			end

			completeTour({ earlyDismiss = true })
		end
	end

	return {
		initialize = function(p)
			if flag then
				return
			end

			rootTourMap = p.rootTourMap
			scopeActions = p.scopeActions
			assert(scopeActions ~= nil, "scopeActions is required")
			flag = true
			scopeActions:startOpenStateWiring({
				notifyScopeOpened = notifyScopeOpened,
				notifyScopeClosed = notifyScopeClosed,
				getRuntimeStateSignal = signal
			})
		end,
		resetForTests = function()
			if scopeActions ~= nil then
				scopeActions:stopOpenStateWiring()
			end

			flag = false
			rootTourMap = nil
			scopeActions = nil
			table.clear(v)
			v2(createIdleState(""))
		end,
		getRuntimeState = function()
			return signal(false)
		end,
		getRuntimeStateSignal = signal,
		getCurrentScope = function()
			return signal(false).currentScopeTour
		end,
		getCurrentEntry = function()
			return signal(false).currentEntry
		end,
		getGlobalStepIndex = function()
			return signal(false).globalStepIndex
		end,
		getGlobalTotalSteps = function()
			local v4 = signal(false)

			if v4.activeTourType == nil then
				return 0
			end

			return v4.globalTotalSteps
		end,
		registerAnchor = function(p: string, ref)
			local v4 = v[p]

			if v4 ~= nil and v4.ref == ref then
				return
			end

			if v4 ~= nil and v4.ref.Parent ~= nil then
				warn(`WhatsNew anchor '{p}' is already registered; replacing with new registration`)
			end

			v[p] = { ref = ref, isReady = false }

			local v5 = signal(false)

			if v5.currentEntry ~= nil and v5.currentEntry.anchorId == p then
				refreshSurfaceForCurrentEntry()
			end
		end,
		getAnchorRef = function(p: string)
			local v4 = v[p]

			return if v4 ~= nil then v4.ref else nil
		end,
		setAnchorReady = function(p: string, isReady: boolean, p2)
			local v4 = v[p]

			if v4 == nil or p2 ~= nil and v4.ref ~= p2 then
				return
			end

			v4.isReady = isReady
			local v5 = signal(false)

			if v5.currentEntry ~= nil and v5.currentEntry.anchorId == p then
				refreshSurfaceForCurrentEntry()
			end
		end,
		unregisterAnchor = function(p: string, p2)
			local v4 = v[p]

			if v4 == nil or p2 ~= nil and v4.ref ~= p2 then
				return
			end

			v[p] = nil
			local v5 = signal(false)

			if v5.currentEntry ~= nil and v5.currentEntry.anchorId == p then
				refreshSurfaceForCurrentEntry()
			end
		end,
		startEligibleTour = function(screenScopeId: string)
			assertInitialized() -- inferred equivalent call

			if signal(false).surface == Enums.WhatsNewSurface.Idle then
				v2(createIdleState(screenScopeId))
			end

			for _, tourType in Enums.TourTypeList do
				if tryStartTour(screenScopeId, tourType) then -- inferred equivalent call
					break
				end
			end
		end,
		startTour = startTour,
		stopTour = function()
			local v3 = signal(false)

			if v3.surface ~= Enums.WhatsNewSurface.Idle then
				WhatsNewTelemetry.logTourLifecycle(
					WhatsNewTelemetry.LifecycleType.TOUR_STOPPED,
					v3,
					WhatsNewTelemetry.StopReason.ABORT
				)
			end

			resetToIdle() -- inferred equivalent call
		end,
		next = function()
			local v4 = signal(false)

			if v4.surface == Enums.WhatsNewSurface.Idle then
				return
			end

			local v5 = v4.currentEntry ~= nil and v4.currentScopeTour ~= nil and v4.globalStepIndex ~= nil
			assert(v5, "next() called with inconsistent active tour state")

			local currentEntry = v4.currentEntry

			markEntrySeen(currentEntry.id) -- inferred equivalent call
			WhatsNewTelemetry.logTourtipInteraction(
				WhatsNewTelemetry.InteractionType.CLICK,
				currentEntry.id,
				WhatsNewTelemetry.Button.NEXT,
				v4
			)

			local currentScopeTour = v4.currentScopeTour

			local globalStepIndex = v4.globalStepIndex + 1

			if v4.globalTotalSteps <= globalStepIndex then
				completeTour()
				return
			end

			local nextVisibleTipIndexFrom = findNextVisibleTipIndexFrom(currentScopeTour, v4.currentTipIndex + 1) -- inferred equivalent call

			if nextVisibleTipIndexFrom == nil then
				completeTour()
			else
				showTipAt(
					currentScopeTour,
					nextVisibleTipIndexFrom,
					currentScopeTour.tourTips[nextVisibleTipIndexFrom],
					{ globalStepIndex = globalStepIndex }
				)
			end
		end,
		back = function()
			local v4 = signal(false)

			if v4.surface == Enums.WhatsNewSurface.Idle then
				return
			end

			local v5 = v4.currentEntry ~= nil and v4.currentScopeTour ~= nil and v4.globalStepIndex ~= nil
			assert(v5, "back() called with inconsistent active tour state")

			if v4.globalStepIndex == 0 then
				return
			end

			WhatsNewTelemetry.logTourtipInteraction(
				WhatsNewTelemetry.InteractionType.CLICK,
				v4.currentEntry.id,
				WhatsNewTelemetry.Button.BACK,
				v4
			)

			local currentScopeTour = v4.currentScopeTour
			local globalStepIndex = v4.globalStepIndex - 1
			local previousVisibleTipIndexFrom = findPreviousVisibleTipIndexFrom( -- inferred equivalent call
				currentScopeTour,
				v4.currentTipIndex - 1
			)

			if previousVisibleTipIndexFrom == nil then
				assert(false, "back() cannot resolve previous tip at globalStepIndex > 0 within current scope")
			else
				showTipAt(
					currentScopeTour,
					previousVisibleTipIndexFrom,
					currentScopeTour.tourTips[previousVisibleTipIndexFrom],
					{ globalStepIndex = globalStepIndex }
				)
			end
		end,
		notifyScopeOpened = notifyScopeOpened,
		notifyScopeClosed = notifyScopeClosed,
		completeTour = completeTour
	}
end

return createWhatsNewStore
