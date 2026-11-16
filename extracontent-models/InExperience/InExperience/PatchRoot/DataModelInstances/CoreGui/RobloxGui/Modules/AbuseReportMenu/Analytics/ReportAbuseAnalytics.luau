local SessionService = game:GetService("SessionService")

local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)

local ReportAbuseAnalytics = {}
ReportAbuseAnalytics.__index = ReportAbuseAnalytics

ReportAbuseAnalytics.MenuContexts = {
	LegacyMenu = game:DefineFastString("ReportAnalyticsLegacyMenuContext", "ReportAbuseLegacyMenu"),
	LegacySentPage = game:DefineFastString("ReportAnalyticsLegacySentPageContext", "ReportAbuseLegacySentPage"),
	NewMenu = game:DefineFastString("ReportAnalyticsNewMenuContext", "ReportAbuseNewMenu")
}

ReportAbuseAnalytics.DiagCounters = {
	SuccessfulSubmissionTime = game:DefineFastString(
		"ReportAnalyticsSuccessfulSubmissionTimeStat",
		"SuccessfulSubmissionTime"
	),
	AbandonedSubmissionTime = game:DefineFastString(
		"ReportAnalyticsAbandonedSubmissionTimeStat",
		"AbandonedSubmissionTime"
	),
	SubmittedMethodOfAbuse = game:DefineFastString(
		"ReportAnalyticsSubmittedMethodOfAbuseStat",
		"SubmittedMethodOfAbuse"
	)
}

ReportAbuseAnalytics.ActionNames = {
	FieldChanged = game:DefineFastString("ReportAnalyticsFieldChanged", "FieldChanged"),
	FormSubmitted = game:DefineFastString("ReportAnalyticsFormSubmitted", "FormSubmitted"),
	FormAbandoned = game:DefineFastString("ReportAnalyticsFormAbandoned", "FormAbandoned"),
	ButtonActivated = game:DefineFastString("ReportAnalyticsButtonActivated", "ButtonActivated"),
	InGameAbuseReport = game:DefineFastString("ReportAnalyticsInGameAbuseReport", "InGameAbuseReport")
}

ReportAbuseAnalytics.SessionConstants = {
	StructuralIdentifier = { Level1 = "level1", AbuseReport = "AbuseReport" },
	Metadata = { EntryPoint = "entryPoint", DeleteOnGameLeave = "_deleteOnGameLeave" }
}

local _ = { SUBMIT = 1, ABANDON = 2 }

function ReportAbuseAnalytics.new(eventStreamImpl, diagImpl, context)
	assert(context, "Base context needs to be provided to ReportAbuseAnalytics")

	local v = { _eventStreamImpl = eventStreamImpl, _diagImpl = diagImpl, _context = context }

	setmetatable(v, ReportAbuseAnalytics)

	return v
end

function ReportAbuseAnalytics:reportFormSubmitted(timeToComplete, methodOfAbuse, options)
	local v = self._context .. "_" .. ReportAbuseAnalytics.DiagCounters.SuccessfulSubmissionTime
	local v2 = self._context .. "_" .. ReportAbuseAnalytics.DiagCounters.SubmittedMethodOfAbuse .. "_" .. methodOfAbuse

	local joined = Cryo.Dictionary.join(options or {}, {
		timeToComplete = timeToComplete,
		methodOfAbuse = methodOfAbuse
	})

	self._diagImpl:reportStats(v, timeToComplete)
	self._diagImpl:reportCounter(v2, 1)

	self._eventStreamImpl:sendEventDeferred(self._context, ReportAbuseAnalytics.ActionNames.FormSubmitted, joined)
end

function ReportAbuseAnalytics:reportFormAbandoned(timeToExit, options)
	local v = self._context .. "_" .. ReportAbuseAnalytics.DiagCounters.AbandonedSubmissionTime

	local joined = Cryo.Dictionary.join(options or {}, { timeToExit = timeToExit })

	self._diagImpl:reportStats(v, timeToExit)
	self._eventStreamImpl:sendEventDeferred(self._context, ReportAbuseAnalytics.ActionNames.FormAbandoned, joined)
end

function ReportAbuseAnalytics:reportAnalyticsFieldChanged(options)
	self._eventStreamImpl:sendEventDeferred(self._context, ReportAbuseAnalytics.ActionNames.FieldChanged, options or {})
end

function ReportAbuseAnalytics:reportButtonClick(options)
	self._eventStreamImpl:sendEventDeferred(
		self._context,
		ReportAbuseAnalytics.ActionNames.ButtonActivated,
		options or {}
	)
end

function ReportAbuseAnalytics:reportInGameAbuseReportInteraction(data)
	local v = data.interactionType == 1
	local v2 = ReportAbuseAnalytics.DiagCounters.AbandonedSubmissionTime

	if v then
		v2 = ReportAbuseAnalytics.DiagCounters.SuccessfulSubmissionTime

		local v3 = self._context .. "_" .. ReportAbuseAnalytics.DiagCounters.SubmittedMethodOfAbuse .. "_" .. data.inferredTypeofabuseSelection

		self._diagImpl:reportCounter(v3, 1)
	end

	local v3 = self._context .. "_" .. v2
	self._diagImpl:reportStats(v3, data.timeSpentMs)

	self._eventStreamImpl:sendEventDeferred(self._context, ReportAbuseAnalytics.ActionNames.InGameAbuseReport, data)
end

function ReportAbuseAnalytics:reportEventAndIncrement(p, options)
	self._diagImpl:reportCounter(self._context .. "_" .. p, 1)
	self._eventStreamImpl:sendEventDeferred(self._context, p, options or {})
end

function ReportAbuseAnalytics.startAbuseReportSession(_, p)
	if not SessionService:SessionExists(ReportAbuseAnalytics.SessionConstants.StructuralIdentifier.AbuseReport) then
		SessionService:SetSession(
			ReportAbuseAnalytics.SessionConstants.StructuralIdentifier.Level1,
			ReportAbuseAnalytics.SessionConstants.StructuralIdentifier.AbuseReport,
			ReportAbuseAnalytics.SessionConstants.StructuralIdentifier.AbuseReport
		)
	end

	if not SessionService:GetMetadata(
		ReportAbuseAnalytics.SessionConstants.StructuralIdentifier.AbuseReport,
		ReportAbuseAnalytics.SessionConstants.Metadata.EntryPoint
	) then
		SessionService:SetMetadata(
			ReportAbuseAnalytics.SessionConstants.StructuralIdentifier.AbuseReport,
			ReportAbuseAnalytics.SessionConstants.Metadata.EntryPoint,
			p
		)
	end

	SessionService:SetMetadata(
		ReportAbuseAnalytics.SessionConstants.StructuralIdentifier.AbuseReport,
		ReportAbuseAnalytics.SessionConstants.Metadata.DeleteOnGameLeave,
		"True"
	)
end

function ReportAbuseAnalytics.getAbuseReportSessionEntryPoint(_)
	if SessionService:SessionExists(ReportAbuseAnalytics.SessionConstants.StructuralIdentifier.AbuseReport) then
		return (SessionService:GetMetadata(
			ReportAbuseAnalytics.SessionConstants.StructuralIdentifier.AbuseReport,
			ReportAbuseAnalytics.SessionConstants.Metadata.EntryPoint
		))
	end

	return ""
end

function ReportAbuseAnalytics.endAbuseReportSession(_)
	if SessionService:SessionExists(ReportAbuseAnalytics.SessionConstants.StructuralIdentifier.AbuseReport) then
		SessionService:RemoveSession(ReportAbuseAnalytics.SessionConstants.StructuralIdentifier.AbuseReport)
	end
end

return ReportAbuseAnalytics
