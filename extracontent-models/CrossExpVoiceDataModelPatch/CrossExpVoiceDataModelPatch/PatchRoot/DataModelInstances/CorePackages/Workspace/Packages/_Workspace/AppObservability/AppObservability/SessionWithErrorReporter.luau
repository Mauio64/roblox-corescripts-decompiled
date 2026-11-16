local TelemetryService = game:GetService("TelemetryService")

local SessionWithErrorReporter = {}
SessionWithErrorReporter.__index = SessionWithErrorReporter

function SessionWithErrorReporter.new(eventConfig, value: number?)
	local self = setmetatable({
		_eventConfig = eventConfig,
		_lastReportedTimestampBySeverity = {},
		_reportingInterval = value or 300,
		_lastReportedEventBySeverity = {}
	}, SessionWithErrorReporter)

	self._lastReportedTimestampBySeverity.NO_SEVERITY = nil
	self._lastReportedEventBySeverity.NO_SEVERITY = nil

	return self
end

function SessionWithErrorReporter:getCurrentTimeStamp()
	return os.time()
end

function SessionWithErrorReporter:reportEvent(count: number, customFields, tag_severity: string?)
	local currentTimeStamp = self:getCurrentTimeStamp()
	local v = tag_severity or "NO_SEVERITY"

	local v2 = self._lastReportedTimestampBySeverity[v]

	if v2 == nil or currentTimeStamp - v2 >= self._reportingInterval then
		if tag_severity ~= nil then
			if customFields == nil then
				customFields = { tag_severity = tag_severity }
			elseif type(customFields) == "table" then
				customFields.tag_severity = tag_severity
			end
		end

		TelemetryService:LogCounter(self._eventConfig, { customFields = customFields }, count or 1)

		self._lastReportedTimestampBySeverity[v] = currentTimeStamp
		self._lastReportedEventBySeverity[v] = { count = count, customFields = customFields }
	end
end

return SessionWithErrorReporter
