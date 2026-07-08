local SessionService = game:GetService("SessionService")
local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Resources.Constants)
local GetFFlagEnableARFlowSession = require(ParentParent.Flags.GetFFlagEnableARFlowSession)
local SendAnalytics = require(ParentParent.Utility.SendAnalytics)

return {
	startAbuseReportSession = function(p1) -- line: 12
		-- upvalues: GetFFlagEnableARFlowSession (copy), SessionService (copy), Constants (copy), SendAnalytics (copy)
		if GetFFlagEnableARFlowSession() then
			if not SessionService:SessionExists(Constants.Session.StructuralIdentifier.AbuseReport) then
				SessionService:SetSession(Constants.Session.StructuralIdentifier.Level1, Constants.Session.StructuralIdentifier.AbuseReport, Constants.Session.StructuralIdentifier.AbuseReport)
			end

			SessionService:SetMetadata(Constants.Session.StructuralIdentifier.AbuseReport, Constants.Session.Metadata.EntryPoint, p1)
			SessionService:SetMetadata(Constants.Session.StructuralIdentifier.AbuseReport, Constants.Session.Metadata.DeleteOnGameLeave, "True")
			SendAnalytics(Constants.Analytics.ReportFlowOpened, Constants.Analytics.ReportFlowOpened, {
				source = p1
			})
		end
	end,
	endAbuseReportSession = function() -- line: 43
		-- upvalues: GetFFlagEnableARFlowSession (copy), SessionService (copy), Constants (copy)
		if GetFFlagEnableARFlowSession() and SessionService:SessionExists(Constants.Session.StructuralIdentifier.AbuseReport) then
			SessionService:RemoveSession(Constants.Session.StructuralIdentifier.AbuseReport)
		end
	end
}
