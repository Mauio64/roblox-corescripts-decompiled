local HttpService = game:GetService("HttpService")
local AppStorageService = game:GetService("AppStorageService")

local default = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Utils.AppStorageJsonCacheUtils.default

local v5 = {
	Home = "home",
	MostRecentGame = "most_recent_game",
	SpecificGame = "specific_game"
}

local v6 = {}

local v7 = { LaunchDestinationEnum = v5 }

function v7.isValidLocalUserId(p2): boolean
	local v8 = tonumber(p2)
	return v8 ~= nil and v8 > 0
end

function v7.getLaunchDestinationFromName(p2)
	if not p2 then
		return nil
	end

	for k, v8 in v5 do
		if v8 == p2 then
			return v8
		end
	end

	return nil
end

local function defaultPreference()
	return { destination = v5.Home }
end

local function decodePreference(value)
	if type(value) == "string" then
		local launchDestinationFromName = v7.getLaunchDestinationFromName(value)

		if launchDestinationFromName then
			return { destination = launchDestinationFromName }
		end

		return nil
	else
		if type(value) ~= "table" then
			return nil
		end

		local launchDestinationFromName = v7.getLaunchDestinationFromName(value.destination)

		if not launchDestinationFromName then
			return nil
		end

		local v9 = if type(value.placeId) == "string" then value.placeId else nil
		local v10 = if type(value.name) == "string" then value.name else nil
		return { destination = launchDestinationFromName, placeId = v9, name = v10 }
	end
end

function v7.getCachedLaunchDestination(p2, options)
	if not v7.isValidLocalUserId(p2) then
		return { destination = v5.Home }
	end

	if not options and v6[p2] then
		return v6[p2]
	end

	local result = ((options or {}).appStorageJsonCacheUtils or default):decodeInternal("LaunchDestinationStorageKey").result
	local v8 = if type(result) == "table" then result[p2] else nil
	local v9 = decodePreference(v8) or { destination = v5.Home }

	if not options then
		v6[p2] = v9
	end

	return v9
end

local function persist(p2, p3, options)
	local v8 = options or {}
	local appStorageJsonCacheUtils = v8.appStorageJsonCacheUtils or default
	local appStorageService = v8.appStorageService or AppStorageService
	local httpService = v8.httpService or HttpService
	local result = appStorageJsonCacheUtils:decodeInternal("LaunchDestinationStorageKey").result

	local v9 = type(result) ~= "table" and {} or result

	v9[p2] = p3

	if not options then
		v6[p2] = p3
	end

	local success, result2 = pcall(function()
		appStorageService:SetItem("LaunchDestinationStorageKey", httpService:JSONEncode(v9))
		appStorageService:Flush()
	end)

	if not success then
		warn("[LaunchDestinationUtils] Failed to persist setting: " .. tostring(result2))
	end
end

function v7.setCachedLaunchDestination(p2, p3, p4)
	if not v7.isValidLocalUserId(p2) then
		return
	end

	local launchDestinationFromName = v7.getLaunchDestinationFromName(p3)

	if not launchDestinationFromName or launchDestinationFromName == v5.SpecificGame then
		return
	end

	persist(p2, { destination = launchDestinationFromName }, p4)
end

function v7.setCachedSpecificGame(p2, value, p3, p4)
	if not v7.isValidLocalUserId(p2) or (type(value) ~= "string" or value == "") then
		return
	end

	persist(p2, { destination = v5.SpecificGame, placeId = value, name = p3 }, p4)
end

return v7
