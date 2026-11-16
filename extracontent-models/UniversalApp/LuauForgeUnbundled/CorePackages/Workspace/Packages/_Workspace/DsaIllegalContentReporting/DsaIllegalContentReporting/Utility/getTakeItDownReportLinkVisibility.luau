local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")

local fFlagAddTakeItDownReportLinkToSurfaces = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/SharedFlags").FFlagAddTakeItDownReportLinkToSurfaces

local defineFastString = game:DefineFastString("CountriesWithTakeItDownReport", "US")

local v5 = false

if fFlagAddTakeItDownReportLinkToSurfaces then
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

		local parts = defineFastString:split(",")

		for i, part in ipairs(parts) do
			if countryRegionForPlayerAsync == part then
				v5 = true
				break
			end
		end
	end)
end

local function getTakeItDownReportLinkVisibility()
	return fFlagAddTakeItDownReportLinkToSurfaces and v5
end

return getTakeItDownReportLinkVisibility
