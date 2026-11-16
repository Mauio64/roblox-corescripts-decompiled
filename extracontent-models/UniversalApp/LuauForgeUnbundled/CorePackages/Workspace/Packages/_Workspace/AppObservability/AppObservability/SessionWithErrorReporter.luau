local TelemetryService = game:GetService("TelemetryService")

local class = {}
class.__index = class

function class.new(p2, value)
	local object = setmetatable({
		_eventConfig = p2,
		_lastReportedTimestampBySeverity = {},
		_reportingInterval = value or 300,
		_lastReportedEventBySeverity = {}
	}, class)

	object._lastReportedTimestampBySeverity.NO_SEVERITY = nil
	object._lastReportedEventBySeverity.NO_SEVERITY = nil

	return object
end

function class:getCurrentTimeStamp()
	return os.time()
end

function class:reportEvent(value, p2, tag_severity)
	local currentTimeStamp = self:getCurrentTimeStamp()
	local v5 = tag_severity or "NO_SEVERITY"

	local v6 = self._lastReportedTimestampBySeverity[v5]

	if v6 == nil or currentTimeStamp - v6 >= self._reportingInterval then
		if tag_severity ~= nil then
			if p2 == nil then
				p2 = { tag_severity = tag_severity }
			elseif type(p2) == "table" then
				p2.tag_severity = tag_severity
			end
		end

		TelemetryService:LogCounter(self._eventConfig, { customFields = p2 }, value or 1)

		self._lastReportedTimestampBySeverity[v5] = currentTimeStamp
		self._lastReportedEventBySeverity[v5] = { count = value, customFields = p2 }
	end
end

return class
