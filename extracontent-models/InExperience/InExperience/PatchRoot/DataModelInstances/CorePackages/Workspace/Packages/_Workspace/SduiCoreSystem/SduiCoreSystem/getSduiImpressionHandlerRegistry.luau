local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")

require(SduiCoreSystem.SduiImpressionEventType)
require(SduiCoreSystem.SduiBuilderTypes)

local function createSduiImpressionHandlerRegistry()
	local v = {}

	local function registerImpressionHandlerConfig(k, item) -- 1 equivalent call inferred from this helper
		v[k] = item
	end

	return {
		getImpressionHandlerConfig = function(p)
			local impressionHandlerConfig = v[p]

			if
				impressionHandlerConfig
				and not impressionHandlerConfig.handler
				and impressionHandlerConfig.lazyHandler
			then
				impressionHandlerConfig.handler = impressionHandlerConfig.lazyHandler()
			end

			return impressionHandlerConfig
		end,
		registerImpressionHandlerConfig = registerImpressionHandlerConfig,
		registerImpressionHandlerConfigs = function(items)
			for k, item in items do
				registerImpressionHandlerConfig(k, item) -- inferred equivalent call
			end
		end,
		debug_clear = function()
			table.clear(v)
		end,
		debug_getRegisteredImpressionHandlerConfigs = function()
			return v
		end
	}
end

local sduiImpressionHandlerRegistry = nil
local function getSduiImpressionHandlerRegistry()
	if sduiImpressionHandlerRegistry == nil then
		sduiImpressionHandlerRegistry = createSduiImpressionHandlerRegistry()
	end

	return sduiImpressionHandlerRegistry
end

return getSduiImpressionHandlerRegistry
