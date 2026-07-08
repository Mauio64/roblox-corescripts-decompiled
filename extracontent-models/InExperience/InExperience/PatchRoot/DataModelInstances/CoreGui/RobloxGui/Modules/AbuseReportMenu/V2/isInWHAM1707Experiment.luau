local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")
local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local GetFFlagWHAM1707ExperimentForceEnabled = require(AbuseReportMenu.Flags.GetFFlagWHAM1707ExperimentForceEnabled)
local FStringWHAM1707IXPField = require(AbuseReportMenu.Flags.FStringWHAM1707IXPField)
local FStringEARReportMenuIXPLayer = require(CorePackages.Workspace.Packages.SharedFlags).FStringEARReportMenuIXPLayer

return function() -- line: 13
	-- upvalues: GetFFlagWHAM1707ExperimentForceEnabled (copy), IXPService (copy), FStringEARReportMenuIXPLayer (copy), FStringWHAM1707IXPField (copy)
	if GetFFlagWHAM1707ExperimentForceEnabled() then
		return true
	end

	local ok, result = pcall(function() -- line: 18
		-- upvalues: IXPService (copy), FStringEARReportMenuIXPLayer (copy)
		return IXPService:GetUserLayerVariables(FStringEARReportMenuIXPLayer)
	end)

	if not ok or not result or result[FStringWHAM1707IXPField] == nil then
		return false
	end

	IXPService:LogUserLayerExposure(FStringEARReportMenuIXPLayer)

	return result[FStringWHAM1707IXPField]
end
