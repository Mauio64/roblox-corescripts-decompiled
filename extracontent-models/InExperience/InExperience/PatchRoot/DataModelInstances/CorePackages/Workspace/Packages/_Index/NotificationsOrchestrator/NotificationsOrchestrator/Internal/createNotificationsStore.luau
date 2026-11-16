local NotificationsOrchestrator = script:FindFirstAncestor("NotificationsOrchestrator")
local parent = NotificationsOrchestrator.Parent

require(parent.Signals)
local SignalsUtils = require(parent.SignalsUtils)
local createSessionScopedSignal = SignalsUtils.createSessionScopedSignal
local LocalUserIdStore = require(parent.LocalUserIdStore)
local localUserIdStore = LocalUserIdStore.LocalUserIdStore

local OrchestratorDebugLogger = require(NotificationsOrchestrator.Internal.OrchestratorDebugLogger)
local ExposureTracker = require(NotificationsOrchestrator.Internal.ExposureTracker)
local evaluate = require(NotificationsOrchestrator.Internal.evaluate)
local SlotGroupBySlotId = require(NotificationsOrchestrator.Config.SlotGroupBySlotId)
local SlotConfigBySlotId = require(NotificationsOrchestrator.Config.SlotConfigBySlotId)
local getSlotConfig = SlotConfigBySlotId.getSlotConfig
local slotConfigBySlotId = SlotConfigBySlotId.SlotConfigBySlotId
local SlotGroupConfigByGroupId = require(NotificationsOrchestrator.Config.SlotGroupConfigByGroupId)
local getSlotGroupConfig = SlotGroupConfigByGroupId.getSlotGroupConfig
require(NotificationsOrchestrator.Types)

local RunService = game:GetService("RunService")

local function createNotificationsStore()
	local v = {}
	local v2 = {}
	local v3 = {}
	local count = 0
	local count2 = 0
	local v4 = localUserIdStore.getCurrentUserId(false)

	local function resetQueuesIfSessionChanged() -- 3 equivalent calls inferred from this helper
		local currentUserId = localUserIdStore.getCurrentUserId(false)

		if currentUserId == v4 then
			return
		end

		v4 = currentUserId
		table.clear(v2)
		table.clear(v3)
	end

	local function slotSignals(p)
		local v5 = v[p]

		if v5 ~= nil then
			return v5
		end

		local sessionScopedSignal, setActive = createSessionScopedSignal(nil)
		local v6 = { getActive = sessionScopedSignal, setActive = setActive }

		v[p] = v6
		return v6
	end

	local function slotGroup(p) -- 2 equivalent calls inferred from this helper
		return SlotGroupBySlotId[p]
	end

	local function queueKeyForSlot(slotId) -- 1 equivalent call inferred from this helper
		local v5 = slotGroup(slotId) -- inferred equivalent call

		if v5 == nil then
			return `slot:{slotId}`
		end

		return `group:{v5}`
	end

	local function getQueue(p: string)
		local v5 = v3[p]

		if v5 ~= nil then
			return v5
		end

		local v6 = { active = nil, waiting = {} }

		v3[p] = v6
		return v6
	end

	local function publish(data)
		local payload = data.payload

		if payload == nil then
			local slotId = data.slotId
			local v5 = v[slotId]

			if v5 == nil then
				local sessionScopedSignal, setActive = createSessionScopedSignal(nil)
				v5 = { getActive = sessionScopedSignal, setActive = setActive }

				v[slotId] = v5
			end

			v5.setActive(nil)
		else
			local slotId = data.slotId
			local v5 = v[slotId]

			if v5 == nil then
				local sessionScopedSignal, setActive = createSessionScopedSignal(nil)
				v5 = { getActive = sessionScopedSignal, setActive = setActive }

				v[slotId] = v5
			end

			v5.setActive({ handle = data.handle, payload = payload })
		end
	end

	local function removeFromWaiting(list, p)
		for k, item in list do
			if item == p then
				table.remove(list, k)
				break
			end
		end
	end

	local function requestFrequency(p) -- 1 equivalent call inferred from this helper
		local lifecyclePolicy = p.lifecyclePolicy

		if lifecyclePolicy == nil then
			return nil
		end

		return lifecyclePolicy.frequency
	end

	local function resolveFrequency(data)
		local v5 = requestFrequency(data) -- inferred equivalent call

		if v5 ~= nil then
			return v5
		end

		local v6 = slotConfigBySlotId[data.slotId]

		if v6 ~= nil then
			local lifecycle = v6.lifecycle
			local frequency

			if lifecycle ~= nil then
				frequency = lifecycle.frequency
			end

			if frequency ~= nil then
				return frequency
			end
		end

		local v7 = slotGroup(data.slotId) -- inferred equivalent call

		if v7 ~= nil then
			return getSlotGroupConfig(v7).frequency
		end

		if v6 ~= nil then
			return nil
		end

		local lifecycle = getSlotConfig(data.slotId).lifecycle
		return if lifecycle ~= nil then lifecycle.frequency else nil
	end

	local function resolveWindow(frequency) -- 1 equivalent call inferred from this helper
		local window

		if frequency ~= nil then
			window = frequency.window
		end

		return if window == nil then "forever" else window
	end

	local function isEligible(lifecycleKey, p, window) -- 3 equivalent calls inferred from this helper
		return evaluate(p, window, function()
			return ExposureTracker.getExposure(lifecycleKey, window)
		end, ExposureTracker.now())
	end

	local function describeWindow(window) -- 3 equivalent calls inferred from this helper
		if typeof(window) == "table" then
			return `rolling:{window.seconds}s`
		end

		return window
	end

	local function takeHighestPriority(waiting)
		local v5 = nil

		for i = #waiting, 1, -1 do
			local item = waiting[i]

			if isEligible(item.lifecycleKey, item.frequency, item.window) then -- inferred equivalent call
				local v6

				if v5 == nil or item.priority > v5.priority then
					v6 = true
				elseif item.priority == v5.priority then
					v6 = item.submissionOrder < v5.submissionOrder
				else
					v6 = false
				end

				if v6 then
					v5 = item
				end
			else
				OrchestratorDebugLogger.logLazy(function()
					local frequency = item.frequency
					local maxImpressions

					if frequency ~= nil then
						maxImpressions = frequency.maxImpressions
					end

					local cooldownSeconds

					if frequency ~= nil then
						cooldownSeconds = frequency.cooldownSeconds
					end

					local count3 = ExposureTracker.getCount(item.lifecycleKey, item.window)
					return `drop ineligible: handle={item.handle} slotId={item.slotId} lifecycleKey={item.lifecycleKey} count={count3} maxImpressions={maxImpressions} cooldownSeconds={cooldownSeconds} window={describeWindow(item.window)}` -- inferred equivalent call
				end)

				v2[item.handle] = nil
				table.remove(waiting, i)
			end
		end

		if v5 == nil then
			return nil
		end

		removeFromWaiting(waiting, v5)
		return v5
	end

	local function removeEntry(data)
		v2[data.handle] = nil
		local v5 = v3[data.queueKey]

		if v5 == nil then
			OrchestratorDebugLogger.logLazy(function()
				return `remove: handle={data.handle} slotId={data.slotId} lifecycleKey={data.lifecycleKey} queue=missing`
			end)
		elseif v5.active == data then
			v5.active = nil
			local slotId = data.slotId
			local v6 = v[slotId]

			if v6 == nil then
				local sessionScopedSignal, setActive = createSessionScopedSignal(nil)
				v6 = { getActive = sessionScopedSignal, setActive = setActive }

				v[slotId] = v6
			end

			v6.setActive(nil)
			local active = takeHighestPriority(v5.waiting)

			if active == nil then
				OrchestratorDebugLogger.logLazy(function()
					return `remove active: handle={data.handle} slotId={data.slotId} lifecycleKey={data.lifecycleKey} slot=empty`
				end)

				return
			end

			OrchestratorDebugLogger.logLazy(function()
				return `remove active: handle={data.handle} slotId={data.slotId} lifecycleKey={data.lifecycleKey} promote={active.handle}`
			end)

			v5.active = active
			publish(active)
		else
			removeFromWaiting(v5.waiting, data)
			OrchestratorDebugLogger.logLazy(function()
				return `remove waiting: handle={data.handle} slotId={data.slotId} lifecycleKey={data.lifecycleKey}`
			end)
		end
	end

	return {
		submit = function(data)
			resetQueuesIfSessionChanged() -- inferred equivalent call
			local v5

			if data.enableOnStudio == nil then
				v5 = false
			else
				v5 = data.enableOnStudio
			end

			if not v5 and RunService:IsStudio() then
				OrchestratorDebugLogger.logLazy(function()
					return `submit discarded: slotId={data.slotId} lifecycleKey={data.lifecycleKey} reason=studio`
				end)

				return nil
			end

			OrchestratorDebugLogger.logLazy(function()
				return `submit: slotId={data.slotId} lifecycleKey={data.lifecycleKey}`
			end)

			local frequency = resolveFrequency(data)
			local window = resolveWindow(frequency) -- inferred equivalent call

			if not isEligible(data.lifecycleKey, frequency, window) then -- inferred equivalent call
				OrchestratorDebugLogger.logLazy(function()
					local maxImpressions

					if frequency ~= nil then
						maxImpressions = frequency.maxImpressions
					end

					local cooldownSeconds

					if frequency ~= nil then
						cooldownSeconds = frequency.cooldownSeconds
					end

					local count3 = ExposureTracker.getCount(data.lifecycleKey, window)
					return `submit discarded: slotId={data.slotId} lifecycleKey={data.lifecycleKey} count={count3} maxImpressions={maxImpressions} cooldownSeconds={cooldownSeconds} window={describeWindow(window)}` -- inferred equivalent call
				end)

				return nil
			end

			count += 1
			count2 += 1
			local handle2 = tostring(count)
			local active = {
				handle = handle2,
				slotId = data.slotId,
				lifecycleKey = data.lifecycleKey,
				window = window,
				frequency = frequency,
				priority = data.priority == nil and 0 or data.priority,
				payload = data.slotDisplayPayload,
				submissionOrder = count2,
				queueKey = queueKeyForSlot(data.slotId) -- inferred equivalent call
			}

			v2[handle2] = active

			local queueKey = active.queueKey
			local v6 = v3[queueKey]

			if v6 == nil then
				v6 = { active = nil, waiting = {} }

				v3[queueKey] = v6
			end

			if v6.active == nil then
				OrchestratorDebugLogger.logLazy(function()
					return `submit shown: handle={handle2} slotId={active.slotId} lifecycleKey={active.lifecycleKey}`
				end)

				v6.active = active
				publish(active)
				return handle2
			else
				local handle = v6.active.handle
				OrchestratorDebugLogger.logLazy(function()
					return `submit queued: handle={handle2} slotId={active.slotId} lifecycleKey={active.lifecycleKey} behind={handle}`
				end)

				table.insert(v6.waiting, active)
				return handle2
			end
		end,
		revoke = function(p)
			resetQueuesIfSessionChanged() -- inferred equivalent call
			OrchestratorDebugLogger.logLazy(function()
				return `revoke: handle={p}`
			end)

			local v5 = v2[p]

			if v5 == nil then
				OrchestratorDebugLogger.logLazy(function()
					return `revoke ignored: handle={p}`
				end)
			else
				removeEntry(v5)
			end
		end,
		report = function(p, p2, p3)
			resetQueuesIfSessionChanged() -- inferred equivalent call
			OrchestratorDebugLogger.logLazy(function()
				return `report: slot={p} key={p2} event={p3.type}`
			end)

			local v5 = v2[p2]

			if v5 == nil or v5.slotId ~= p then
				OrchestratorDebugLogger.logLazy(function()
					return `report ignored: slot={p} key={p2} event={p3.type}`
				end)
			elseif p3.type == "viewed" then
				ExposureTracker.record(v5.lifecycleKey, v5.window)

				local frequency = v5.frequency
				local maxImpressions

				if frequency == nil then
					maxImpressions = nil
				else
					maxImpressions = frequency.maxImpressions
				end

				local maxImpressions2

				if maxImpressions ~= nil then
					maxImpressions2 = maxImpressions + 1
				end

				if
					maxImpressions2 ~= nil
					and not isEligible(v5.lifecycleKey, { maxImpressions = maxImpressions2 }, v5.window) -- inferred equivalent call
				then
					OrchestratorDebugLogger.logLazy(function()
						local count3 = ExposureTracker.getCount(v5.lifecycleKey, v5.window)
						return `maxImpressions reached: handle={v5.handle} slotId={v5.slotId} lifecycleKey={v5.lifecycleKey} count={count3} maxImpressions={maxImpressions} window={describeWindow(v5.window)}` -- inferred equivalent call
					end)

					removeEntry(v5)
				end
			else
				if p3.type ~= "dismissed" then
					return
				end

				removeEntry(v5)
			end
		end,
		getActiveForSlot = function(p)
			local v5 = v[p]

			if v5 == nil then
				local sessionScopedSignal, setActive = createSessionScopedSignal(nil)
				v5 = { getActive = sessionScopedSignal, setActive = setActive }

				v[p] = v5
			end

			return v5.getActive
		end
	}
end

return createNotificationsStore
