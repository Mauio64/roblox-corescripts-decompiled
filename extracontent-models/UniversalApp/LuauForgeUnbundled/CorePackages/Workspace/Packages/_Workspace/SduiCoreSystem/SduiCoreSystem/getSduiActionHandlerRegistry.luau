require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiActionType")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")

local function createSduiActionHandlerRegistry()
	local result = {}

	return {
		getActionHandlerConfig = function(p2)
			local actionHandlerConfig = result[p2]

			if
				actionHandlerConfig
				and not actionHandlerConfig.handler
				and actionHandlerConfig.lazyHandler
			then
				actionHandlerConfig.handler = actionHandlerConfig.lazyHandler()
			end

			local lazyTelemetryHandler = actionHandlerConfig
				and not actionHandlerConfig.telemetryHandler
				and actionHandlerConfig.lazyTelemetryHandler

			if lazyTelemetryHandler then
				actionHandlerConfig.telemetryHandler = lazyTelemetryHandler()
			end

			return actionHandlerConfig
		end,
		registerActionHandlerConfig = function(p2, p3)
			result[p2] = p3
		end,
		registerActionHandlerConfigs = function(items)
			for k, item in items do
				result[k] = item
			end
		end,
		getRegisteredActionTypes = function()
			local registeredActionTypes = {}

			for k in result do
				table.insert(registeredActionTypes, k)
			end

			table.sort(registeredActionTypes)
			return registeredActionTypes
		end,
		debug_clear = function()
			table.clear(result)
		end,
		debug_getRegisteredActionHandlerConfigs = function()
			return result
		end
	}
end

local sduiActionHandlerRegistry = nil
local function getSduiActionHandlerRegistry()
	if sduiActionHandlerRegistry == nil then
		sduiActionHandlerRegistry = createSduiActionHandlerRegistry()
	end

	return sduiActionHandlerRegistry
end

return getSduiActionHandlerRegistry
