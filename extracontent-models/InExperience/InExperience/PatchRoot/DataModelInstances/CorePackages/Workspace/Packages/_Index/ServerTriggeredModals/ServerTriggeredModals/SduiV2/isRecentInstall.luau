local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("ServerTriggeredModals").Parent

local SharedFlags = require(parent.SharedFlags)
local FIntEdpGameLeavePromptsRecentInstallWindowDays = SharedFlags.FIntEdpGameLeavePromptsRecentInstallWindowDays
local isAppFirstLaunchTimestampsSupported = require(script.Parent.isAppFirstLaunchTimestampsSupported)

local function readFirstLaunchTimestamp(p: string)
	local item = AppStorageService:GetItem("AppFirstLaunchTimestamps")

	if typeof(item) ~= "string" or item == "" then
		return nil
	end

	local success, result = pcall(function()
		return HttpService:JSONDecode(item)
	end)

	if not success or type(result) ~= "table" then
		return nil
	end

	local v = result[p]
	return if type(v) == "number" then v else nil
end

local function isRecentInstall(p: string?): boolean
	if not isAppFirstLaunchTimestampsSupported() or (p == nil or p == "" or p == "-1") then
		return false
	end

	local v = readFirstLaunchTimestamp(p)

	if v == nil then
		return false
	end

	return FIntEdpGameLeavePromptsRecentInstallWindowDays * 86400 >= DateTime.now().UnixTimestamp - v
end

return isRecentInstall
