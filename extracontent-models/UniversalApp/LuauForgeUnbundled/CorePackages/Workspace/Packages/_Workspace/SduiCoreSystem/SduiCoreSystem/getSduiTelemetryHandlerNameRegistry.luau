require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")

local function createSduiTelemetryHandlerNameRegistry()
	local result = {}

	return {
		getTelemetryHandler = function(p2)
			local v5 = result[p2]

			if v5 == nil then
				return nil
			end

			if not v5.handler and v5.lazyHandler then
				v5.handler = v5.lazyHandler()
			end

			return v5.handler
		end,
		registerTelemetryHandler = function(p2, p3)
			result[p2] = p3
		end,
		registerTelemetryHandlers = function(items)
			for k, item in items do
				result[k] = item
			end
		end,
		debug_clear = function()
			table.clear(result)
		end,
		debug_getRegisteredConfigs = function()
			return result
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
