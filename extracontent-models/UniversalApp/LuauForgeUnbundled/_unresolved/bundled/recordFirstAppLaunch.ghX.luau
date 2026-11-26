local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")

local localStorageKey = require("@luauforge/bundled/dFv").Enums.LocalStorageKey
local fIntEdpGameLeavePromptsFirstLaunchMaxEntries = require("@game/CorePackages/Workspace/Packages/SharedFlags").FIntEdpGameLeavePromptsFirstLaunchMaxEntries
local module = require("@luauforge/bundled/ghY")

local function evictOldestEntries(unixTimestamps)
	local v5 = {}

	for k in unixTimestamps do
		table.insert(v5, k)
	end

	local v6 = #v5 - fIntEdpGameLeavePromptsFirstLaunchMaxEntries

	if v6 <= 0 then
		return
	end

	table.sort(v5, function(a, b): boolean
		return (tonumber(unixTimestamps[a]) or 0) < (tonumber(unixTimestamps[b]) or 0)
	end)

	for i = 1, v6 do
		unixTimestamps[v5[i]] = nil
	end
end

local function recordFirstAppLaunch(p2, p3)
	if not module() then
		return
	end

	local v5 = p3 or AppStorageService
	local v6 = tostring(p2)
	local item = v5:GetItem(localStorageKey.AppFirstLaunchTimestamps)

	local unixTimestamps = {}

	if typeof(item) == "string" and item ~= "" then
		local success, result = pcall(function()
			return HttpService:JSONDecode(item)
		end)

		if success and type(result) == "table" then
			unixTimestamps = result
		end
	end

	if unixTimestamps[v6] ~= nil then
		return
	end

	unixTimestamps[v6] = DateTime.now().UnixTimestamp
	evictOldestEntries(unixTimestamps)

	local success, result = pcall(function()
		return HttpService:JSONEncode(unixTimestamps)
	end)

	if not success then
		return
	end

	v5:SetItem(localStorageKey.AppFirstLaunchTimestamps, result)
	v5:Flush()
end

return recordFirstAppLaunch
