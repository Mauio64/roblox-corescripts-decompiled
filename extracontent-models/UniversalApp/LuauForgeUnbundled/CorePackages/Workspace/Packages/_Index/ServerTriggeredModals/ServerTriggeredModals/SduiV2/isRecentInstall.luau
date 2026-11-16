local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")

local fIntEdpGameLeavePromptsRecentInstallWindowDays = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SharedFlags").FIntEdpGameLeavePromptsRecentInstallWindowDays
local isAppFirstLaunchTimestampsSupported = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/isAppFirstLaunchTimestampsSupported")

local function readFirstLaunchTimestamp(p2)
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

	local v5 = result[p2]

	if type(v5) == "number" then
		return v5
	end

	return nil
end

local function isRecentInstall(p2): boolean
	if not isAppFirstLaunchTimestampsSupported() or (p2 == nil or p2 == "" or p2 == "-1") then
		return false
	end

	local v5 = readFirstLaunchTimestamp(p2)

	if v5 == nil then
		return false
	end

	return fIntEdpGameLeavePromptsRecentInstallWindowDays * 86400 >= DateTime.now().UnixTimestamp - v5
end

return isRecentInstall
