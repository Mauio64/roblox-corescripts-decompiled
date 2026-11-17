local NotificationsOrchestrator = script:FindFirstAncestor("NotificationsOrchestrator")
local parent = NotificationsOrchestrator.Parent

require(parent.Signals)
local SignalsUtils = require(parent.SignalsUtils)
local createSessionScopedSignal = SignalsUtils.createSessionScopedSignal
local LocalUserIdStore = require(parent.LocalUserIdStore)
local localUserIdStore = LocalUserIdStore.LocalUserIdStore

local OrchestratorDebugLogger = require(NotificationsOrchestrator.Internal.OrchestratorDebugLogger)
local ExposureTracker = require(NotificationsOrchestrator.Internal.ExposureTracker)

local FFlagEnableNotificationsOrchestratorUnifiedLogging = require(NotificationsOrchestrator.Flags.FFlagEnableNotificationsOrchestratorUnifiedLogging)
local evaluate = require(NotificationsOrchestrator.Internal.evaluate)
local SlotGroupBySlotId = require(NotificationsOrchestrator.Config.SlotGroupBySlotId)
local SlotConfigBySlotId = require(NotificationsOrchestrator.Config.SlotConfigBySlotId)
local getSlotConfig = SlotConfigBySlotId.getSlotConfig
local slotConfigBySlotId = SlotConfigBySlotId.SlotConfigBySlotId
local SlotGroupConfigByGroupId = require(NotificationsOrchestrator.Config.SlotGroupConfigByGroupId)
local getSlotGroupConfig = SlotGroupConfigByGroupId.getSlotGroupConfig
require(NotificationsOrchestrator.Types)

local RunService = game:GetService("RunService")

local function sendReportLog(p) -- 10 equivalent calls inferred from this helper
	pcall(function()
		local sendNotificationReportUnifiedEvent = require(NotificationsOrchestrator.Analytics.sendNotificationReportUnifiedEvent)
		sendNotificationReportUnifiedEvent.send(p)
	end)
end

local function reportLogFromEntry(data, kind: string, reason: string?, actionId: string?) -- 7 equivalent calls inferred from this helper
	return {
		slot = data.slotId,
		eventType = kind,
		reason = reason,
		actionId = actionId,
		handle = data.handle,
		lifecycleKey = data.lifecycleKey,
		source = data.source,
		itemId = data.itemId,
		itemType = data.itemType
	}
end

local function createNotificationsStore()
	local v = {}
	local v2 = {}
	local v3 = {}
	local count = 0
	local count2 = 0
	local v4 = localUserIdStore.getCurrentUserId(false)

	local v5 = false

	local function resetQueuesIfSessionChanged() -- 4 equivalent calls inferred from this helper
		local currentUserId = localUserIdStore.getCurrentUserId(false)

		if currentUserId == v4 then
			return
		end

		v4 = currentUserId
		table.clear(v2)
		table.clear(v3)
	end

	local function slotSignals(p)
		local v6 = v[p]

		if v6 ~= nil then
			return v6
		end

		local sessionScopedSignal, setActive = createSessionScopedSignal(nil)
		local v7 = { getActive = sessionScopedSignal, setActive = setActive }

		v[p] = v7
		return v7
	end

	local function slotGroup(p) -- 2 equivalent calls inferred from this helper
		return SlotGroupBySlotId[p]
	end

	local function queueKeyForSlot(slotId) -- 1 equivalent call inferred from this helper
		local v6 = slotGroup(slotId) -- inferred equivalent call

		if v6 == nil then
			return `slot:{slotId}`
		end

		return `group:{v6}`
	end

	local function getQueue(p: string)
		local v6 = v3[p]

		if v6 ~= nil then
			return v6
		end

		local v7 = { active = nil, waiting = {} }

		v3[p] = v7
		return v7
	end

	local function publish(data)
		local payload = data.payload

		if payload == nil then
			local slotId = data.slotId
			local v6 = v[slotId]

			if v6 == nil then
				local sessionScopedSignal, setActive = createSessionScopedSignal(nil)
				v6 = { getActive = sessionScopedSignal, setActive = setActive }

				v[slotId] = v6
			end

			v6.setActive(nil)
		else
			local slotId = data.slotId
			local v6 = v[slotId]

			if v6 == nil then
				local sessionScopedSignal, setActive = createSessionScopedSignal(nil)
				v6 = { getActive = sessionScopedSignal, setActive = setActive }

				v[slotId] = v6
			end

			v6.setActive({ handle = data.handle, payload = payload })
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
		local v6 = requestFrequency(data) -- inferred equivalent call

		if v6 ~= nil then
			return v6
		end

		local v7 = slotConfigBySlotId[data.slotId]

		if v7 ~= nil then
			local lifecycle = v7.lifecycle
			local frequency

			if lifecycle ~= nil then
				frequency = lifecycle.frequency
			end

			if frequency ~= nil then
				return frequency
			end
		end

		local v8 = slotGroup(data.slotId) -- inferred equivalent call

		if v8 ~= nil then
			return getSlotGroupConfig(v8).frequency
		end

		if v7 ~= nil then
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
		local v6 = nil

		for i = #waiting, 1, -1 do
			local item = waiting[i]

			if v5 and item.suppressWhileInExperienceShopOpen then
				v2[item.handle] = nil
				table.remove(waiting, i)

				if FFlagEnableNotificationsOrchestratorUnifiedLogging then
					sendReportLog(reportLogFromEntry(item, "suppressed")) -- inferred equivalent call
				end
			elseif isEligible(item.lifecycleKey, item.frequency, item.window) then -- inferred equivalent call
				local v7

				if v6 == nil or item.priority > v6.priority then
					v7 = true
				elseif item.priority == v6.priority then
					v7 = item.submissionOrder < v6.submissionOrder
				else
					v7 = false
				end

				if v7 then
					v6 = item
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

				if FFlagEnableNotificationsOrchestratorUnifiedLogging then
					sendReportLog(reportLogFromEntry(item, "promoteDropped", "frequency")) -- inferred equivalent call
				end
			end
		end

		if v6 == nil then
			return nil
		end

		removeFromWaiting(waiting, v6)
		return v6
	end

	local function removeEntry(data)
		v2[data.handle] = nil
		local v6 = v3[data.queueKey]

		if v6 == nil then
			OrchestratorDebugLogger.logLazy(function()
				return `remove: handle={data.handle} slotId={data.slotId} lifecycleKey={data.lifecycleKey} queue=missing`
			end)
		elseif v6.active == data then
			v6.active = nil
			local slotId = data.slotId
			local v7 = v[slotId]

			if v7 == nil then
				local sessionScopedSignal, setActive = createSessionScopedSignal(nil)
				v7 = { getActive = sessionScopedSignal, setActive = setActive }

				v[slotId] = v7
			end

			v7.setActive(nil)
			local active = takeHighestPriority(v6.waiting)

			if active == nil then
				OrchestratorDebugLogger.logLazy(function()
					return `remove active: handle={data.handle} slotId={data.slotId} lifecycleKey={data.lifecycleKey} slot=empty`
				end)

				return
			end

			OrchestratorDebugLogger.logLazy(function()
				return `remove active: handle={data.handle} slotId={data.slotId} lifecycleKey={data.lifecycleKey} promote={active.handle}`
			end)

			v6.active = active
			publish(active)
		else
			removeFromWaiting(v6.waiting, data)
			OrchestratorDebugLogger.logLazy(function()
				return `remove waiting: handle={data.handle} slotId={data.slotId} lifecycleKey={data.lifecycleKey}`
			end)
		end
	end

	return {
		submit = function(data)
			resetQueuesIfSessionChanged() -- inferred equivalent call
			local v6

			if data.enableOnStudio == nil then
				v6 = false
			else
				v6 = data.enableOnStudio
			end

			if not v6 and RunService:IsStudio() then
				OrchestratorDebugLogger.logLazy(function()
					return `submit discarded: slotId={data.slotId} lifecycleKey={data.lifecycleKey} reason=studio`
				end)

				return nil
			end

			if v5 and data.suppressWhileInExperienceShopOpen then
				OrchestratorDebugLogger.logLazy(function()
					return `submit discarded: slotId={data.slotId} lifecycleKey={data.lifecycleKey} reason=shopOpen`
				end)

				if FFlagEnableNotificationsOrchestratorUnifiedLogging then
					sendReportLog({ -- inferred equivalent call
						slot = data.slotId,
						eventType = "suppressed",
						lifecycleKey = data.lifecycleKey,
						source = data.source,
						itemId = data.itemId,
						itemType = data.itemType
					})
				end

				return nil
			else
				OrchestratorDebugLogger.logLazy(function()
					return `submit: slotId={data.slotId} lifecycleKey={data.lifecycleKey}`
				end)

				local frequency = resolveFrequency(data)
				local window = resolveWindow(frequency) -- inferred equivalent call

				if isEligible(data.lifecycleKey, frequency, window) then -- inferred equivalent call
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
						source = 0,
						itemId = 0,
						itemType = 0,
						submissionOrder = 0,
						queueKey = 0,
						suppressWhileInExperienceShopOpen = 0
					}
					local source

					if FFlagEnableNotificationsOrchestratorUnifiedLogging then
						source = data.source
					end

					active.source = source
					local itemId

					if FFlagEnableNotificationsOrchestratorUnifiedLogging then
						itemId = data.itemId
					end

					active.itemId = itemId
					local itemType

					if FFlagEnableNotificationsOrchestratorUnifiedLogging then
						itemType = data.itemType
					end

					active.itemType = itemType
					active.submissionOrder = count2
					active.queueKey = queueKeyForSlot(data.slotId) -- inferred equivalent call
					active.suppressWhileInExperienceShopOpen = data.suppressWhileInExperienceShopOpen

					v2[handle2] = active

					local queueKey = active.queueKey
					local v7 = v3[queueKey]

					if v7 == nil then
						v7 = { active = nil, waiting = {} }

						v3[queueKey] = v7
					end

					if v7.active == nil then
						OrchestratorDebugLogger.logLazy(function()
							return `submit shown: handle={handle2} slotId={active.slotId} lifecycleKey={active.lifecycleKey}`
						end)

						v7.active = active
						publish(active)
						return handle2
					else
						local handle = v7.active.handle
						OrchestratorDebugLogger.logLazy(function()
							return `submit queued: handle={handle2} slotId={active.slotId} lifecycleKey={active.lifecycleKey} behind={handle}`
						end)

						table.insert(v7.waiting, active)

						if FFlagEnableNotificationsOrchestratorUnifiedLogging then
							sendReportLog(reportLogFromEntry(active, "queued")) -- inferred equivalent call
						end

						return handle2
					end
				else
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

					if FFlagEnableNotificationsOrchestratorUnifiedLogging then
						sendReportLog({ -- inferred equivalent call
							slot = data.slotId,
							eventType = "submitDropped",
							reason = "frequency",
							lifecycleKey = data.lifecycleKey,
							source = data.source,
							itemId = data.itemId,
							itemType = data.itemType
						})
					end

					return nil
				end
			end
		end,
		revoke = function(p)
			resetQueuesIfSessionChanged() -- inferred equivalent call
			OrchestratorDebugLogger.logLazy(function()
				return `revoke: handle={p}`
			end)

			local v6 = v2[p]

			if v6 == nil then
				OrchestratorDebugLogger.logLazy(function()
					return `revoke ignored: handle={p}`
				end)

				return
			end

			removeEntry(v6)

			if FFlagEnableNotificationsOrchestratorUnifiedLogging then
				sendReportLog(reportLogFromEntry(v6, "revoked")) -- inferred equivalent call
			end
		end,
		report = function(slot, lifecycleKey, data)
			resetQueuesIfSessionChanged() -- inferred equivalent call
			OrchestratorDebugLogger.logLazy(function()
				return `report: slot={slot} key={lifecycleKey} event={data.type}`
			end)

			if data.type == "suppressed" then
				if FFlagEnableNotificationsOrchestratorUnifiedLogging then
					sendReportLog({ -- inferred equivalent call
						slot = slot,
						eventType = "suppressed",
						lifecycleKey = lifecycleKey
					})
				end
			else
				local v6 = v2[lifecycleKey]

				if v6 == nil or v6.slotId ~= slot then
					OrchestratorDebugLogger.logLazy(function()
						return `report ignored: slot={slot} key={lifecycleKey} event={data.type}`
					end)

					return
				end

				local flag = false

				if data.type == "viewed" then
					ExposureTracker.record(v6.lifecycleKey, v6.window)

					local frequency = v6.frequency
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
						and not isEligible(v6.lifecycleKey, { maxImpressions = maxImpressions2 }, v6.window) -- inferred equivalent call
					then
						OrchestratorDebugLogger.logLazy(function()
							local count3 = ExposureTracker.getCount(v6.lifecycleKey, v6.window)
							return `maxImpressions reached: handle={v6.handle} slotId={v6.slotId} lifecycleKey={v6.lifecycleKey} count={count3} maxImpressions={maxImpressions} window={describeWindow(v6.window)}` -- inferred equivalent call
						end)

						removeEntry(v6)
						flag = true
					end
				elseif data.type == "dismissed" then
					removeEntry(v6)
				end

				if FFlagEnableNotificationsOrchestratorUnifiedLogging then
					local reason = nil
					local actionId = nil

					if data.type == "dismissed" then
						reason = data.reason
					elseif data.type == "activated" then
						actionId = data.actionId
					end

					sendReportLog(reportLogFromEntry(v6, data.type, reason, actionId)) -- inferred equivalent call

					if flag then
						sendReportLog(reportLogFromEntry(v6, "capReached")) -- inferred equivalent call
					end
				end
			end
		end,
		getActiveForSlot = function(p)
			local v6 = v[p]

			if v6 == nil then
				local sessionScopedSignal, setActive = createSessionScopedSignal(nil)
				v6 = { getActive = sessionScopedSignal, setActive = setActive }

				v[p] = v6
			end

			return v6.getActive
		end,
		setInExperienceShopOpen = function(flag: boolean)
			resetQueuesIfSessionChanged() -- inferred equivalent call

			if v5 == flag then
				return
			end

			v5 = flag

			if not flag then
				return
			end

			local v6 = {}

			for _, v7 in v2 do
				if v7.suppressWhileInExperienceShopOpen then
					table.insert(v6, v7)
				end
			end

			for _, v7 in v6 do
				if v2[v7.handle] == nil then
					continue
				end

				removeEntry(v7)

				if FFlagEnableNotificationsOrchestratorUnifiedLogging then
					sendReportLog(reportLogFromEntry(v7, "suppressed")) -- inferred equivalent call
				end
			end
		end
	}
end

return createNotificationsStore
