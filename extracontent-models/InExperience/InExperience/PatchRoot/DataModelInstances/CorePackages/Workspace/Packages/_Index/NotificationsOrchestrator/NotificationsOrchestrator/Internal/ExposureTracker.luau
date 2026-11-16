local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local NotificationsOrchestrator = script:FindFirstAncestor("NotificationsOrchestrator")
local parent = NotificationsOrchestrator.Parent

local SignalsUtils = require(parent.SignalsUtils)
local createSessionScopedSignal = SignalsUtils.createSessionScopedSignal
local LocalUserIdStore = require(parent.LocalUserIdStore)
local localUserIdStore = LocalUserIdStore.LocalUserIdStore

local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local SafeAppStorageService = AvatarExperienceCommon.Lib.SafeAppStorageService

local FIntNotificationsOrchestratorExposureTrackerVersion = require(NotificationsOrchestrator.Flags.FIntNotificationsOrchestratorExposureTrackerVersion)
require(NotificationsOrchestrator.Types)

local sessionScopedSignal, v = createSessionScopedSignal({})

local function currentUserId() -- 2 equivalent calls inferred from this helper
	local currentUserId2 = localUserIdStore.getCurrentUserId(false)

	if currentUserId2 ~= "" then
		return currentUserId2
	end

	local localPlayer = Players.LocalPlayer

	if localPlayer == nil or not (localPlayer.UserId > 0) then
		return "default_userid"
	end

	return (tostring(localPlayer.UserId))
end

local function systemNow()
	return os.time()
end

local v2 = systemNow

local function now() -- 2 equivalent calls inferred from this helper
	return v2()
end

local function currentVersionKey() -- 2 equivalent calls inferred from this helper
	return (tostring(FIntNotificationsOrchestratorExposureTrackerVersion))
end

local function emptyRecord() -- 4 equivalent calls inferred from this helper
	return { count = 0, lastShownAt = 0, shownAt = {} }
end

local function decodeShownAt(shownAt)
	if typeof(shownAt) ~= "table" then
		return {}
	end

	local result = {}

	for _, item in shownAt do
		if typeof(item) == "number" then
			table.insert(result, item)
		end
	end

	return result
end

local function decodeRecord(item)
	if typeof(item) == "number" then
		return { count = item, lastShownAt = 0, shownAt = {} }
	end

	if typeof(item) == "table" then
		return {
			count = typeof(item.count) ~= "number" and 0 or item.count,
			lastShownAt = typeof(item.lastShownAt) ~= "number" and 0 or item.lastShownAt,
			shownAt = decodeShownAt(item.shownAt)
		}
	end

	return nil
end

local function decodeRecords(items)
	local result = {}

	for k, item in items do
		if typeof(k) ~= "string" then
			continue
		end

		local v3 = decodeRecord(item)

		if v3 ~= nil then
			result[k] = v3
		end
	end

	return result
end

local function readTracker()
	local item = SafeAppStorageService.getItem("NotificationsOrchestratorGlobalTracker")

	if item == "" then
		return {}
	end

	local success, result = pcall(function()
		return HttpService:JSONDecode(item)
	end)

	if not success or typeof(result) ~= "table" then
		return {}
	end

	local result2 = {}

	for k, v3 in result do
		if typeof(k) == "string" then
			result2[k] = v3
		end
	end

	return result2
end

local function writeTracker(p) -- 2 equivalent calls inferred from this helper
	SafeAppStorageService.setItem("NotificationsOrchestratorGlobalTracker", HttpService:JSONEncode(p))
	SafeAppStorageService.flush()
end

local function dropOlderVersions(tracker) -- 1 equivalent call inferred from this helper
	local v3 = false

	for k in tracker do
		local v4 = tonumber(k)

		if not (v4 ~= nil and v4 < FIntNotificationsOrchestratorExposureTrackerVersion) then
			continue
		end

		tracker[k] = nil
		v3 = true
	end

	return v3
end

local function loadTracker() -- 4 equivalent calls inferred from this helper
	local tracker = readTracker()

	if dropOlderVersions(tracker) then -- inferred equivalent call
		writeTracker(tracker) -- inferred equivalent call
	end

	return tracker
end

local function recordsForCurrentUser(p)
	local v3 = p[currentVersionKey()] -- inferred equivalent call

	if typeof(v3) ~= "table" then
		return {}
	end

	local v4 = v3[currentUserId()] -- inferred equivalent call

	if typeof(v4) == "table" then
		return decodeRecords(v4)
	end

	return {}
end

local function readPersistedRecords() -- 3 equivalent calls inferred from this helper
	return recordsForCurrentUser(loadTracker()) -- inferred equivalent call
end

local function writePersistedRecords(p)
	local tracker = loadTracker() -- inferred equivalent call
	local v3 = currentVersionKey() -- inferred equivalent call
	local v4 = {}
	local v5 = tracker[v3]

	if typeof(v5) == "table" then
		for k, v6 in v5 do
			if typeof(k) == "string" then
				v4[k] = v6
			end
		end
	end

	local v6 = currentUserId() -- inferred equivalent call
	v4[v6] = p
	tracker[v3] = v4
	writeTracker(tracker) -- inferred equivalent call
end

local function initialize()
	loadTracker() -- inferred equivalent call
end

local function snapshot(data) -- 3 equivalent calls inferred from this helper
	if data == nil then
		return emptyRecord() -- inferred equivalent call
	end

	return {
		count = data.count,
		lastShownAt = data.lastShownAt,
		shownAt = table.clone(data.shownAt)
	}
end

local function retainRecent(shownAt, p: number, seconds: number) -- 2 equivalent calls inferred from this helper
	local v3 = p - seconds
	local result = {}

	for _, item in shownAt do
		if v3 <= item then
			table.insert(result, item)
		end
	end

	return result
end

local function record(p, p2)
	local lastShownAt = now() -- inferred equivalent call

	if p2 == "session" then
		local clone = table.clone(sessionScopedSignal(false))
		local v3 = clone[p]
		clone[p] = {
			count = (v3 == nil and 0 or v3.count) + 1,
			lastShownAt = lastShownAt,
			shownAt = {}
		}

		v(clone)
	else
		local persistedRecords = readPersistedRecords() -- inferred equivalent call
		local v3 = persistedRecords[p]
		local v4 = v3 == nil and emptyRecord() or snapshot(v3) -- inferred equivalent call
		v4.count += 1
		v4.lastShownAt = lastShownAt

		if typeof(p2) == "table" and p2.kind == "rolling" then
			table.insert(v4.shownAt, lastShownAt)
			v4.shownAt = retainRecent(v4.shownAt, lastShownAt, p2.seconds) -- inferred equivalent call
		end

		persistedRecords[p] = v4
		writePersistedRecords(persistedRecords)
	end
end

local function getExposure(p, p2)
	if p2 == "session" then
		return snapshot(sessionScopedSignal(false)[p]) -- inferred equivalent call
	end

	return snapshot(readPersistedRecords()[p]) -- inferred equivalent call
end

local function getCount(p, p2)
	local v3

	if p2 == "session" then
		local v4 = sessionScopedSignal(false)[p]

		if v4 == nil then
			v3 = emptyRecord() -- inferred equivalent call
		else
			v3 = {
				count = v4.count,
				lastShownAt = v4.lastShownAt,
				shownAt = table.clone(v4.shownAt)
			}
		end
	else
		local v4 = readPersistedRecords()[p] -- inferred equivalent call

		if v4 == nil then
			v3 = emptyRecord() -- inferred equivalent call
		else
			v3 = {
				count = v4.count,
				lastShownAt = v4.lastShownAt,
				shownAt = table.clone(v4.shownAt)
			}
		end
	end

	if typeof(p2) ~= "table" or p2.kind ~= "rolling" then
		return v3.count
	end

	return #retainRecent(v3.shownAt, now(), p2.seconds) -- inferred equivalent call
end

local function setNowForTesting(callback)
	v2 = callback or systemNow
end

local function resetForTesting()
	v({})
	v2 = systemNow
end

loadTracker() -- inferred equivalent call
return {
	record = record,
	getExposure = getExposure,
	getCount = getCount,
	now = now,
	initialize = initialize,
	setNowForTesting = setNowForTesting,
	resetForTesting = resetForTesting,
	STORAGE_KEY = "NotificationsOrchestratorGlobalTracker"
}
