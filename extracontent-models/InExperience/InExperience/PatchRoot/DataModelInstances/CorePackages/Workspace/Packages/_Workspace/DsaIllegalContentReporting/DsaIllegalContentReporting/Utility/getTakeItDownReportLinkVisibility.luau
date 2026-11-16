local parent = script:FindFirstAncestor("DsaIllegalContentReporting").Parent
local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")

local SharedFlags = require(parent.SharedFlags)
local FFlagAddTakeItDownReportLinkToSurfaces = SharedFlags.FFlagAddTakeItDownReportLinkToSurfaces

local defineFastString = game:DefineFastString("CountriesWithTakeItDownReport", "US")

local v = false

if FFlagAddTakeItDownReportLinkToSurfaces then
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

		for _, part in ipairs(parts) do
			if countryRegionForPlayerAsync == part then
				v = true
				break
			end
		end
	end)
end

local function getTakeItDownReportLinkVisibility()
	return FFlagAddTakeItDownReportLinkToSurfaces and v
end

return getTakeItDownReportLinkVisibility
