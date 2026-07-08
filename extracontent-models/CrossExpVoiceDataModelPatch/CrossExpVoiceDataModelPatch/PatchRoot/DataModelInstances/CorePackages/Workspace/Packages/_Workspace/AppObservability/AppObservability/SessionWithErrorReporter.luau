local TelemetryService = game:GetService("TelemetryService")
local t1 = {}

t1.__index = t1

function t1.new(p1, n1: number?) -- line: 43
	-- upvalues: t1 (copy)
	local v5 = setmetatable({
		_eventConfig = p1,
		_lastReportedTimestampBySeverity = {},
		_reportingInterval = n1 or 300,
		_lastReportedEventBySeverity = {}
	}, t1)

	v5._lastReportedTimestampBySeverity.NO_SEVERITY = nil
	v5._lastReportedEventBySeverity.NO_SEVERITY = nil

	return v5
end
function t1.getCurrentTimeStamp(_) -- line: 67
	return os.time()
end
function t1.reportEvent(p3, n2: number, p4, s1: string?) -- line: 80
	-- upvalues: TelemetryService (copy)
	local v11 = false
	local v12 = p3:getCurrentTimeStamp()
	local v13 = s1 or "NO_SEVERITY"
	local v14 = p3._lastReportedTimestampBySeverity[v13]

	if v14 == nil or v12 - v14 >= p3._reportingInterval then
		v11 = true
	end

	if v11 then
		if s1 ~= nil then
			if p4 == nil then
				p4 = {
					tag_severity = s1
				}
			elseif type(p4) == "table" then
				p4.tag_severity = s1
			end
		end

		TelemetryService:LogCounter(p3._eventConfig, {
			customFields = p4
		}, n2 or 1)
		p3._lastReportedTimestampBySeverity[v13] = v12
		p3._lastReportedEventBySeverity[v13] = {
			count = n2,
			customFields = p4
		}
	end
end

return t1
