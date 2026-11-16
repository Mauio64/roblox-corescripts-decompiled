local WhatsNew = script:FindFirstAncestor("WhatsNew")
local parent = WhatsNew.Parent
local AppCommonLib = require(parent.AppCommonLib)
require(WhatsNew.Types)
local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local appStorageJsonCacheUtils = AppCommonLib.Utils.AppStorageJsonCacheUtils.new(AppStorageService)

local function getOrCreateStoredEntry(entries, p: string) -- 1 equivalent call inferred from this helper
	local storedEntry = entries[p]

	if type(storedEntry) ~= "table" then
		storedEntry = {}
		entries[p] = storedEntry
	end

	return storedEntry
end

local function emptyDeviceData() -- 4 equivalent calls inferred from this helper
	return { entries = {} }
end

local function normalizeDeviceData(p) -- 5 equivalent calls inferred from this helper
	if type(p.entries) ~= "table" then
		p.entries = {}
	end

	return p
end

local function deepClone(entries)
	local result = {}

	if type(entries) ~= "table" then
		return result
	end

	for k, item in entries do
		if type(item) == "table" then
			result[k] = deepClone(item)
		else
			result[k] = item
		end
	end

	return result
end

local function readDeviceData() -- 3 equivalent calls inferred from this helper
	local cachedJsonForKey = appStorageJsonCacheUtils:getCachedJsonForKey("WhatsNewEntries")

	if type(cachedJsonForKey) == "table" then
		return cachedJsonForKey
	end

	return nil
end

local function cloneStoredDeviceData(p) -- 1 equivalent call inferred from this helper
	return normalizeDeviceData({ entries = deepClone(p.entries) }) -- inferred equivalent call
end

local function writeDeviceData(p): boolean
	local success, result = pcall(function()
		return HttpService:JSONEncode(p)
	end)

	if not success or type(result) ~= "string" then
		warn(`WhatsNew EntryStorage: failed to encode storage: {result}`)
		return false
	end

	local success2, result2 = pcall(function()
		AppStorageService:SetItem("WhatsNewEntries", result)
		AppStorageService:Flush()
	end)

	if success2 then
		appStorageJsonCacheUtils:getCachedJsonForKey("WhatsNewEntries", true)
		return true
	end

	warn(`WhatsNew EntryStorage: failed to persist storage: {result2}`)
	return false
end

local function getDeviceData()
	local cachedJsonForKey = readDeviceData() -- inferred equivalent call

	if cachedJsonForKey == nil then
		return emptyDeviceData() -- inferred equivalent call
	end

	return cloneStoredDeviceData(cachedJsonForKey) -- inferred equivalent call
end

local function updateDeviceData(fn)
	local cachedJsonForKey = readDeviceData() -- inferred equivalent call
	local v

	if cachedJsonForKey then
		v = {
			entries = deepClone(cachedJsonForKey.entries)
		}
		normalizeDeviceData(v) -- inferred equivalent call
	else
		v = emptyDeviceData() -- inferred equivalent call
	end

	local v2 = fn(normalizeDeviceData(v)) -- inferred equivalent call

	if v2 == nil then
		return
	end

	writeDeviceData(normalizeDeviceData(v2)) -- inferred equivalent call
end

local function toSnapshot(entries)
	local snapshot = {}

	if type(entries) ~= "table" then
		return snapshot
	end

	for k, item in entries do
		if type(item) == "table" then
			snapshot[k] = { seen = item.seen, optOutCount = 0, adopted = false }
		end
	end

	return snapshot
end

local EntryStorage = {}
EntryStorage.STORAGE_KEY = "WhatsNewEntries"

function EntryStorage.clearJsonCacheForTests()
	appStorageJsonCacheUtils._jsonDecodeCache = {}
end
function EntryStorage.clearForTests()
	writeDeviceData(emptyDeviceData()) -- inferred equivalent call
	appStorageJsonCacheUtils._jsonDecodeCache = {}
end
function EntryStorage.getEntries()
	local cachedJsonForKey = readDeviceData() -- inferred equivalent call
	local v

	if cachedJsonForKey == nil then
		v = emptyDeviceData() -- inferred equivalent call
	else
		v = {
			entries = deepClone(cachedJsonForKey.entries)
		}
		normalizeDeviceData(v) -- inferred equivalent call
	end

	return toSnapshot(v.entries)
end

function EntryStorage.markSeen(p: string, seen: string)
	updateDeviceData(function(p2)
		local storedEntry = getOrCreateStoredEntry(p2.entries, p) -- inferred equivalent call
		storedEntry.seen = seen
		return p2
	end)
end

return EntryStorage
