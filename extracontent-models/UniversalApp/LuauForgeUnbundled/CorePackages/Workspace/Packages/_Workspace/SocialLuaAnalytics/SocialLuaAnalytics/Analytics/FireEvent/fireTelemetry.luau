local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/Cryo")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/Dash")
local SupportedTelemetryBackends = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Enums/SupportedTelemetryBackends")

require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Enums/Contexts")
require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Types")

local defaultTelemetryService = nil
local function getDefaultTelemetryService()
	if defaultTelemetryService == nil then
		local TelemetryService = game:GetService("TelemetryService")
		defaultTelemetryService = TelemetryService
	end

	return defaultTelemetryService
end

return function(data)
	return function(p2, p3, options, p4)
		local defaults = data.eventList.defaults
		local event = data.eventList[p2]
		local shouldUseTelemetryService = data.shouldUseTelemetryService == true
		local v5 = shouldUseTelemetryService and "TelemetryService" or "LoggingProtocol"
		local loggerImpl = data.loggerImpl

		local function fn(p5, value, options2, ctx)
			if loggerImpl then
				local v6 = (type(value) == "string" or type(value) == "number") and {
						value = value
					}
					or value

				local joined = Cryo.Dictionary.join(p5, v6 or {}, options2 or {})

				if ctx then
					joined.ctx = ctx
				end

				joined.telemetryPipeline = v5

				loggerImpl:info(Dash.pretty(joined))
			end
		end

		local v6

		if shouldUseTelemetryService then
			v6 = data.telemetryServiceImpl

			if not v6 then
				if defaultTelemetryService == nil then
					local TelemetryService = game:GetService("TelemetryService")
					defaultTelemetryService = TelemetryService
				end

				v6 = defaultTelemetryService
			end
		end

		for k, backend in event.backendsList do
			local incrementValue = backend.incrementValue or 1

			local v7 = if backend.overrideName then backend.overrideName(p3) else p2

			local throttlingThousandths = backend.throttlingThousandths
				or event.throttlingThousandths
				or defaults.throttlingThousandths

			local v8 = {
				eventName = v7,
				backends = { backend.type },
				throttlingPercentage = math.clamp(throttlingThousandths, 0, 10000),
				lastUpdated = event.lastUpdated,
				description = event.description,
				links = event.links or defaults.links
			}

			local v9 = {}

			if data.getInfoForAllEvents then
				local infoForAllEvents = data.getInfoForAllEvents()
				v9 = Cryo.Dictionary.join(v9, infoForAllEvents)
			end

			if backend.format then
				assert(backend.dynamicCustomFields == nil, "Cannot use dynamicCustomFields with format")
				assert(backend.staticCustomFields == nil, "Cannot use staticCustomFields with format")
				v9 = backend.format(p3, options or {})
			else
				if backend.dynamicCustomFields and p3 then
					for k2, dynamicCustomField in backend.dynamicCustomFields do
						if p3[k2] then
							v9[k2] = dynamicCustomField(p3[k2])
						end
					end
				end

				if backend.staticCustomFields then
					v9 = Cryo.Dictionary.join(v9, backend.staticCustomFields)
				end
			end

			if backend.type == SupportedTelemetryBackends.Points then
				data.telemetryImpl:logRobloxTelemetryEvent(v8, backend.standardizedFields, v9)
				fn(v8, backend.standardizedFields, v9)
			elseif backend.type == SupportedTelemetryBackends.RobloxTelemetryStat then
				if p3 and p3.statValue then
					if shouldUseTelemetryService then
						v6:LogStat(
							v8,
							{
								standardizedFields = backend.standardizedFields,
								customFields = v9
							},
							p3.statValue
						)
					else
						data.telemetryImpl:logRobloxTelemetryStat(v8, p3.statValue, v9)
					end

					fn(v8, p3.statValue, v9)
				else
					v8.backends = { SupportedTelemetryBackends.RobloxTelemetryCounter }
					v8.eventName = p2 .. "MissingStatValue"

					if shouldUseTelemetryService then
						v6:LogCounter(
							v8,
							{
								standardizedFields = backend.standardizedFields,
								customFields = v9
							},
							incrementValue
						)
					else
						data.telemetryImpl:logRobloxTelemetryCounter(v8, incrementValue, v9)
					end

					fn(v8, incrementValue, v9)
					break
				end
			elseif backend.type == SupportedTelemetryBackends.RobloxTelemetryCounter then
				if shouldUseTelemetryService then
					v6:LogCounter(
						v8,
						{
							standardizedFields = backend.standardizedFields,
							customFields = v9
						},
						incrementValue
					)
				else
					data.telemetryImpl:logRobloxTelemetryCounter(v8, incrementValue, v9)
				end

				fn(v8, incrementValue, v9)
			elseif backend.type == SupportedTelemetryBackends.EventIngest then
				if shouldUseTelemetryService then
					v6:LogEvent(v8, {
						eventContext = p4 or v9.eventContext,
						standardizedFields = backend.standardizedFields,
						customFields = v9
					})
				else
					data.telemetryImpl:logRobloxTelemetryEvent(
						v8,
						backend.standardizedFields,
						v9,
						p4 or v9.eventContext
					)
				end

				fn(v8, p3, v9, p4 or v9.eventContext)
			end
		end
	end
end
