local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")

local v5 = false

task.spawn(function()
	local localPlayer = Players.LocalPlayer

	while not localPlayer do
		Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
		localPlayer = Players.LocalPlayer
	end

	local success, countryRegionForPlayerAsync = pcall(
		LocalizationService.GetCountryRegionForPlayerAsync,
		LocalizationService,
		localPlayer
	)

	if not success then
		return
	end

	if countryRegionForPlayerAsync == "GB" then
		v5 = true
	end
end)

local function isShowUKOSAIllegalContentReportingLink()
	return v5
end

return isShowUKOSAIllegalContentReportingLink
