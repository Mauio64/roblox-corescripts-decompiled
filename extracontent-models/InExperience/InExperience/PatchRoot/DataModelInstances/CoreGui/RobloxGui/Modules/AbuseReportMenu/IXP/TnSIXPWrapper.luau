local CorePackages = game:GetService("CorePackages")
local default = require(CorePackages.Workspace.Packages.TrustAndSafetyIxp).TrustAndSafetyIXPManager.default

return {
	getReportAnythingAvatarEnabled = function() -- line: 9
		-- upvalues: default (copy)
		return default:getReportAnythingAvatarEnabled()
	end,
	getReportAnythingExperienceEnabled = function() -- line: 12
		-- upvalues: default (copy)
		return default:getReportAnythingExperienceEnabled()
	end
}
