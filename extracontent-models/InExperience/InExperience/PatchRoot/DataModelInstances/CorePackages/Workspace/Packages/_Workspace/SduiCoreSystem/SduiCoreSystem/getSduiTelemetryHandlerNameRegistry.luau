local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")

require(SduiCoreSystem.SduiBuilderTypes)

local function createSduiTelemetryHandlerNameRegistry()
	local v = {}

	local function registerTelemetryHandler(k: string, item) -- 1 equivalent call inferred from this helper
		v[k] = item
	end

	return {
		getTelemetryHandler = function(p: string)
			local v2 = v[p]

			if v2 == nil then
				return nil
			end

			if not v2.handler and v2.lazyHandler then
				v2.handler = v2.lazyHandler()
			end

			return v2.handler
		end,
		registerTelemetryHandler = registerTelemetryHandler,
		registerTelemetryHandlers = function(items)
			for k, item in items do
				registerTelemetryHandler(k, item) -- inferred equivalent call
			end
		end,
		debug_clear = function()
			table.clear(v)
		end,
		debug_getRegisteredConfigs = function()
			return v
		end
	}
end

local sduiTelemetryHandlerNameRegistry = nil
local function getSduiTelemetryHandlerNameRegistry()
	if sduiTelemetryHandlerNameRegistry == nil then
		sduiTelemetryHandlerNameRegistry = createSduiTelemetryHandlerNameRegistry()
	end

	return sduiTelemetryHandlerNameRegistry
end

return getSduiTelemetryHandlerNameRegistry
