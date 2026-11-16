local DsaIllegalContentReporting = script:FindFirstAncestor("DsaIllegalContentReporting")
local parent = DsaIllegalContentReporting.Parent
local Constants = require(DsaIllegalContentReporting.Utility.Constants)
local SharedFlags = require(parent.SharedFlags)

local isInDSAFeaturesOverrideList = require(DsaIllegalContentReporting.Utility.isInDSAFeaturesOverrideList)
local GetFFlagDSAIllegalContentReporting = SharedFlags.GetFFlagDSAIllegalContentReporting

local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")

local v = false

if GetFFlagDSAIllegalContentReporting() then
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

		for _, v2 in ipairs(Constants.ELIGIBLE_COUNTRY_REGION_CODES) do
			if countryRegionForPlayerAsync == v2 then
				v = true
				break
			end
		end
	end)
end

function isShowEUDSAIllegalContentReportingLink()
	if isInDSAFeaturesOverrideList() then
		return true
	end

	return GetFFlagDSAIllegalContentReporting() and v
end

return isShowEUDSAIllegalContentReportingLink
