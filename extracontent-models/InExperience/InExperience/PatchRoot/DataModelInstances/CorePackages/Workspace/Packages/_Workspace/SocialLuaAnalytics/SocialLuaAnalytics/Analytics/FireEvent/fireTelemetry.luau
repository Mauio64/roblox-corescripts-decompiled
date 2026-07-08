local SocialLuaAnalytics = script:FindFirstAncestor("SocialLuaAnalytics")
local SocialLuaAnalyticsParent = SocialLuaAnalytics.Parent
local Cryo = require(SocialLuaAnalyticsParent.Cryo)
local Dash = require(SocialLuaAnalyticsParent.Dash)
local SupportedTelemetryBackends = require(SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends)

require(SocialLuaAnalytics.Analytics.Enums.Contexts)
require(script.Parent.Parent.Types)

local TelemetryService = nil

local function getDefaultTelemetryService() -- line: 14
	-- upvalues: TelemetryService (ref)
	if TelemetryService == nil then
		TelemetryService = game:GetService("TelemetryService")
	end

	return TelemetryService
end

return function(t1: {[any]: any}) -- line: 43
	-- upvalues: Cryo (copy), Dash (copy), TelemetryService (ref), SupportedTelemetryBackends (copy)
	return function(p1, p2, t2: {[any]: any}?, p3) -- line: 65
		-- upvalues: t1 (copy), Cryo (copy), Dash (copy), TelemetryService (ref), SupportedTelemetryBackends (copy)
		local defaults = t1.eventList.defaults
		local v22 = t1.eventList[p1]
		local v23 = t1.shouldUseTelemetryService == true
		local v24 = not v23 and "LoggingProtocol" or "TelemetryService"
		local loggerImpl = t1.loggerImpl

		local function v26(p4, p5, p6, p7) -- line: 22
			-- upvalues: loggerImpl (copy), Cryo (copy), v24 (copy), Dash (copy)
			if loggerImpl then
				local v42 = if type(p5) ~= "string" and type(p5) ~= "number" then p5 else {
					value = p5
				}
				local v43 = Cryo.Dictionary.join(p4, v42 or {}, p6 or {})

				if p7 then
					v43.ctx = p7
				end

				v43.telemetryPipeline = v24
				loggerImpl:info(Dash.pretty(v43))
			end
		end

		local telemetryServiceImpl

		if v23 then
			telemetryServiceImpl = t1.telemetryServiceImpl

			if not telemetryServiceImpl then
				if TelemetryService == nil then
					TelemetryService = game:GetService("TelemetryService")
				end

				telemetryServiceImpl = TelemetryService
			end
		else
			telemetryServiceImpl = nil
		end

		for _, v29 in v22.backendsList do
			local v30 = v29.incrementValue or 1
			local v31 = if not v29.overrideName then p1 else v29.overrideName(p2)
			local v32 = v29.throttlingThousandths or (v22.throttlingThousandths or defaults.throttlingThousandths)
			local t3 = {
				eventName = v31,
				backends = { v29.type },
				throttlingPercentage = math.clamp(v32, 0, 10000),
				lastUpdated = v22.lastUpdated,
				description = v22.description,
				links = v22.links or defaults.links
			}
			local t4 = {}

			if t1.getInfoForAllEvents then
				local v35 = t1.getInfoForAllEvents()

				t4 = Cryo.Dictionary.join(t4, v35)
			end

			if v29.format then
				assert(v29.dynamicCustomFields == nil, "Cannot use dynamicCustomFields with format")
				assert(v29.staticCustomFields == nil, "Cannot use staticCustomFields with format")
				t4 = v29.format(p2, t2 or {})
			else
				if v29.dynamicCustomFields and p2 then
					for v36, v37 in v29.dynamicCustomFields do
						if p2[v36] then
							t4[v36] = v37(p2[v36])
						end
					end
				end

				if v29.staticCustomFields then
					t4 = Cryo.Dictionary.join(t4, v29.staticCustomFields)
				end
			end

			if v29.type ~= SupportedTelemetryBackends.Points then
				if v29.type ~= SupportedTelemetryBackends.RobloxTelemetryStat then
					if v29.type == SupportedTelemetryBackends.RobloxTelemetryCounter then
						if v23 then
							telemetryServiceImpl:LogCounter(t3, {
								standardizedFields = v29.standardizedFields,
								customFields = t4
							}, v30)
						else
							t1.telemetryImpl:logRobloxTelemetryCounter(t3, v30, t4)
						end

						v26(t3, v30, t4)
					elseif v29.type == SupportedTelemetryBackends.EventIngest then
						if v23 then
							telemetryServiceImpl:LogEvent(t3, {
								eventContext = p3 or t4.eventContext,
								standardizedFields = v29.standardizedFields,
								customFields = t4
							})
						else
							t1.telemetryImpl:logRobloxTelemetryEvent(t3, v29.standardizedFields, t4, p3 or t4.eventContext)
						end

						v26(t3, p2, t4, p3 or t4.eventContext)
					end

					continue
				end

				if not p2 or not p2.statValue then
					t3.backends = { SupportedTelemetryBackends.RobloxTelemetryCounter }
					t3.eventName = p1 .. "MissingStatValue"

					if v23 then
						telemetryServiceImpl:LogCounter(t3, {
							standardizedFields = v29.standardizedFields,
							customFields = t4
						}, v30)
					else
						t1.telemetryImpl:logRobloxTelemetryCounter(t3, v30, t4)
					end

					v26(t3, v30, t4)

					return
				end

				if v23 then
					telemetryServiceImpl:LogStat(t3, {
						standardizedFields = v29.standardizedFields,
						customFields = t4
					}, p2.statValue)
				else
					t1.telemetryImpl:logRobloxTelemetryStat(t3, p2.statValue, t4)
				end

				v26(t3, p2.statValue, t4)

				continue
			end

			t1.telemetryImpl:logRobloxTelemetryEvent(t3, v29.standardizedFields, t4)
			v26(t3, v29.standardizedFields, t4)
		end
	end
end
