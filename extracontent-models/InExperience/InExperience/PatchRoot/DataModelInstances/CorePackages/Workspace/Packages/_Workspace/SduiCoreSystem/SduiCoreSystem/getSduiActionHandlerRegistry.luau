local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")

require(SduiCoreSystem.SduiActionType)
require(SduiCoreSystem.SduiBuilderTypes)

local function createSduiActionHandlerRegistry()
	local v = {}

	local function registerActionHandlerConfig(k, item) -- 1 equivalent call inferred from this helper
		v[k] = item
	end

	return {
		getActionHandlerConfig = function(p)
			local actionHandlerConfig = v[p]

			if actionHandlerConfig and not actionHandlerConfig.handler and actionHandlerConfig.lazyHandler then
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
		registerActionHandlerConfig = registerActionHandlerConfig,
		registerActionHandlerConfigs = function(items)
			for k, item in items do
				registerActionHandlerConfig(k, item) -- inferred equivalent call
			end
		end,
		getRegisteredActionTypes = function()
			local registeredActionTypes = {}

			for k in v do
				table.insert(registeredActionTypes, k)
			end

			table.sort(registeredActionTypes)
			return registeredActionTypes
		end,
		debug_clear = function()
			table.clear(v)
		end,
		debug_getRegisteredActionHandlerConfigs = function()
			return v
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
