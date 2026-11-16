local CorePackages = game:GetService("CorePackages")

local TrustAndSafetyIxp = require(CorePackages.Workspace.Packages.TrustAndSafetyIxp)
local default = TrustAndSafetyIxp.TrustAndSafetyIXPManager.default
local TnSIXPWrapper = {}

function TnSIXPWrapper.getReportAnythingAvatarEnabled()
	return default:getReportAnythingAvatarEnabled()
end

function TnSIXPWrapper.getReportAnythingExperienceEnabled()
	return default:getReportAnythingExperienceEnabled()
end

return TnSIXPWrapper
