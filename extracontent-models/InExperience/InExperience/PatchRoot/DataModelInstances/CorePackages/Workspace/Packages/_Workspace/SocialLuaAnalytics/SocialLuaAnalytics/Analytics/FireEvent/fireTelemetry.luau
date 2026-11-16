local SocialLuaAnalytics = script:FindFirstAncestor("SocialLuaAnalytics")
local parent = SocialLuaAnalytics.Parent
local Cryo = require(parent.Cryo)
local Dash = require(parent.Dash)
local SupportedTelemetryBackends = require(SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends)

require(SocialLuaAnalytics.Analytics.Enums.Contexts)
require(script.Parent.Parent.Types)

local defaultTelemetryService = nil
local function getDefaultTelemetryService() -- 1 equivalent call inferred from this helper
	if defaultTelemetryService == nil then
		local TelemetryService = game:GetService("TelemetryService")
		defaultTelemetryService = TelemetryService
	end

	return defaultTelemetryService
end

return function(data)
	return function(p, p2, options, p3)
		local defaults = data.eventList.defaults
		local event = data.eventList[p]
		local shouldUseTelemetryService = data.shouldUseTelemetryService == true
		local telemetryPipeline = shouldUseTelemetryService and "TelemetryService" or "LoggingProtocol"
		local loggerImpl = data.loggerImpl

		local function fn(p4, value, options2, ctx)
			if loggerImpl then
				local v = (type(value) == "string" or type(value) == "number") and { value = value } or value

				local joined = Cryo.Dictionary.join(p4, v or {}, options2 or {})

				if ctx then
					joined.ctx = ctx
				end

				joined.telemetryPipeline = telemetryPipeline

				loggerImpl:info(Dash.pretty(joined))
			end
		end

		local v

		if shouldUseTelemetryService then
			v = data.telemetryServiceImpl or getDefaultTelemetryService() -- inferred equivalent call
		end

		for _, backend in event.backendsList do
			local incrementValue = backend.incrementValue or 1
			local eventName

			if backend.overrideName then
				eventName = backend.overrideName(p2)
			else
				eventName = p
			end

			local throttlingThousandths = backend.throttlingThousandths
				or event.throttlingThousandths
				or defaults.throttlingThousandths

			local v2 = {
				eventName = eventName,
				backends = { backend.type },
				throttlingPercentage = math.clamp(throttlingThousandths, 0, 10000),
				lastUpdated = event.lastUpdated,
				description = event.description,
				links = event.links or defaults.links
			}

			local customFields = {}

			if data.getInfoForAllEvents then
				local infoForAllEvents = data.getInfoForAllEvents()
				customFields = Cryo.Dictionary.join(customFields, infoForAllEvents)
			end

			if backend.format then
				assert(backend.dynamicCustomFields == nil, "Cannot use dynamicCustomFields with format")
				assert(backend.staticCustomFields == nil, "Cannot use staticCustomFields with format")
				customFields = backend.format(p2, options or {})
			else
				if backend.dynamicCustomFields and p2 then
					for k, dynamicCustomField in backend.dynamicCustomFields do
						if p2[k] then
							customFields[k] = dynamicCustomField(p2[k])
						end
					end
				end

				if backend.staticCustomFields then
					customFields = Cryo.Dictionary.join(customFields, backend.staticCustomFields)
				end
			end

			if backend.type == SupportedTelemetryBackends.Points then
				data.telemetryImpl:logRobloxTelemetryEvent(v2, backend.standardizedFields, customFields)
				fn(v2, backend.standardizedFields, customFields)
			elseif backend.type == SupportedTelemetryBackends.RobloxTelemetryStat then
				if p2 and p2.statValue then
					if shouldUseTelemetryService then
						v:LogStat(
							v2,
							{
								standardizedFields = backend.standardizedFields,
								customFields = customFields
							},
							p2.statValue
						)
					else
						data.telemetryImpl:logRobloxTelemetryStat(v2, p2.statValue, customFields)
					end

					fn(v2, p2.statValue, customFields)
				else
					v2.backends = { SupportedTelemetryBackends.RobloxTelemetryCounter }
					v2.eventName = p .. "MissingStatValue"

					if shouldUseTelemetryService then
						v:LogCounter(
							v2,
							{
								standardizedFields = backend.standardizedFields,
								customFields = customFields
							},
							incrementValue
						)
					else
						data.telemetryImpl:logRobloxTelemetryCounter(v2, incrementValue, customFields)
					end

					fn(v2, incrementValue, customFields)
					break
				end
			elseif backend.type == SupportedTelemetryBackends.RobloxTelemetryCounter then
				if shouldUseTelemetryService then
					v:LogCounter(
						v2,
						{
							standardizedFields = backend.standardizedFields,
							customFields = customFields
						},
						incrementValue
					)
				else
					data.telemetryImpl:logRobloxTelemetryCounter(v2, incrementValue, customFields)
				end

				fn(v2, incrementValue, customFields)
			elseif backend.type == SupportedTelemetryBackends.EventIngest then
				if shouldUseTelemetryService then
					v:LogEvent(v2, {
						eventContext = p3 or customFields.eventContext,
						standardizedFields = backend.standardizedFields,
						customFields = customFields
					})
				else
					data.telemetryImpl:logRobloxTelemetryEvent(
						v2,
						backend.standardizedFields,
						customFields,
						p3 or customFields.eventContext
					)
				end

				fn(v2, p2, customFields, p3 or customFields.eventContext)
			end
		end
	end
end
