local BuildExperience = script:FindFirstAncestor("BuildExperience")

local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")

local FFlagBuildAdUpsell = require(BuildExperience.Flags.FFlagBuildAdUpsell)
local FFlagBuildAdUpsellPinned = require(BuildExperience.Flags.FFlagBuildAdUpsellPinned)
local FFlagBuildAgentAdCampaignCard = require(BuildExperience.Flags.FFlagBuildAgentAdCampaignCard)
local createAdCampaignCardStorage = require(script.Parent.createAdCampaignCardStorage)

local function sanitizeCount(value) -- 6 equivalent calls inferred from this helper
	if type(value) == "number" and value >= 0 then
		return (math.floor(value))
	end

	return 0
end

local function sanitizeDisplayCount(value)
	return sanitizeCount(value) -- inferred equivalent call
end

local function getUtcDate(value: string) -- 2 equivalent calls inferred from this helper
	return string.match(value, "^(%d%d%d%d%-%d%d%-%d%d)")
end

local function isSameUtcDate(value: string?, value2: string): boolean -- 2 equivalent calls inferred from this helper
	return value ~= nil and getUtcDate(value) == getUtcDate(value2) -- inferred equivalent call
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
	local v = 1e999
	local v2 = nil

	for k, univers in data.universes do
		count += 1

		if not (univers.lastTouchedOrder < v or univers.lastTouchedOrder == v and (v2 == nil or k < v2)) then
			continue
		end

		v = univers.lastTouchedOrder
		v2 = k
	end

	if count > 50 and v2 ~= nil then
		data.universes[v2] = nil
		local v3 = tonumber(v2)

		if v3 ~= nil then
			for i = #data.anchors, 1, -1 do
				if data.anchors[i].universeId == v3 then
					table.remove(data.anchors, i)
				end
			end

			for i = #data.pendingMilestones, 1, -1 do
				if data.pendingMilestones[i].universeId == v3 then
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

			local lastTouchedOrder = sanitizeCount(univers.lastTouchedOrder) -- inferred equivalent call
			maxValue = math.max(maxValue, lastTouchedOrder)
			emptyAdUpsellScheduler.universes[k] = {
				hasShownUpsell = univers.hasShownUpsell == true,
				dismissedPermanently = univers.dismissedPermanently == true,
				lastTouchedOrder = lastTouchedOrder
			}

			count += 1
		end
	end

	if type(scheduler.anchors) == "table" then
		for _, anchor in scheduler.anchors do
			if not (type(anchor) == "table" and type(anchor.id) == "string" and type(anchor.universeId) == "number") then
				continue
			end

			if not (type(anchor.sessionId) == "string" and type(anchor.order) == "number") then
				continue
			end

			local order = math.max(1, (math.floor(anchor.order)))
			maxValue = math.max(maxValue, order)
			local anchors = emptyAdUpsellScheduler.anchors
			local v = {
				id = anchor.id,
				universeId = anchor.universeId,
				sessionId = anchor.sessionId,
				afterMessageKey = 0,
				order = 0,
				impressed = 0
			}
			local afterMessageKey

			if type(anchor.afterMessageKey) == "string" then
				afterMessageKey = anchor.afterMessageKey
			end

			v.afterMessageKey = afterMessageKey

			v.order = order
			v.impressed = anchor.impressed == true
			table.insert(anchors, v)
		end
	end

	if type(scheduler.pendingMilestones) == "table" then
		for _, pendingMilestone in scheduler.pendingMilestones do
			if not (type(pendingMilestone) == "table" and type(pendingMilestone.id) == "string" and type(pendingMilestone.universeId) == "number") then
				continue
			end

			if not ((pendingMilestone.sessionId == nil or type(pendingMilestone.sessionId) == "string") and type(pendingMilestone.order) == "number") then
				continue
			end

			local order = math.max(1, (math.floor(pendingMilestone.order)))
			maxValue = math.max(maxValue, order)
			table.insert(emptyAdUpsellScheduler.pendingMilestones, {
				id = pendingMilestone.id,
				universeId = pendingMilestone.universeId,
				sessionId = pendingMilestone.sessionId,
				order = order
			})
		end
	end

	if type(scheduler.recentEventIds) == "table" then
		for _, recentEventId in scheduler.recentEventIds do
			if type(recentEventId) == "string" then
				table.insert(emptyAdUpsellScheduler.recentEventIds, recentEventId)
			end
		end
	end

	for _ = 51, count do
		pruneUniverseCap(emptyAdUpsellScheduler)
	end

	table.sort(emptyAdUpsellScheduler.anchors, function(a, b): boolean
		return a.order < b.order
	end)

	local v = {}

	for i = #emptyAdUpsellScheduler.anchors, 1, -1 do
		local anchor = emptyAdUpsellScheduler.anchors[i]
		local formatted = `{anchor.universeId}:{anchor.sessionId}`
		local v2 = v[formatted] or 0

		if v2 >= 10 then
			table.remove(emptyAdUpsellScheduler.anchors, i)
		else
			v[formatted] = v2 + 1
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

	emptyAdUpsellScheduler.nextOrder = math.max(sanitizeCount(scheduler.nextOrder), maxValue + 1, 1) -- inferred equivalent call
	return emptyAdUpsellScheduler
end

local function createBuildAppStorage(AppStorageService2, HttpService2)
	local v = nil
	local flag = false
	local v2 = 0
	local v3 = nil
	local flag2 = false
	local v4 = false
	local count = 0
	local v5 = nil
	local v6 = false
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

	local function readData() -- 7 equivalent calls inferred from this helper
		local _, data = tryReadData()
		return data
	end

	local function tryReadDataWithRetry(tryReadDataStrict2)
		local v7, v8 = tryReadDataStrict2()

		if v7 then
			return true, v8
		end

		return tryReadDataStrict2()
	end

	local function writeData(p) -- 6 equivalent calls inferred from this helper
		local success, result = pcall(HttpService2.JSONEncode, HttpService2, p)

		if success and type(result) == "string" then
			return (pcall(function()
				AppStorageService2:SetItem("BuildAppStorageKey", result)
				AppStorageService2:Flush()
			end))
		end

		return false
	end

	local function updateData(fn) -- 3 equivalent calls inferred from this helper
		local tryReadData2 = tryReadData
		local v7, v8 = tryReadData2()
		local v9

		if v7 then
			v9 = true
		else
			v9, v8 = tryReadData2()
		end

		if not v9 then
			return false
		end

		fn(v8)
		return writeData(v8) -- inferred equivalent call
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

	local function getChatDraft(p: string)
		local chatDrafts = readData().chatDrafts -- inferred equivalent call

		if type(chatDrafts) ~= "table" then
			return nil
		end

		local chatDraft = chatDrafts[p]

		if type(chatDraft) == "string" and chatDraft ~= "" then
			return chatDraft
		end

		return nil
	end

	local function setChatDraft(p: string, p2: string)
		local tryReadData2 = tryReadData
		local v7, v8 = tryReadData2()
		local v9

		if v7 then
			v9 = true
		else
			v9, v8 = tryReadData2()
		end

		if not v9 then
			return false
		end

		local chatDrafts = type(v8.chatDrafts) ~= "table" and {} or table.clone(v8.chatDrafts)

		if p2 == "" then
			p2 = nil
		end

		chatDrafts[p] = p2
		v8.chatDrafts = chatDrafts
		return writeData(v8) -- inferred equivalent call
	end

	local function getUnpublishedPlaytestModeTooltipDisplayCount()
		return (math.max(sanitizeCount(readData().unpublishedPlaytestModeTooltipDisplayCount), v2)) -- inferred equivalent call
	end

	local function incrementUnpublishedPlaytestModeTooltipDisplayCount()
		if FFlagBuildAdUpsell then
			local v7 = v2 + 1
			v2 = v7
			return updateData(function(p) -- inferred equivalent call
				local unpublishedPlaytestModeTooltipDisplayCount = math.max(
					sanitizeCount(p.unpublishedPlaytestModeTooltipDisplayCount) + 1, -- inferred equivalent call
					v7
				)
				v2 = unpublishedPlaytestModeTooltipDisplayCount
				p.unpublishedPlaytestModeTooltipDisplayCount = unpublishedPlaytestModeTooltipDisplayCount
			end)
		else
			local data = readData() -- inferred equivalent call
			local unpublishedPlaytestModeTooltipDisplayCount = math.max(
				sanitizeCount(data.unpublishedPlaytestModeTooltipDisplayCount), -- inferred equivalent call
				v2
			) + 1
			v2 = unpublishedPlaytestModeTooltipDisplayCount
			data.unpublishedPlaytestModeTooltipDisplayCount = unpublishedPlaytestModeTooltipDisplayCount
			return writeData(data) -- inferred equivalent call
		end
	end

	local function wasPushNotificationsUpsellShownToday(p)
		local isoDate = (p or DateTime.now()):ToIsoDate()

		if isSameUtcDate(v, isoDate) then -- inferred equivalent call
			return true
		end

		local pushNotificationsUpsell = readData().pushNotificationsUpsell -- inferred equivalent call
		return type(pushNotificationsUpsell) == "table" and isSameUtcDate(pushNotificationsUpsell.lastShownAt, isoDate) -- inferred equivalent call
	end

	local function markPushNotificationsUpsellShown(p)
		local isoDate = (p or DateTime.now()):ToIsoDate()
		v = isoDate

		if FFlagBuildAdUpsell then
			return updateData(function(p2) -- inferred equivalent call
				local pushNotificationsUpsell = p2.pushNotificationsUpsell

				local pushNotificationsUpsell2 = type(pushNotificationsUpsell) ~= "table" and {}
					or table.clone(pushNotificationsUpsell)

				pushNotificationsUpsell2.lastShownAt = isoDate
				p2.pushNotificationsUpsell = pushNotificationsUpsell2
			end)
		else
			local data = readData() -- inferred equivalent call
			local pushNotificationsUpsell = data.pushNotificationsUpsell

			local pushNotificationsUpsell2 = type(pushNotificationsUpsell) ~= "table" and {}
				or table.clone(pushNotificationsUpsell)

			pushNotificationsUpsell2.lastShownAt = isoDate
			data.pushNotificationsUpsell = pushNotificationsUpsell2
			return writeData(data) -- inferred equivalent call
		end
	end

	local function loadAdUpsell()
		if v3 ~= nil then
			return true, v3
		end

		if flag2 then
			return false, nil
		end

		local v7 = tryReadDataStrict
		local v8, v9 = v7()
		local v10

		if v8 then
			v10 = true
		else
			v10, v9 = v7()
		end

		if not v10 then
			flag2 = true
			return false, nil
		end

		local adUpsell = v9.adUpsell

		local v11 = type(adUpsell) ~= "table" and {} or table.clone(adUpsell)

		v11.dismissedPermanently = v11.dismissedPermanently == true
		local scheduler

		if v11.dismissedPermanently then
			scheduler = makeEmptyAdUpsellScheduler()
		else
			scheduler = sanitizeAdUpsellScheduler(v11.scheduler)
		end

		v11.scheduler = scheduler

		v3 = v11
		return true, v11
	end

	local function retryAdUpsellRead()
		flag2 = false
		return (loadAdUpsell())
	end

	local function persistCachedAdUpsell(flag3: boolean?)
		if v3 == nil then
			return false
		end

		local v7 = if flag3 then tryReadData else tryReadDataStrict
		local v8, v9 = v7()
		local v10

		if v8 then
			v10 = true
		else
			v10, v9 = v7()
		end

		if not v10 then
			return false
		end

		local adUpsell = v9.adUpsell
		local adUpsell2 = type(adUpsell) ~= "table" and {} or table.clone(adUpsell)
		local v11 = v3
		adUpsell2.dismissedPermanently = v11.dismissedPermanently
		adUpsell2.scheduler = v11.scheduler
		v9.adUpsell = adUpsell2
		return writeData(v9) -- inferred equivalent call
	end

	local function scheduleAdUpsellWriteRetry(flag3: boolean?)
		if v5 ~= nil or count >= 3 then
			return
		end

		local function retryWrite()
			v5 = nil

			if not v4 or count >= 3 then
				return
			end

			count += 1

			if not persistCachedAdUpsell(v6) then
				scheduleAdUpsellWriteRetry(true)

				return
			end

			v4 = false
			count = 0
			v6 = false
		end

		local v7

		if flag3 then
			v7 = task.delay(1, retryWrite)
		else
			v7 = task.defer(retryWrite)
		end

		v5 = v7
	end

	local function persistAdUpsellMutation(flag3: boolean?, flag4: boolean?)
		count = 0

		if flag4 then
			v4 = true
			v6 = v6 or flag3 == true
			scheduleAdUpsellWriteRetry()
			return true
		else
			count += 1
			local v7 = persistCachedAdUpsell(flag3)
			v4 = not v7

			if v4 then
				v6 = v6 or flag3 == true
				scheduleAdUpsellWriteRetry()
			else
				count = 0
				v6 = false

				if v5 ~= nil then
					task.cancel(v5)
					v5 = nil
				end
			end

			return v7
		end
	end

	local function getAdUpsellScheduler()
		local v7, v8 = loadAdUpsell()

		if v7 and v8 ~= nil then
			return true, v8, v8.scheduler
		end

		return false, nil, nil
	end

	local function getOrCreateUniverseState(scheduler, p: number) -- 2 equivalent calls inferred from this helper
		local v7 = tostring(p)
		local universeState = scheduler.universes[v7]

		if universeState == nil then
			universeState = {
				hasShownUpsell = false,
				dismissedPermanently = false,
				lastTouchedOrder = 0
			}

			scheduler.universes[v7] = universeState
		end

		return universeState
	end

	local function hasRecentEvent(p, p2: string): boolean -- 1 equivalent call inferred from this helper
		return table.find(p.recentEventIds, p2) ~= nil
	end

	local function rememberEvent(scheduler, eventId: string)
		table.insert(scheduler.recentEventIds, eventId)

		while #scheduler.recentEventIds > 50 do
			table.remove(scheduler.recentEventIds, 1)
		end
	end

	local function pruneAnchorCaps(p, p2: number, p3: string)
		local v7 = 0

		for _, anchor in p.anchors do
			if anchor.universeId == p2 and anchor.sessionId == p3 then
				v7 += 1
			end
		end

		while v7 > 10 do
			for k, anchor in p.anchors do
				if anchor.universeId == p2 and anchor.sessionId == p3 then
					table.remove(p.anchors, k)
					v7 -= 1
					break
				end
			end
		end

		while #p.anchors > 50 do
			table.remove(p.anchors, 1)
		end
	end

	local function addMilestone(scheduler, eventId: string, universeId: number, sessionId: string?, afterMessageKey: string?, nextOrder: number)
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
		local v7, v8 = loadAdUpsell()
		local scheduler, v9

		if v7 and v8 ~= nil then
			scheduler = v8.scheduler
			v9 = true
		else
			v9 = false
			v8 = nil
		end

		if not v9 or v8 == nil or scheduler == nil then
			return false, false
		end

		local univers = scheduler.universes[tostring(data.universeId)]

		if
			v8.dismissedPermanently == true
			or univers ~= nil and univers.dismissedPermanently
			or not data.isEligiblePublish
		then
			return true, false
		end

		if (univers == nil or not univers.hasShownUpsell) and not hasRecentEvent(scheduler, data.eventId) then -- inferred equivalent call
			rememberEvent(scheduler, data.eventId)
			local universeState = getOrCreateUniverseState(scheduler, data.universeId) -- inferred equivalent call
			local nextOrder = scheduler.nextOrder
			scheduler.nextOrder += 1
			universeState.lastTouchedOrder = nextOrder
			universeState.hasShownUpsell = true
			pruneUniverseCap(scheduler)
			addMilestone(scheduler, data.eventId, data.universeId, data.sessionId, data.afterMessageKey, nextOrder)
			return persistAdUpsellMutation(), true
		end

		return not v4 or persistAdUpsellMutation(), false
	end

	local function recordAdUpsellCompletedTurn(p)
		return recordAdUpsellEvent(p)
	end

	local function recordAdUpsellPublish(p)
		return recordAdUpsellEvent(p)
	end

	local function attachPendingAdUpsellMilestones(universeId: number, sessionId: string, p: string?)
		local v7, v8 = loadAdUpsell()
		local scheduler, v9

		if v7 and v8 ~= nil then
			scheduler = v8.scheduler
			v9 = true
		else
			v9 = false
			v8 = nil
		end

		if not v9 or v8 == nil or scheduler == nil then
			return false
		end

		if v8.dismissedPermanently == true then
			return true
		end

		local pendingMilestones = {}
		local v10 = false

		for _, pendingMilestone in scheduler.pendingMilestones do
			if
				pendingMilestone.universeId == universeId
				and (pendingMilestone.sessionId == nil or pendingMilestone.sessionId == sessionId)
				and (FFlagBuildAdUpsellPinned or p ~= nil)
			then
				local anchors = scheduler.anchors
				local v11 = {
					id = pendingMilestone.id,
					universeId = universeId,
					sessionId = sessionId,
					afterMessageKey = 0,
					order = 0,
					impressed = false
				}
				local afterMessageKey

				if not FFlagBuildAdUpsellPinned then
					afterMessageKey = p
				end

				v11.afterMessageKey = afterMessageKey
				v11.order = pendingMilestone.order
				table.insert(anchors, v11)
				v10 = true
			else
				table.insert(pendingMilestones, pendingMilestone)
			end
		end

		if not v10 then
			return true
		end

		scheduler.pendingMilestones = pendingMilestones
		table.sort(scheduler.anchors, function(a, b): boolean
			return a.order < b.order
		end)

		pruneAnchorCaps(scheduler, universeId, sessionId)
		return persistAdUpsellMutation()
	end

	local function pruneAdUpsellAnchors(p: number, p2: string, p3)
		if FFlagBuildAdUpsellPinned then
			return true, false
		end

		local v7, v8 = loadAdUpsell()
		local scheduler, v9

		if v7 and v8 ~= nil then
			scheduler = v8.scheduler
			v9 = true
		else
			v9 = false
		end

		if not v9 or scheduler == nil then
			return false, false
		end

		local anchors = {}
		local v10 = false

		for _, anchor in scheduler.anchors do
			if
				anchor.universeId == p
				and anchor.sessionId == p2
				and (anchor.afterMessageKey == nil or not p3[anchor.afterMessageKey])
			then
				v10 = true
			else
				table.insert(anchors, anchor)
			end
		end

		if not v10 then
			return true, false
		end

		scheduler.anchors = anchors
		return persistAdUpsellMutation(), true
	end

	local function getAdUpsellState(p: number, p2: string?)
		local v7, v8 = loadAdUpsell()
		local scheduler, v9

		if v7 and v8 ~= nil then
			scheduler = v8.scheduler
			v9 = true
		else
			v9 = false
			v8 = nil
		end

		if not v9 or v8 == nil or scheduler == nil then
			return {
				isAvailable = false,
				dismissedPermanently = true,
				hasShownUpsell = false,
				anchors = {},
				pendingMilestoneCount = 0
			}
		end

		local univers = scheduler.universes[tostring(p)]
		local clones = {}

		if p2 ~= nil then
			for _, anchor in scheduler.anchors do
				if anchor.universeId == p and anchor.sessionId == p2 then
					table.insert(clones, table.clone(anchor))
				end
			end
		end

		local count2 = 0

		for _, pendingMilestone in scheduler.pendingMilestones do
			if
				pendingMilestone.universeId == p
				and (p2 == nil or pendingMilestone.sessionId == nil or pendingMilestone.sessionId == p2)
			then
				count2 += 1
			end
		end

		local dismissedPermanently

		if v8.dismissedPermanently == true then
			dismissedPermanently = true
		elseif univers == nil then
			dismissedPermanently = false
		else
			dismissedPermanently = univers.dismissedPermanently
		end

		return {
			isAvailable = true,
			dismissedPermanently = dismissedPermanently,
			hasShownUpsell = univers ~= nil and univers.hasShownUpsell,
			anchors = clones,
			pendingMilestoneCount = count2
		}
	end

	local function markAdUpsellAnchorImpressed(p: number, p2: string, p3: string): boolean
		local v7, v8 = loadAdUpsell()
		local scheduler, v9

		if v7 and v8 ~= nil then
			scheduler = v8.scheduler
			v9 = true
		else
			v9 = false
			v8 = nil
		end

		if not v9 or v8 == nil or scheduler == nil or v8.dismissedPermanently == true then
			return false
		end

		for _, anchor in scheduler.anchors do
			if anchor.universeId == p and anchor.sessionId == p2 and anchor.id == p3 then
				if anchor.impressed then
					return false
				end

				anchor.impressed = true
				count = 0

				v4 = true
				v6 = v6 or false
				scheduleAdUpsellWriteRetry()

				return true
			end
		end

		return false
	end

	local function markAdUpsellDismissedPermanently(p: number): boolean
		local v7, v8 = loadAdUpsell()

		if v7 and v8 ~= nil and v8.dismissedPermanently == true then
			return true
		end

		local v9

		if v7 and v8 ~= nil then
			v9 = false
		else
			local tryReadData2 = tryReadData
			local v10, v11 = tryReadData2()

			if not v10 then
				local _
				_, v11 = tryReadData2()
			end

			local v12 = type(v11.adUpsell) ~= "table" and {} or table.clone(v11.adUpsell)
			v12.dismissedPermanently = v12.dismissedPermanently == true
			v12.scheduler = sanitizeAdUpsellScheduler(v12.scheduler)
			v3 = v12
			flag2 = false
			v9 = true
		end

		local scheduler = v3.scheduler
		local universeState = getOrCreateUniverseState(scheduler, p) -- inferred equivalent call
		universeState.hasShownUpsell = false
		universeState.dismissedPermanently = true

		local anchors = {}

		for _, anchor in scheduler.anchors do
			if anchor.universeId ~= p then
				table.insert(anchors, anchor)
			end
		end

		scheduler.anchors = anchors
		local pendingMilestones = {}

		for _, pendingMilestone in scheduler.pendingMilestones do
			if pendingMilestone.universeId ~= p then
				table.insert(pendingMilestones, pendingMilestone)
			end
		end

		scheduler.pendingMilestones = pendingMilestones
		count = 0

		count += 1
		v4 = not persistCachedAdUpsell(v9)

		if v4 then
			v6 = v6 or v9 == true
			scheduleAdUpsellWriteRetry()
		else
			count = 0
			v6 = false

			if v5 ~= nil then
				task.cancel(v5)
				v5 = nil
			end
		end

		return not v4
	end

	local function isPushNotificationsUpsellDismissedPermanently(): boolean
		if flag then
			return true
		end

		local pushNotificationsUpsell = readData().pushNotificationsUpsell -- inferred equivalent call
		return type(pushNotificationsUpsell) == "table" and pushNotificationsUpsell.dismissedPermanently == true
	end

	local function markPushNotificationsUpsellDismissedPermanently()
		flag = true

		if FFlagBuildAdUpsell then
			return updateData(function(p) -- inferred equivalent call
				local pushNotificationsUpsell = p.pushNotificationsUpsell

				local pushNotificationsUpsell2 = type(pushNotificationsUpsell) ~= "table" and {}
					or table.clone(pushNotificationsUpsell)

				pushNotificationsUpsell2.dismissedPermanently = true
				p.pushNotificationsUpsell = pushNotificationsUpsell2
			end)
		else
			local data = readData() -- inferred equivalent call
			local pushNotificationsUpsell = data.pushNotificationsUpsell

			local pushNotificationsUpsell2 = type(pushNotificationsUpsell) ~= "table" and {}
				or table.clone(pushNotificationsUpsell)

			pushNotificationsUpsell2.dismissedPermanently = true
			data.pushNotificationsUpsell = pushNotificationsUpsell2
			return writeData(data) -- inferred equivalent call
		end
	end

	local function clearSessionCacheForTests()
		if FFlagBuildAgentAdCampaignCard and adCampaignCardStorage ~= nil then
			adCampaignCardStorage.reset()
		end

		v = nil
		flag = false
		v2 = 0
		v3 = nil
		flag2 = false
		v4 = false
		count = 0

		if v5 ~= nil then
			task.cancel(v5)
		end

		v5 = nil
		v6 = false
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
local getAdCampaignCardStorage

if FFlagBuildAgentAdCampaignCard then
	getAdCampaignCardStorage = buildAppStorage.getAdCampaignCardStorage
end

return {
	getAdCampaignCardStorage = getAdCampaignCardStorage,
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
