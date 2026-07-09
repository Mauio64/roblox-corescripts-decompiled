local Modules = game:GetService("CoreGui").RobloxGui.Modules
local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local Promise = require(Modules.LuaApp.Promise)
local LocalStorageKey = require(CorePackages.Workspace.Packages.LocalStorage).Enums.LocalStorageKey
local AppStorageService = game:GetService("AppStorageService")
local DeviceIdService = game:GetService("DeviceIdService")

return function(p1) -- line: 15
	-- upvalues: UrlBuilder (copy), AppStorageService (copy), LocalStorageKey (copy), DeviceIdService (copy), Promise (copy), HttpService (copy)
	local v10 = UrlBuilder.fromString("apis:original-users/v1/associateBrowserTrackerToDevice")
	local num = tonumber(AppStorageService:GetItem(LocalStorageKey.BrowserTrackerId))
	local DeviceId = DeviceIdService:GetDeviceId()

	if num == nil or num <= 0 or DeviceId == nil or DeviceId == "" or DeviceId == "00000000-0000-0000-0000-000000000000" then
		return Promise.reject()
	end

	local json = HttpService:JSONEncode({
		browser_tracker_id = num,
		device_id = DeviceId
	})

	p1(v10(), "POST", {
		postBody = json
	}):catch(function() -- line: 37
	end)

	return Promise.resolve()
end
