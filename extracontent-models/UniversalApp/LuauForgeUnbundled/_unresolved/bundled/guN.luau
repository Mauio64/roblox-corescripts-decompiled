local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/fzK")
local module2 = require("@luauforge/bundled/egs")
local localStorageKey = require("@luauforge/bundled/dFv").Enums.LocalStorageKey
local AppStorageService = game:GetService("AppStorageService")
local DeviceIdService = game:GetService("DeviceIdService")

return function(callback)
	local v5 = module.fromString("apis:original-users/v1/associateBrowserTrackerToDevice")

	local item = tonumber(AppStorageService:GetItem(localStorageKey.BrowserTrackerId))
	local deviceId = DeviceIdService:GetDeviceId()

	if
		item == nil
		or item <= 0
		or deviceId == nil
		or deviceId == ""
		or deviceId == "00000000-0000-0000-0000-000000000000"
	then
		return module2.reject()
	end

	local jsonEncode = HttpService:JSONEncode({
		browser_tracker_id = item,
		device_id = deviceId
	})

	callback(v5(), "POST", { postBody = jsonEncode }):catch(function() end)

	return module2.resolve()
end
