local ChromeShared = script:FindFirstAncestor("ChromeShared")

local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local Constants = require(ChromeShared.Unibar.Constants)

local engineFeature = game:GetEngineFeature("InGameMenuStateStorageKey")

local LocalPlayer = Players.LocalPlayer
local v = nil
local flag = false

while not LocalPlayer do
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

local v2 = "player_" .. tostring(not LocalPlayer and 0 or LocalPlayer.UserId)

local function initStore()
	if v.LocalPlayer == nil then
		v.LocalPlayer = {}
	end

	if v.LocalPlayer[v2] == nil then
		v.LocalPlayer[v2] = {}
	end

	if v.AnyPlayer == nil then
		v.AnyPlayer = {}
	end
end

local function localPlayerSelector(p) -- 5 equivalent calls inferred from this helper
	if p and p.LocalPlayer and p.LocalPlayer[v2] then
		return p.LocalPlayer[v2]
	end

	return p
end

local function anyPlayerSelector(p) -- 2 equivalent calls inferred from this helper
	return if p and p.AnyPlayer then p.AnyPlayer else p
end

local function loadStore()
	if not engineFeature then
		return
	end

	local success, result = pcall(function()
		return AppStorageService:GetItem("InGameMenuState")
	end)

	if success then
		flag = true

		if #result > 0 then
			local success2, result2 = pcall(function()
				return HttpService:JSONDecode(result)
			end)

			if success2 then
				v = result2
			else
				v = {}
			end
		else
			v = {}
		end

		initStore()
	end
end

local function saveStore()
	if not engineFeature then
		return
	end

	if flag then
		local success, result = pcall(function()
			return HttpService:JSONEncode(v)
		end)

		if success then
			local success2, result2 = pcall(function()
				AppStorageService:SetItem("InGameMenuState", result)
				AppStorageService:Flush()
			end)

			if not success2 then
				print(result2)
				error("Failed to write JSON to AppStorageService", 0)
			end
		else
			error("Failed to encode JSON", 0)
		end
	end
end

local function deepCopy(items)
	if type(items) ~= "table" then
		return items
	end

	local result = {}

	for k, item in pairs(items) do
		result[k] = deepCopy(item)
	end

	return result
end

local function store(p: string, p2, callback)
	if not flag then
		loadStore()
	end

	if flag then
		local v3 = callback and callback(v) or v
		local v4 = v3[p]
		v3[p] = deepCopy(p2)

		if v4 ~= v3[p] then
			saveStore()
		end
	end
end

local function load(p: string, callback)
	if not flag then
		loadStore()
	end

	local v3 = flag and (callback and callback(v) or v)

	if v3 then
		return (deepCopy(v3[p]))
	end

	return nil
end

local function getUniversesExposedTo(p: string) -- 2 equivalent calls inferred from this helper
	if not flag then
		loadStore()
	end

	local v3

	if flag then
		local v4

		if localPlayerSelector then
			v4 = v
			v4 = localPlayerSelector(v4) or v -- inferred equivalent call
		else
			v4 = v
		end

		if v4 then
			v3 = deepCopy(v4[p])
		end
	end

	return v3 or {}
end

local LocalStore = {}

function LocalStore.isEnabled()
	return engineFeature
end

function LocalStore.storeForLocalPlayer(p, p2)
	if not flag then
		loadStore()
	end

	if flag then
		local v3

		if localPlayerSelector then
			v3 = v
			v3 = localPlayerSelector(v3) or v -- inferred equivalent call
		else
			v3 = v
		end

		local v4 = v3[p]
		v3[p] = deepCopy(p2)

		if v4 ~= v3[p] then
			saveStore()
		end
	end
end
function LocalStore.loadForLocalPlayer(p)
	if not flag then
		loadStore()
	end

	if not flag then
		return nil
	end

	local v3

	if localPlayerSelector then
		v3 = v
		v3 = localPlayerSelector(v3) or v -- inferred equivalent call
	else
		v3 = v
	end

	if v3 then
		return (deepCopy(v3[p]))
	end

	return nil
end

function LocalStore.storeForAnyPlayer(p, p2)
	if not flag then
		loadStore()
	end

	if flag then
		local v3

		if anyPlayerSelector then
			v3 = v
			v3 = anyPlayerSelector(v3) or v -- inferred equivalent call
		else
			v3 = v
		end

		local v4 = v3[p]
		v3[p] = deepCopy(p2)

		if v4 ~= v3[p] then
			saveStore()
		end
	end
end
function LocalStore.loadForAnyPlayer(p)
	if not flag then
		loadStore()
	end

	if not flag then
		return nil
	end

	local v3

	if anyPlayerSelector then
		v3 = v
		v3 = anyPlayerSelector(v3) or v -- inferred equivalent call
	else
		v3 = v
	end

	if v3 then
		return (deepCopy(v3[p]))
	end

	return nil
end

function LocalStore.clearCache()
	flag = false
	v = nil
end

function LocalStore.getValue(p: string)
	if not flag then
		loadStore()
	end

	if not flag then
		return nil
	end

	local v3

	if localPlayerSelector then
		v3 = v
		v3 = localPlayerSelector(v3) or v -- inferred equivalent call
	else
		v3 = v
	end

	if v3 then
		return (deepCopy(v3[p]))
	end

	return nil
end

LocalStore.getUniversesExposedTo = getUniversesExposedTo

function LocalStore.getNumUniversesExposedTo(p)
	return #getUniversesExposedTo(p) -- inferred equivalent call
end

function LocalStore.addUniverseToExposureList(p: string, p2: number)
	local universesExposedTo = getUniversesExposedTo(p) -- inferred equivalent call

	if not table.find(universesExposedTo, p2) and #universesExposedTo < Constants.MAX_NUM_UNIVERSES_SHOWN then
		table.insert(universesExposedTo, p2)

		if not flag then
			loadStore()
		end

		if flag then
			local v3

			if localPlayerSelector then
				v3 = v
				v3 = localPlayerSelector(v3) or v -- inferred equivalent call
			else
				v3 = v
			end

			local v4 = v3[p]
			v3[p] = deepCopy(universesExposedTo)

			if v4 ~= v3[p] then
				saveStore()
			end
		end
	end
end

return LocalStore
