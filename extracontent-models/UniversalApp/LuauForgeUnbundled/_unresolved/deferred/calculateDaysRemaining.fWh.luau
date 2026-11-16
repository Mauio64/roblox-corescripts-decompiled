local module = require("@luauforge/deferred/fUQ")
local localization = require("@luauforge/deferred/fVe").Localization
local LocalizationService = game:GetService("LocalizationService")
local v5 = localization.new(LocalizationService.RobloxLocaleId)

local function calculateDaysRemaining(p2)
	local dateTime = DateTime.fromIsoDate(p2)

	if not dateTime then
		return v5:Format("Feature.NotApproved.Label.Hours", {
			hours = string.format("%02d", 0),
			minutes = string.format("%02d", 0)
		})
	end

	local v6 = module.Workspace:GetServerTimeNow() * 1000
	local v7 = dateTime.UnixTimestampMillis - v6

	local v8 = v7 < 0 and 0 or v7

	if v8 > 86400000 then
		return v5:Format("Feature.NotApproved.Label.Days", {
			number = math.ceil(v8 / 86400000)
		})
	end

	local v9 = math.floor(v8 / 3600000)
	local v10 = math.floor(v8 % 3600000 / 60000)

	local v11 = v8 > 0 and v8 < 60000 and 1 or v10

	return v5:Format("Feature.NotApproved.Label.Hours", {
		hours = string.format("%02d", v9),
		minutes = string.format("%02d", v11)
	})
end

return calculateDaysRemaining
