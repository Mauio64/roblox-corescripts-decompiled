local Parent = script:FindFirstAncestor("NotApprovedPage").Parent
local MockableProxyServices = require(Parent.MockableProxyServices)
local Localization = require(Parent.RobloxAppLocales).Localization
local LocalizationService = game:GetService("LocalizationService")
local v5 = Localization.new(LocalizationService.RobloxLocaleId)

local function calculateDaysRemaining(s1: string) -- line: 21
	-- upvalues: v5 (copy), MockableProxyServices (copy)
	local dateTime = DateTime.fromIsoDate(s1)

	if not dateTime then
		return v5:Format("Feature.NotApproved.Label.Hours", {
			hours = string.format("%02d", 0),
			minutes = string.format("%02d", 0)
		})
	end

	local v9 = MockableProxyServices.Workspace:GetServerTimeNow() * 1000
	local v10 = dateTime.UnixTimestampMillis - v9

	if v10 < 0 then
		v10 = 0
	end

	if v10 > 86400000 then
		local v11 = math.ceil(v10 / 86400000)

		return v5:Format("Feature.NotApproved.Label.Days", {
			number = v11
		})
	end

	local v12 = math.floor(v10 / 3600000)
	local v13 = math.floor(v10 % 3600000 / 60000)

	if v10 > 0 and v10 < 60000 then
		v13 = 1
	end

	return v5:Format("Feature.NotApproved.Label.Hours", {
		hours = string.format("%02d", v12),
		minutes = string.format("%02d", v13)
	})
end

return calculateDaysRemaining
