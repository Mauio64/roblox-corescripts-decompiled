local DsaIllegalContentReporting = script:FindFirstAncestor("DsaIllegalContentReporting")
local DsaIllegalContentReportingParent = DsaIllegalContentReporting.Parent
local Constants = require(DsaIllegalContentReporting.Utility.Constants)
local SharedFlags = require(DsaIllegalContentReportingParent.SharedFlags)
local isInDSAFeaturesOverrideList = require(DsaIllegalContentReporting.Utility.isInDSAFeaturesOverrideList)
local GetFFlagDSAIllegalContentReporting = SharedFlags.GetFFlagDSAIllegalContentReporting
local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")
local u9 = false

if GetFFlagDSAIllegalContentReporting() then
	task.spawn(function() -- line: 18
		-- upvalues: Players (copy), LocalizationService (copy), Constants (copy), u9 (ref)
		local LocalPlayer = Players.LocalPlayer

		while not LocalPlayer do
			Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
			LocalPlayer = Players.LocalPlayer
		end

		local ok, result = pcall(LocalizationService.GetCountryRegionForPlayerAsync, LocalizationService, LocalPlayer)

		if not ok then
			return
		end

		for _, v in ipairs(Constants.ELIGIBLE_COUNTRY_REGION_CODES) do
			if result == v then
				u9 = true

				return
			end
		end
	end)
end

function isShowEUDSAIllegalContentReportingLink() -- line: 41
	-- upvalues: isInDSAFeaturesOverrideList (copy), GetFFlagDSAIllegalContentReporting (copy), u9 (ref)
	if isInDSAFeaturesOverrideList() then
		return true
	end

	return GetFFlagDSAIllegalContentReporting() and u9
end

return isShowEUDSAIllegalContentReportingLink
