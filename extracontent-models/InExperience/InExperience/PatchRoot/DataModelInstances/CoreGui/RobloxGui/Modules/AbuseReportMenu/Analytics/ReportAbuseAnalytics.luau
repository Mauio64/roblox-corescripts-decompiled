local SessionService = game:GetService("SessionService")
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local t1 = {}

t1.__index = t1
t1.MenuContexts = {
	LegacyMenu = game:DefineFastString("ReportAnalyticsLegacyMenuContext", "ReportAbuseLegacyMenu"),
	LegacySentPage = game:DefineFastString("ReportAnalyticsLegacySentPageContext", "ReportAbuseLegacySentPage"),
	NewMenu = game:DefineFastString("ReportAnalyticsNewMenuContext", "ReportAbuseNewMenu")
}
t1.DiagCounters = {
	SuccessfulSubmissionTime = game:DefineFastString("ReportAnalyticsSuccessfulSubmissionTimeStat", "SuccessfulSubmissionTime"),
	AbandonedSubmissionTime = game:DefineFastString("ReportAnalyticsAbandonedSubmissionTimeStat", "AbandonedSubmissionTime"),
	SubmittedMethodOfAbuse = game:DefineFastString("ReportAnalyticsSubmittedMethodOfAbuseStat", "SubmittedMethodOfAbuse")
}
t1.ActionNames = {
	FieldChanged = game:DefineFastString("ReportAnalyticsFieldChanged", "FieldChanged"),
	FormSubmitted = game:DefineFastString("ReportAnalyticsFormSubmitted", "FormSubmitted"),
	FormAbandoned = game:DefineFastString("ReportAnalyticsFormAbandoned", "FormAbandoned"),
	ButtonActivated = game:DefineFastString("ReportAnalyticsButtonActivated", "ButtonActivated"),
	InGameAbuseReport = game:DefineFastString("ReportAnalyticsInGameAbuseReport", "InGameAbuseReport")
}
t1.SessionConstants = {
	StructuralIdentifier = {
		Level1 = "level1",
		AbuseReport = "AbuseReport"
	},
	Metadata = {
		EntryPoint = "entryPoint",
		DeleteOnGameLeave = "_deleteOnGameLeave"
	}
}

local _ = {
	SUBMIT = 1,
	ABANDON = 2
}

function t1.new(p1, p2, p3) -- line: 57
	-- upvalues: t1 (copy)
	assert(p3, "Base context needs to be provided to ReportAbuseAnalytics")

	local t2 = {
		_eventStreamImpl = p1,
		_diagImpl = p2,
		_context = p3
	}

	setmetatable(t2, t1)

	return t2
end
function t1.reportFormSubmitted(p4, p5, p6, p7) -- line: 70
	-- upvalues: t1 (copy), Cryo (copy)
	local v14 = p4._context .. "_" .. t1.DiagCounters.SuccessfulSubmissionTime
	local v15 = p4._context .. "_" .. t1.DiagCounters.SubmittedMethodOfAbuse .. "_" .. p6
	local v16 = Cryo.Dictionary.join(p7 or {}, {
		timeToComplete = p5,
		methodOfAbuse = p6
	})

	p4._diagImpl:reportStats(v14, p5)
	p4._diagImpl:reportCounter(v15, 1)
	p4._eventStreamImpl:sendEventDeferred(p4._context, t1.ActionNames.FormSubmitted, v16)
end
function t1.reportFormAbandoned(p8, p9, p10) -- line: 93
	-- upvalues: t1 (copy), Cryo (copy)
	local v20 = p8._context .. "_" .. t1.DiagCounters.AbandonedSubmissionTime
	local v21 = Cryo.Dictionary.join(p10 or {}, {
		timeToExit = p9
	})

	p8._diagImpl:reportStats(v20, p9)
	p8._eventStreamImpl:sendEventDeferred(p8._context, t1.ActionNames.FormAbandoned, v21)
end
function t1.reportAnalyticsFieldChanged(p11, p12) -- line: 108
	-- upvalues: t1 (copy)
	p11._eventStreamImpl:sendEventDeferred(p11._context, t1.ActionNames.FieldChanged, p12 or {})
end
function t1.reportButtonClick(p13, p14) -- line: 116
	-- upvalues: t1 (copy)
	p13._eventStreamImpl:sendEventDeferred(p13._context, t1.ActionNames.ButtonActivated, p14 or {})
end
function t1.reportInGameAbuseReportInteraction(t3: {[any]: any}, t4: {[any]: any}) -- line: 129
	-- upvalues: t1 (copy)
	local v28 = t4.interactionType == 1
	local AbandonedSubmissionTime = t1.DiagCounters.AbandonedSubmissionTime

	if v28 then
		AbandonedSubmissionTime = t1.DiagCounters.SuccessfulSubmissionTime

		local v30 = t3._context .. "_" .. t1.DiagCounters.SubmittedMethodOfAbuse .. "_" .. t4.inferredTypeofabuseSelection

		t3._diagImpl:reportCounter(v30, 1)
	end

	local v31 = t3._context .. "_" .. AbandonedSubmissionTime

	t3._diagImpl:reportStats(v31, t4.timeSpentMs)
	t3._eventStreamImpl:sendEventDeferred(t3._context, t1.ActionNames.InGameAbuseReport, t4)
end
function t1.reportEventAndIncrement(p15, p16, p17) -- line: 150
	p15._diagImpl:reportCounter(p15._context .. "_" .. p16, 1)
	p15._eventStreamImpl:sendEventDeferred(p15._context, p16, p17 or {})
end
function t1.startAbuseReportSession(_, p19) -- line: 156
	-- upvalues: SessionService (copy), t1 (copy)
	if not SessionService:SessionExists(t1.SessionConstants.StructuralIdentifier.AbuseReport) then
		SessionService:SetSession(t1.SessionConstants.StructuralIdentifier.Level1, t1.SessionConstants.StructuralIdentifier.AbuseReport, t1.SessionConstants.StructuralIdentifier.AbuseReport)
	end

	if not SessionService:GetMetadata(t1.SessionConstants.StructuralIdentifier.AbuseReport, t1.SessionConstants.Metadata.EntryPoint) then
		SessionService:SetMetadata(t1.SessionConstants.StructuralIdentifier.AbuseReport, t1.SessionConstants.Metadata.EntryPoint, p19)
	end

	SessionService:SetMetadata(t1.SessionConstants.StructuralIdentifier.AbuseReport, t1.SessionConstants.Metadata.DeleteOnGameLeave, "True")
end
function t1.getAbuseReportSessionEntryPoint(_) -- line: 188
	-- upvalues: SessionService (copy), t1 (copy)
	if SessionService:SessionExists(t1.SessionConstants.StructuralIdentifier.AbuseReport) then
		return (SessionService:GetMetadata(t1.SessionConstants.StructuralIdentifier.AbuseReport, t1.SessionConstants.Metadata.EntryPoint))
	end

	return ""
end
function t1.endAbuseReportSession(_) -- line: 202
	-- upvalues: SessionService (copy), t1 (copy)
	if SessionService:SessionExists(t1.SessionConstants.StructuralIdentifier.AbuseReport) then
		SessionService:RemoveSession(t1.SessionConstants.StructuralIdentifier.AbuseReport)
	end
end

return t1
