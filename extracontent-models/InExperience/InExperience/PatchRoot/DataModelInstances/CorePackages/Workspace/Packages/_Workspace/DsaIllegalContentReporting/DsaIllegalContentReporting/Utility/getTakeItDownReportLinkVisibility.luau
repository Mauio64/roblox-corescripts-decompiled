local Parent = script:FindFirstAncestor("DsaIllegalContentReporting").Parent
local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")
local FFlagAddTakeItDownReportLinkToSurfaces = require(Parent.SharedFlags).FFlagAddTakeItDownReportLinkToSurfaces
local v5 = game:DefineFastString("CountriesWithTakeItDownReport", "US")
local u6 = false

if FFlagAddTakeItDownReportLinkToSurfaces then
	task.spawn(function() -- line: 18
		-- upvalues: Players (copy), LocalizationService (copy), v5 (copy), u6 (ref)
		local LocalPlayer = Players.LocalPlayer

		while not LocalPlayer do
			Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
			LocalPlayer = Players.LocalPlayer
		end

		local ok, result = pcall(LocalizationService.GetCountryRegionForPlayerAsync, LocalizationService, LocalPlayer)

		if not ok then
			return
		end

		local parts = v5:split(",")

		for _, v in ipairs(parts) do
			if result == v then
				u6 = true

				return
			end
		end
	end)
end

local function getTakeItDownReportLinkVisibility() -- line: 42
	-- upvalues: FFlagAddTakeItDownReportLinkToSurfaces (copy), u6 (ref)
	return FFlagAddTakeItDownReportLinkToSurfaces and u6
end

return getTakeItDownReportLinkVisibility
