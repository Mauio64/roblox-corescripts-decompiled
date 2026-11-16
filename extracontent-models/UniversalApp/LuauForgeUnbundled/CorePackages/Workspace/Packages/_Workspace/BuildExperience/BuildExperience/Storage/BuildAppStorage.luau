local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")

local FFlagBuildAdUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAdUpsell")
local FFlagBuildAdUpsellPinned = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAdUpsellPinned")
local FFlagBuildAgentAdCampaignCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAgentAdCampaignCard")
local createAdCampaignCardStorage = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Storage/createAdCampaignCardStorage")

local function sanitizeCount(value)
	if type(value) == "number" and value >= 0 then
		return (math.floor(value))
	end

	return 0
end

local function sanitizeDisplayCount(value)
	if type(value) == "number" and value >= 0 then
		return (math.floor(value))
	end

	return 0
end

local function getUtcDate(value)
	return string.match(value, "^(%d%d%d%d%-%d%d%-%d%d)")
end

local function isSameUtcDate(value, value2): boolean
	return value ~= nil
		and string.match(value, "^(%d%d%d%d%-%d%d%-%d%d)") == string.match(value2, "^(%d%d%d%d%-%d%d%-%d%d)")
end

local function makeEmptyAdUpsellScheduler()
	return {
		version = FFlagBuildAdUpsellPinned and 4 or 3,
		nextOrder = 1,
		universes = {},
		anchors = {},
		pendingMilestones = {},
		recentEventIds = {}
	}
end

local function pruneUniverseCap(data)
	local count = 0
	local v5 = 1e999
	local v6 = nil

	for k, univers in data.universes do
		count += 1

		if not (univers.lastTouchedOrder < v5 or univers.lastTouchedOrder == v5 and (v6 == nil or k < v6)) then
			continue
		end

		v5 = univers.lastTouchedOrder
		v6 = k
	end

	if count > 50 and v6 ~= nil then
		data.universes[v6] = nil
		local v7 = tonumber(v6)

		if v7 ~= nil then
			for i = #data.anchors, 1, -1 do
				if data.anchors[i].universeId == v7 then
					table.remove(data.anchors, i)
				end
			end

			for i = #data.pendingMilestones, 1, -1 do
				if data.pendingMilestones[i].universeId == v7 then
					table.remove(data.pendingMilestones, i)
				end
			end
		end
	end
end

local function sanitizeAdUpsellScheduler(scheduler)
	if type(scheduler) ~= "table" or scheduler.version ~= 4 and scheduler.version ~= 3 then
		return makeEmptyAdUpsellScheduler()
	end

	local emptyAdUpsellScheduler = makeEmptyAdUpsellScheduler()
	local maxValue = 0
	local count = 0

	if type(scheduler.universes) == "table" then
		for k, univers in scheduler.universes do
			if not (type(k) == "string" and type(univers) == "table") then
				continue
			end

			local lastTouchedOrder = univers.lastTouchedOrder
			local v5 = (type(lastTouchedOrder) ~= "number" or not (lastTouchedOrder >= 0)) and 0
				or math.floor(lastTouchedOrder)

			maxValue = math.max(maxValue, v5)
			emptyAdUpsellScheduler.universes[k] = {
				hasShownUpsell = univers.hasShownUpsell == true,
				dismissedPermanently = univers.dismissedPermanently == true,
				lastTouchedOrder = v5
			}

			count += 1
		end
	end

	if type(scheduler.anchors) == "table" then
		for k, anchor in scheduler.anchors do
			if not (type(anchor) == "table" and type(anchor.id) == "string" and type(anchor.universeId) == "number") then
				continue
			end

			if not (type(anchor.sessionId) == "string" and type(anchor.order) == "number") then
				continue
			end

			local v5 = math.max(1, (math.floor(anchor.order)))
			maxValue = math.max(maxValue, v5)
			local anchors = emptyAdUpsellScheduler.anchors
			local v6 = {
				id = anchor.id,
				universeId = anchor.universeId,
				sessionId = anchor.sessionId,
				afterMessageKey = 0,
				order = 0,
				impressed = 0
			}
			local v7 = if type(anchor.afterMessageKey) == "string" then anchor.afterMessageKey else nil
			v6.afterMessageKey = v7

			v6.order = v5
			v6.impressed = anchor.impressed == true
			table.insert(anchors, v6)
		end
	end

	if type(scheduler.pendingMilestones) == "table" then
		for k, pendingMilestone in scheduler.pendingMilestones do
			if not (type(pendingMilestone) == "table" and type(pendingMilestone.id) == "string" and type(pendingMilestone.universeId) == "number") then
				continue
			end

			if not ((pendingMilestone.sessionId == nil or type(pendingMilestone.sessionId) == "string") and type(pendingMilestone.order) == "number") then
				continue
			end

			local v5 = math.max(1, (math.floor(pendingMilestone.order)))
			maxValue = math.max(maxValue, v5)
			table.insert(emptyAdUpsellScheduler.pendingMilestones, {
				id = pendingMilestone.id,
				universeId = pendingMilestone.universeId,
				sessionId = pendingMilestone.sessionId,
				order = v5
			})
		end
	end

	if type(scheduler.recentEventIds) == "table" then
		for k, recentEventId in scheduler.recentEventIds do
			if type(recentEventId) == "string" then
				table.insert(emptyAdUpsellScheduler.recentEventIds, recentEventId)
			end
		end
	end

	for i = 51, count do
		pruneUniverseCap(emptyAdUpsellScheduler)
	end

	table.sort(emptyAdUpsellScheduler.anchors, function(a, b): boolean
		return a.order < b.order
	end)

	local v5 = {}

	for i = #emptyAdUpsellScheduler.anchors, 1, -1 do
		local anchor = emptyAdUpsellScheduler.anchors[i]
		local formatted = `{anchor.universeId}:{anchor.sessionId}`
		local v6 = v5[formatted] or 0

		if v6 >= 10 then
			table.remove(emptyAdUpsellScheduler.anchors, i)
		else
			v5[formatted] = v6 + 1
		end
	end

	table.sort(emptyAdUpsellScheduler.pendingMilestones, function(a, b): boolean
		return a.order < b.order
	end)

	while #emptyAdUpsellScheduler.anchors > 50 do
		table.remove(emptyAdUpsellScheduler.anchors, 1)
	end

	while #emptyAdUpsellScheduler.pendingMilestones > 50 do
		table.remove(emptyAdUpsellScheduler.pendingMilestones, 1)
	end

	while #emptyAdUpsellScheduler.recentEventIds > 50 do
		table.remove(emptyAdUpsellScheduler.recentEventIds, 1)
	end

	local nextOrder = scheduler.nextOrder
	emptyAdUpsellScheduler.nextOrder = math.max(
		(type(nextOrder) ~= "number" or not (nextOrder >= 0)) and 0 or math.floor(nextOrder),
		maxValue + 1,
		1
	)
	return emptyAdUpsellScheduler
end

local function createBuildAppStorage(AppStorageService2, HttpService2)
	local v5 = nil
	local flag = false
	local v6 = 0
	local v7 = nil
	local flag2 = false
	local v8 = false
	local count = 0
	local v9 = nil
	local v10 = false
	local adCampaignCardStorage = nil

	local function tryReadData()
		local success, item = pcall(AppStorageService2.GetItem, AppStorageService2, "BuildAppStorageKey")

		if not success then
			return false, {}
		end

		if type(item) ~= "string" or item == "" then
			return true, {}
		end

		local success2, result = pcall(HttpService2.JSONDecode, HttpService2, item)

		if success2 and type(result) == "table" then
			return true, result
		end

		return true, {}
	end

	local function tryReadDataStrict()
		local success, item = pcall(AppStorageService2.GetItem, AppStorageService2, "BuildAppStorageKey")

		if not success then
			return false, {}
		end

		if type(item) ~= "string" or item == "" then
			return true, {}
		end

		local success2, result = pcall(HttpService2.JSONDecode, HttpService2, item)

		if success2 and type(result) == "table" then
			return true, result
		end

		return false, {}
	end

	local function readData()
		local v11, data = tryReadData()
		return data
	end

	local function tryReadDataWithRetry(tryReadDataStrict2)
		local v11, v12 = tryReadDataStrict2()

		if v11 then
			return true, v12
		end

		return tryReadDataStrict2()
	end

	local function writeData(p2)
		local success, result = pcall(HttpService2.JSONEncode, HttpService2, p2)

		if success and type(result) == "string" then
			return (pcall(function()
				AppStorageService2:SetItem("BuildAppStorageKey", result)
				AppStorageService2:Flush()
			end))
		end

		return false
	end

	local function updateData(callback)
		local v11 = tryReadData
		local v12, v13 = v11()
		local v14

		if v12 then
			v14 = true
		else
			v14, v13 = v11()
		end

		if not v14 then
			return false
		end

		callback(v13)
		local success, result = pcall(HttpService2.JSONEncode, HttpService2, v13)

		if success and type(result) == "string" then
			return (pcall(function()
				AppStorageService2:SetItem("BuildAppStorageKey", result)
				AppStorageService2:Flush()
			end))
		end

		return false
	end

	local function getAdCampaignCardStorage()
		if adCampaignCardStorage == nil then
			adCampaignCardStorage = createAdCampaignCardStorage({
				readData = function()
					return tryReadDataWithRetry(tryReadDataStrict)
				end,
				writeData = writeData
			})
		end

		return adCampaignCardStorage
	end

	local function getChatDraft(p2)
		local v11, v12 = tryReadData()

		local chatDrafts = v12.chatDrafts

		if type(chatDrafts) ~= "table" then
			return nil
		end

		local chatDraft = chatDrafts[p2]

		if type(chatDraft) == "string" and chatDraft ~= "" then
			return chatDraft
		end

		return nil
	end

	local function setChatDraft(p2, p3)
		local v11 = tryReadData
		local v12, v13 = v11()
		local v14

		if v12 then
			v14 = true
		else
			v14, v13 = v11()
		end

		if not v14 then
			return false
		end

		local v15 = type(v13.chatDrafts) ~= "table" and {} or table.clone(v13.chatDrafts)

		if p3 == "" then
			p3 = nil
		end

		v15[p2] = p3
		v13.chatDrafts = v15
		local success, result = pcall(HttpService2.JSONEncode, HttpService2, v13)

		if success and type(result) == "string" then
			return (pcall(function()
				AppStorageService2:SetItem("BuildAppStorageKey", result)
				AppStorageService2:Flush()
			end))
		end

		return false
	end

	local function getUnpublishedPlaytestModeTooltipDisplayCount()
		local v11, v12 = tryReadData()

		local unpublishedPlaytestModeTooltipDisplayCount = v12.unpublishedPlaytestModeTooltipDisplayCount
		return (math.max(
			(type(unpublishedPlaytestModeTooltipDisplayCount) ~= "number" or not (unpublishedPlaytestModeTooltipDisplayCount >= 0)) and 0 or math.floor(unpublishedPlaytestModeTooltipDisplayCount),
			v6
		))
	end

	local function incrementUnpublishedPlaytestModeTooltipDisplayCount()
		if FFlagBuildAdUpsell then
			local v11 = v6 + 1
			v6 = v11
			local v12 = tryReadData
			local v13, v14 = v12()
			local v15

			if v13 then
				v15 = true
			else
				v15, v14 = v12()
			end

			if not v15 then
				return false
			end

			local unpublishedPlaytestModeTooltipDisplayCount = v14.unpublishedPlaytestModeTooltipDisplayCount
			local v16 = math.max(
				((type(unpublishedPlaytestModeTooltipDisplayCount) ~= "number" or not (unpublishedPlaytestModeTooltipDisplayCount >= 0)) and 0 or math.floor(unpublishedPlaytestModeTooltipDisplayCount)) + 1,
				v11
			)
			v6 = v16
			v14.unpublishedPlaytestModeTooltipDisplayCount = v16
			local success, result = pcall(HttpService2.JSONEncode, HttpService2, v14)

			if success and type(result) == "string" then
				return (pcall(function()
					AppStorageService2:SetItem("BuildAppStorageKey", result)
					AppStorageService2:Flush()
				end))
			end

			return false
		else
			local v11, v12 = tryReadData()

			local unpublishedPlaytestModeTooltipDisplayCount = v12.unpublishedPlaytestModeTooltipDisplayCount
			local v13 = math.max(
				(type(unpublishedPlaytestModeTooltipDisplayCount) ~= "number" or not (unpublishedPlaytestModeTooltipDisplayCount >= 0)) and 0 or math.floor(unpublishedPlaytestModeTooltipDisplayCount),
				v6
			) + 1
			v6 = v13
			v12.unpublishedPlaytestModeTooltipDisplayCount = v13
			local success, result = pcall(HttpService2.JSONEncode, HttpService2, v12)

			if success and type(result) == "string" then
				return (pcall(function()
					AppStorageService2:SetItem("BuildAppStorageKey", result)
					AppStorageService2:Flush()
				end))
			end

			return false
		end
	end

	local function wasPushNotificationsUpsellShownToday(p2)
		local isoDate = (p2 or DateTime.now()):ToIsoDate()
		local v11 = v5
		local v12

		if v11 == nil then
			v12 = false
		else
			v12 = string.match(v11, "^(%d%d%d%d%-%d%d%-%d%d)") == string.match(isoDate, "^(%d%d%d%d%-%d%d%-%d%d)")
		end

		if v12 then
			return true
		end

		local v13, v14 = tryReadData()

		local pushNotificationsUpsell = v14.pushNotificationsUpsell
		local v15

		if type(pushNotificationsUpsell) == "table" then
			local lastShownAt = pushNotificationsUpsell.lastShownAt

			if lastShownAt == nil then
				v15 = false
			else
				v15 = string.match(lastShownAt, "^(%d%d%d%d%-%d%d%-%d%d)") == string.match(isoDate, "^(%d%d%d%d%-%d%d%-%d%d)")
			end
		else
			v15 = false
		end

		return v15
	end

	local function markPushNotificationsUpsellShown(p2)
		local isoDate = (p2 or DateTime.now()):ToIsoDate()
		v5 = isoDate

		if FFlagBuildAdUpsell then
			local v11 = tryReadData
			local v12, v13 = v11()
			local v14

			if v12 then
				v14 = true
			else
				v14, v13 = v11()
			end

			if not v14 then
				return false
			end

			local pushNotificationsUpsell = v13.pushNotificationsUpsell

			local v15 = type(pushNotificationsUpsell) ~= "table" and {}
				or table.clone(pushNotificationsUpsell)

			v15.lastShownAt = isoDate
			v13.pushNotificationsUpsell = v15
			local success, result = pcall(HttpService2.JSONEncode, HttpService2, v13)

			if success and type(result) == "string" then
				return (pcall(function()
					AppStorageService2:SetItem("BuildAppStorageKey", result)
					AppStorageService2:Flush()
				end))
			end

			return false
		else
			local v11, v12 = tryReadData()

			local pushNotificationsUpsell = v12.pushNotificationsUpsell

			local v13 = type(pushNotificationsUpsell) ~= "table" and {}
				or table.clone(pushNotificationsUpsell)

			v13.lastShownAt = isoDate
			v12.pushNotificationsUpsell = v13
			local success, result = pcall(HttpService2.JSONEncode, HttpService2, v12)

			if success and type(result) == "string" then
				return (pcall(function()
					AppStorageService2:SetItem("BuildAppStorageKey", result)
					AppStorageService2:Flush()
				end))
			end

			return false
		end
	end

	local function loadAdUpsell()
		if v7 ~= nil then
			return true, v7
		end

		if flag2 then
			return false, nil
		end

		local v11 = tryReadDataStrict
		local v12, v13 = v11()
		local v14

		if v12 then
			v14 = true
		else
			v14, v13 = v11()
		end

		if not v14 then
			flag2 = true
			return false, nil
		end

		local adUpsell = v13.adUpsell

		local v15 = type(adUpsell) ~= "table" and {} or table.clone(adUpsell)

		v15.dismissedPermanently = v15.dismissedPermanently == true
		local v16 = if v15.dismissedPermanently then makeEmptyAdUpsellScheduler() else sanitizeAdUpsellScheduler(v15.scheduler)
		v15.scheduler = v16

		v7 = v15
		return true, v15
	end

	local function retryAdUpsellRead()
		flag2 = false
		return (loadAdUpsell())
	end

	local function persistCachedAdUpsell(p2)
		if v7 == nil then
			return false
		end

		local v11 = if p2 then tryReadData else tryReadDataStrict
		local v12, v13 = v11()
		local v14

		if v12 then
			v14 = true
		else
			v14, v13 = v11()
		end

		if not v14 then
			return false
		end

		local adUpsell = v13.adUpsell
		local v15 = type(adUpsell) ~= "table" and {} or table.clone(adUpsell)
		local v16 = v7
		v15.dismissedPermanently = v16.dismissedPermanently
		v15.scheduler = v16.scheduler
		v13.adUpsell = v15
		local success, result = pcall(HttpService2.JSONEncode, HttpService2, v13)

		if success and type(result) == "string" then
			return (pcall(function()
				AppStorageService2:SetItem("BuildAppStorageKey", result)
				AppStorageService2:Flush()
			end))
		end

		return false
	end

	local function scheduleAdUpsellWriteRetry(p2)
		if v9 ~= nil or count >= 3 then
			return
		end

		local function retryWrite()
			v9 = nil

			if not v8 or count >= 3 then
				return
			end

			count += 1

			if not persistCachedAdUpsell(v10) then
				scheduleAdUpsellWriteRetry(true)

				return
			end

			v8 = false
			count = 0
			v10 = false
		end
		v9 = if p2 then task.delay(1, retryWrite) else task.defer(retryWrite)
	end

	local function persistAdUpsellMutation(p2, p3)
		count = 0

		if p3 then
			v8 = true
			v10 = v10 or p2 == true
			scheduleAdUpsellWriteRetry()
			return true
		else
			count += 1
			local v11 = persistCachedAdUpsell(p2)
			v8 = not v11

			if v8 then
				v10 = v10 or p2 == true
				scheduleAdUpsellWriteRetry()
			else
				count = 0
				v10 = false

				if v9 ~= nil then
					task.cancel(v9)
					v9 = nil
				end
			end

			return v11
		end
	end

	local function getAdUpsellScheduler()
		local v11, v12 = loadAdUpsell()

		if v11 and v12 ~= nil then
			return true, v12, v12.scheduler
		end

		return false, nil, nil
	end

	local function getOrCreateUniverseState(p2, p3)
		local v11 = tostring(p3)
		local universeState = p2.universes[v11]

		if universeState == nil then
			universeState = {
				hasShownUpsell = false,
				dismissedPermanently = false,
				lastTouchedOrder = 0
			}

			p2.universes[v11] = universeState
		end

		return universeState
	end

	local function hasRecentEvent(p2, p3): boolean
		return table.find(p2.recentEventIds, p3) ~= nil
	end

	local function rememberEvent(scheduler, eventId)
		table.insert(scheduler.recentEventIds, eventId)

		while #scheduler.recentEventIds > 50 do
			table.remove(scheduler.recentEventIds, 1)
		end
	end

	local function pruneAnchorCaps(p2, p3, p4)
		local v11 = 0

		for k, anchor in p2.anchors do
			if anchor.universeId == p3 and anchor.sessionId == p4 then
				v11 += 1
			end
		end

		while v11 > 10 do
			for k, anchor in p2.anchors do
				if anchor.universeId == p3 and anchor.sessionId == p4 then
					table.remove(p2.anchors, k)
					v11 -= 1
					break
				end
			end
		end

		while #p2.anchors > 50 do
			table.remove(p2.anchors, 1)
		end
	end

	local function addMilestone(scheduler, eventId, universeId, sessionId, afterMessageKey, nextOrder)
		if sessionId == nil or not FFlagBuildAdUpsellPinned and afterMessageKey == nil then
			table.insert(scheduler.pendingMilestones, {
				id = eventId,
				universeId = universeId,
				sessionId = sessionId,
				order = nextOrder
			})

			while #scheduler.pendingMilestones > 50 do
				table.remove(scheduler.pendingMilestones, 1)
			end
		else
			local anchors = scheduler.anchors

			if FFlagBuildAdUpsellPinned then
				afterMessageKey = nil
			end

			table.insert(anchors, {
				id = eventId,
				universeId = universeId,
				sessionId = sessionId,
				afterMessageKey = afterMessageKey,
				order = nextOrder,
				impressed = false
			})

			pruneAnchorCaps(scheduler, universeId, sessionId)
		end
	end

	local function recordAdUpsellEvent(data)
		local v11, v12 = loadAdUpsell()
		local scheduler, v13

		if v11 and v12 ~= nil then
			scheduler = v12.scheduler
			v13 = true
		else
			v13 = false
			v12 = nil
		end

		if not v13 or v12 == nil or scheduler == nil then
			return false, false
		end

		local univers = scheduler.universes[tostring(data.universeId)]

		if
			v12.dismissedPermanently == true
			or univers ~= nil and univers.dismissedPermanently
			or not data.isEligiblePublish
		then
			return true, false
		end

		if univers == nil or not univers.hasShownUpsell then
			local eventId = data.eventId

			if table.find(scheduler.recentEventIds, eventId) == nil then
				rememberEvent(scheduler, data.eventId)
				local universeId = tostring(data.universeId)
				local v14 = scheduler.universes[universeId]

				if v14 == nil then
					v14 = {
						hasShownUpsell = false,
						dismissedPermanently = false,
						lastTouchedOrder = 0
					}

					scheduler.universes[universeId] = v14
				end

				local nextOrder = scheduler.nextOrder
				scheduler.nextOrder += 1
				v14.lastTouchedOrder = nextOrder
				v14.hasShownUpsell = true
				pruneUniverseCap(scheduler)
				addMilestone(
					scheduler,
					data.eventId,
					data.universeId,
					data.sessionId,
					data.afterMessageKey,
					nextOrder
				)
				return persistAdUpsellMutation(), true
			end
		end

		return not v8 or persistAdUpsellMutation(), false
	end

	local function recordAdUpsellCompletedTurn(p2)
		return recordAdUpsellEvent(p2)
	end

	local function recordAdUpsellPublish(p2)
		return recordAdUpsellEvent(p2)
	end

	local function attachPendingAdUpsellMilestones(p2, p3, p4)
		local v11, v12 = loadAdUpsell()
		local scheduler, v13

		if v11 and v12 ~= nil then
			scheduler = v12.scheduler
			v13 = true
		else
			v13 = false
			v12 = nil
		end

		if not v13 or v12 == nil or scheduler == nil then
			return false
		end

		if v12.dismissedPermanently == true then
			return true
		end

		local pendingMilestones = {}
		local v14 = false

		for k, pendingMilestone in scheduler.pendingMilestones do
			if
				pendingMilestone.universeId == p2
				and (pendingMilestone.sessionId == nil or pendingMilestone.sessionId == p3)
				and (FFlagBuildAdUpsellPinned or p4 ~= nil)
			then
				local anchors = scheduler.anchors
				local v15 = {
					id = pendingMilestone.id,
					universeId = p2,
					sessionId = p3,
					afterMessageKey = if not FFlagBuildAdUpsellPinned then p4 else nil,
					order = pendingMilestone.order,
					impressed = false
				}
				table.insert(anchors, v15)
				v14 = true
			else
				table.insert(pendingMilestones, pendingMilestone)
			end
		end

		if not v14 then
			return true
		end

		scheduler.pendingMilestones = pendingMilestones
		table.sort(scheduler.anchors, function(a, b): boolean
			return a.order < b.order
		end)

		pruneAnchorCaps(scheduler, p2, p3)
		return persistAdUpsellMutation()
	end

	local function pruneAdUpsellAnchors(p2, p3, p4)
		if FFlagBuildAdUpsellPinned then
			return true, false
		end

		local v11, v12 = loadAdUpsell()
		local scheduler, v13

		if v11 and v12 ~= nil then
			scheduler = v12.scheduler
			v13 = true
		else
			v13 = false
		end

		if not v13 or scheduler == nil then
			return false, false
		end

		local anchors = {}
		local v14 = false

		for k, anchor in scheduler.anchors do
			if
				anchor.universeId == p2
				and anchor.sessionId == p3
				and (anchor.afterMessageKey == nil or not p4[anchor.afterMessageKey])
			then
				v14 = true
			else
				table.insert(anchors, anchor)
			end
		end

		if not v14 then
			return true, false
		end

		scheduler.anchors = anchors
		return persistAdUpsellMutation(), true
	end

	local function getAdUpsellState(p2, p3)
		local v11, v12 = loadAdUpsell()
		local scheduler, v13

		if v11 and v12 ~= nil then
			scheduler = v12.scheduler
			v13 = true
		else
			v13 = false
			v12 = nil
		end

		if not v13 or v12 == nil or scheduler == nil then
			return {
				isAvailable = false,
				dismissedPermanently = true,
				hasShownUpsell = false,
				anchors = {},
				pendingMilestoneCount = 0
			}
		end

		local univers = scheduler.universes[tostring(p2)]
		local clones = {}

		if p3 ~= nil then
			for k, anchor in scheduler.anchors do
				if anchor.universeId == p2 and anchor.sessionId == p3 then
					table.insert(clones, table.clone(anchor))
				end
			end
		end

		local count2 = 0

		for k, pendingMilestone in scheduler.pendingMilestones do
			if
				pendingMilestone.universeId == p2
				and (p3 == nil or pendingMilestone.sessionId == nil or pendingMilestone.sessionId == p3)
			then
				count2 += 1
			end
		end

		local v15 = v12.dismissedPermanently == true
			or not (univers == nil) and univers.dismissedPermanently
		return {
			isAvailable = true,
			dismissedPermanently = v15,
			hasShownUpsell = univers ~= nil and univers.hasShownUpsell,
			anchors = clones,
			pendingMilestoneCount = count2
		}
	end

	local function markAdUpsellAnchorImpressed(p2, p3, p4): boolean
		local v11, v12 = loadAdUpsell()
		local scheduler, v13

		if v11 and v12 ~= nil then
			scheduler = v12.scheduler
			v13 = true
		else
			v13 = false
			v12 = nil
		end

		if not v13 or v12 == nil or scheduler == nil or v12.dismissedPermanently == true then
			return false
		end

		for k, anchor in scheduler.anchors do
			if anchor.universeId == p2 and anchor.sessionId == p3 and anchor.id == p4 then
				if anchor.impressed then
					return false
				end

				anchor.impressed = true
				count = 0

				v8 = true
				v10 = v10 or false
				scheduleAdUpsellWriteRetry()

				return true
			end
		end

		return false
	end

	local function markAdUpsellDismissedPermanently(p2): boolean
		local v11, v12 = loadAdUpsell()

		if v11 and v12 ~= nil and v12.dismissedPermanently == true then
			return true
		end

		local v13

		if v11 and v12 ~= nil then
			v13 = false
		else
			local v14 = tryReadData
			local v15, v16 = v14()

			if not v15 then
				local v17
				v17, v16 = v14()
			end

			local v17 = type(v16.adUpsell) ~= "table" and {} or table.clone(v16.adUpsell)
			v17.dismissedPermanently = v17.dismissedPermanently == true
			v17.scheduler = sanitizeAdUpsellScheduler(v17.scheduler)
			v7 = v17
			flag2 = false
			v13 = true
		end

		local scheduler = v7.scheduler
		local v14 = tostring(p2)
		local v15 = scheduler.universes[v14]

		if v15 == nil then
			v15 = {
				hasShownUpsell = false,
				dismissedPermanently = false,
				lastTouchedOrder = 0
			}

			scheduler.universes[v14] = v15
		end

		v15.hasShownUpsell = false
		v15.dismissedPermanently = true

		local anchors = {}

		for k, anchor in scheduler.anchors do
			if anchor.universeId ~= p2 then
				table.insert(anchors, anchor)
			end
		end

		scheduler.anchors = anchors
		local pendingMilestones = {}

		for k, pendingMilestone in scheduler.pendingMilestones do
			if pendingMilestone.universeId ~= p2 then
				table.insert(pendingMilestones, pendingMilestone)
			end
		end

		scheduler.pendingMilestones = pendingMilestones
		count = 0

		count += 1
		v8 = not persistCachedAdUpsell(v13)

		if v8 then
			v10 = v10 or v13 == true
			scheduleAdUpsellWriteRetry()
		else
			count = 0
			v10 = false

			if v9 ~= nil then
				task.cancel(v9)
				v9 = nil
			end
		end

		return not v8
	end

	local function isPushNotificationsUpsellDismissedPermanently(): boolean
		if flag then
			return true
		end

		local v11, v12 = tryReadData()

		local pushNotificationsUpsell = v12.pushNotificationsUpsell
		return type(pushNotificationsUpsell) == "table"
			and pushNotificationsUpsell.dismissedPermanently == true
	end

	local function markPushNotificationsUpsellDismissedPermanently()
		flag = true

		if FFlagBuildAdUpsell then
			local v11 = tryReadData
			local v12, v13 = v11()
			local v14

			if v12 then
				v14 = true
			else
				v14, v13 = v11()
			end

			if not v14 then
				return false
			end

			local pushNotificationsUpsell = v13.pushNotificationsUpsell

			local v15 = type(pushNotificationsUpsell) ~= "table" and {}
				or table.clone(pushNotificationsUpsell)

			v15.dismissedPermanently = true
			v13.pushNotificationsUpsell = v15
			local success, result = pcall(HttpService2.JSONEncode, HttpService2, v13)

			if success and type(result) == "string" then
				return (pcall(function()
					AppStorageService2:SetItem("BuildAppStorageKey", result)
					AppStorageService2:Flush()
				end))
			end

			return false
		else
			local v11, v12 = tryReadData()

			local pushNotificationsUpsell = v12.pushNotificationsUpsell

			local v13 = type(pushNotificationsUpsell) ~= "table" and {}
				or table.clone(pushNotificationsUpsell)

			v13.dismissedPermanently = true
			v12.pushNotificationsUpsell = v13
			local success, result = pcall(HttpService2.JSONEncode, HttpService2, v12)

			if success and type(result) == "string" then
				return (pcall(function()
					AppStorageService2:SetItem("BuildAppStorageKey", result)
					AppStorageService2:Flush()
				end))
			end

			return false
		end
	end

	local function clearSessionCacheForTests()
		if FFlagBuildAgentAdCampaignCard and adCampaignCardStorage ~= nil then
			adCampaignCardStorage.reset()
		end

		v5 = nil
		flag = false
		v6 = 0
		v7 = nil
		flag2 = false
		v8 = false
		count = 0

		if v9 ~= nil then
			task.cancel(v9)
		end

		v9 = nil
		v10 = false
	end

	if not FFlagBuildAgentAdCampaignCard then
		getAdCampaignCardStorage = nil
	end

	return {
		getAdCampaignCardStorage = getAdCampaignCardStorage,
		STORAGE_KEY = "BuildAppStorageKey",
		AD_UPSELL_SCHEDULER_VERSION = 4,
		getChatDraft = getChatDraft,
		setChatDraft = setChatDraft,
		getUnpublishedPlaytestModeTooltipDisplayCount = getUnpublishedPlaytestModeTooltipDisplayCount,
		incrementUnpublishedPlaytestModeTooltipDisplayCount = incrementUnpublishedPlaytestModeTooltipDisplayCount,
		wasPushNotificationsUpsellShownToday = wasPushNotificationsUpsellShownToday,
		markPushNotificationsUpsellShown = markPushNotificationsUpsellShown,
		retryAdUpsellRead = retryAdUpsellRead,
		getAdUpsellState = getAdUpsellState,
		recordAdUpsellCompletedTurn = recordAdUpsellCompletedTurn,
		recordAdUpsellPublish = recordAdUpsellPublish,
		attachPendingAdUpsellMilestones = attachPendingAdUpsellMilestones,
		pruneAdUpsellAnchors = pruneAdUpsellAnchors,
		markAdUpsellAnchorImpressed = markAdUpsellAnchorImpressed,
		markAdUpsellDismissedPermanently = markAdUpsellDismissedPermanently,
		isPushNotificationsUpsellDismissedPermanently = isPushNotificationsUpsellDismissedPermanently,
		markPushNotificationsUpsellDismissedPermanently = markPushNotificationsUpsellDismissedPermanently,
		clearSessionCacheForTests = clearSessionCacheForTests
	}
end

local buildAppStorage = createBuildAppStorage(AppStorageService, HttpService)

local v6 = if FFlagBuildAgentAdCampaignCard then buildAppStorage.getAdCampaignCardStorage else nil
return {
	getAdCampaignCardStorage = v6,
	STORAGE_KEY = "BuildAppStorageKey",
	AD_UPSELL_SCHEDULER_VERSION = 4,
	getChatDraft = buildAppStorage.getChatDraft,
	setChatDraft = buildAppStorage.setChatDraft,
	getUnpublishedPlaytestModeTooltipDisplayCount = buildAppStorage.getUnpublishedPlaytestModeTooltipDisplayCount,
	incrementUnpublishedPlaytestModeTooltipDisplayCount = buildAppStorage.incrementUnpublishedPlaytestModeTooltipDisplayCount,
	wasPushNotificationsUpsellShownToday = buildAppStorage.wasPushNotificationsUpsellShownToday,
	markPushNotificationsUpsellShown = buildAppStorage.markPushNotificationsUpsellShown,
	retryAdUpsellRead = buildAppStorage.retryAdUpsellRead,
	getAdUpsellState = buildAppStorage.getAdUpsellState,
	recordAdUpsellCompletedTurn = buildAppStorage.recordAdUpsellCompletedTurn,
	recordAdUpsellPublish = buildAppStorage.recordAdUpsellPublish,
	attachPendingAdUpsellMilestones = buildAppStorage.attachPendingAdUpsellMilestones,
	pruneAdUpsellAnchors = buildAppStorage.pruneAdUpsellAnchors,
	markAdUpsellAnchorImpressed = buildAppStorage.markAdUpsellAnchorImpressed,
	markAdUpsellDismissedPermanently = buildAppStorage.markAdUpsellDismissedPermanently,
	isPushNotificationsUpsellDismissedPermanently = buildAppStorage.isPushNotificationsUpsellDismissedPermanently,
	markPushNotificationsUpsellDismissedPermanently = buildAppStorage.markPushNotificationsUpsellDismissedPermanently,
	clearSessionCacheForTests = buildAppStorage.clearSessionCacheForTests,
	createForTests = createBuildAppStorage
}
