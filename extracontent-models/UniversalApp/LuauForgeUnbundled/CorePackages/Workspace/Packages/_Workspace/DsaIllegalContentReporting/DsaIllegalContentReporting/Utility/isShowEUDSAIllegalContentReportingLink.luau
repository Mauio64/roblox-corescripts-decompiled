local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/DsaIllegalContentReporting/Utility/Constants")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/SharedFlags")

local isInDSAFeaturesOverrideList = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/DsaIllegalContentReporting/Utility/isInDSAFeaturesOverrideList")
local getFFlagDSAIllegalContentReporting = SharedFlags.GetFFlagDSAIllegalContentReporting

local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")

local v5 = false

if getFFlagDSAIllegalContentReporting() then
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

		for i, v6 in ipairs(Constants.ELIGIBLE_COUNTRY_REGION_CODES) do
			if countryRegionForPlayerAsync == v6 then
				v5 = true
				break
			end
		end
	end)
end

function LUAUFORGE_MODULE_GLOBALS_cXI_isShowEUDSAIllegalContentReportingLink()
	if isInDSAFeaturesOverrideList() then
		return true
	end

	return getFFlagDSAIllegalContentReporting() and v5
end

return LUAUFORGE_MODULE_GLOBALS_cXI_isShowEUDSAIllegalContentReportingLink
