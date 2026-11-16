local SessionService = game:GetService("SessionService")

local parent = script.Parent.Parent

local Constants = require(parent.Resources.Constants)
local GetFFlagEnableARFlowSession = require(parent.Flags.GetFFlagEnableARFlowSession)
local SendAnalytics = require(parent.Utility.SendAnalytics)
local SessionUtility = {}

function SessionUtility.startAbuseReportSession(source)
	if GetFFlagEnableARFlowSession() then
		if not SessionService:SessionExists(Constants.Session.StructuralIdentifier.AbuseReport) then
			SessionService:SetSession(
				Constants.Session.StructuralIdentifier.Level1,
				Constants.Session.StructuralIdentifier.AbuseReport,
				Constants.Session.StructuralIdentifier.AbuseReport
			)
		end

		SessionService:SetMetadata(
			Constants.Session.StructuralIdentifier.AbuseReport,
			Constants.Session.Metadata.EntryPoint,
			source
		)

		SessionService:SetMetadata(
			Constants.Session.StructuralIdentifier.AbuseReport,
			Constants.Session.Metadata.DeleteOnGameLeave,
			"True"
		)

		SendAnalytics(Constants.Analytics.ReportFlowOpened, Constants.Analytics.ReportFlowOpened, {
			source = source
		})
	end
end

function SessionUtility.endAbuseReportSession()
	if
		GetFFlagEnableARFlowSession()
		and SessionService:SessionExists(Constants.Session.StructuralIdentifier.AbuseReport)
	then
		SessionService:RemoveSession(Constants.Session.StructuralIdentifier.AbuseReport)
	end
end

return SessionUtility
