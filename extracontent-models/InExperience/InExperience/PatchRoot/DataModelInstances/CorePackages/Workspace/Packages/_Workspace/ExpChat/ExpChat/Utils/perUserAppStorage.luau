local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local function getLocalUserKey() -- 2 equivalent calls inferred from this helper
	local localPlayer = Players.LocalPlayer

	if localPlayer == nil then
		return ""
	end

	return (tostring(localPlayer.UserId))
end

local function readLookup(p: string)
	local success, result = pcall(function()
		return AppStorageService:GetItem(p)
	end)

	if not success or type(result) ~= "string" or result == "" then
		return {}
	end

	local success2, result2 = pcall(function()
		return HttpService:JSONDecode(result)
	end)

	if success2 and type(result2) == "table" then
		return result2
	end

	return {}
end

local function writeLookup(p: string, p2)
	local success, result = pcall(function()
		return HttpService:JSONEncode(p2)
	end)

	if success and type(result) == "string" then
		return (pcall(function()
			AppStorageService:SetItem(p, result)
			AppStorageService:Flush()
		end))
	end

	return false
end

local PerUserAppStorage = {}

function PerUserAppStorage.getEntry(p: string)
	local localUserKey = getLocalUserKey() -- inferred equivalent call

	if localUserKey == "" then
		return {}
	end

	local v = readLookup(p)[localUserKey]

	if type(v) == "table" then
		return v
	end

	return {}
end

function PerUserAppStorage.updateEntry(p: string, callback)
	local localUserKey = getLocalUserKey() -- inferred equivalent call

	if localUserKey == "" then
		return
	end

	local v = readLookup(p)
	local v2 = v[localUserKey]
	local v3 = callback(type(v2) ~= "table" and {} or v2)

	if v3 == nil then
		return
	end

	v[localUserKey] = v3
	writeLookup(p, v)
end

return PerUserAppStorage
