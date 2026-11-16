require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiImpressionEventType")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")

local function createSduiImpressionHandlerRegistry()
	local result = {}

	return {
		getImpressionHandlerConfig = function(p2)
			local impressionHandlerConfig = result[p2]

			if
				impressionHandlerConfig
				and not impressionHandlerConfig.handler
				and impressionHandlerConfig.lazyHandler
			then
				impressionHandlerConfig.handler = impressionHandlerConfig.lazyHandler()
			end

			return impressionHandlerConfig
		end,
		registerImpressionHandlerConfig = function(p2, p3)
			result[p2] = p3
		end,
		registerImpressionHandlerConfigs = function(items)
			for k, item in items do
				result[k] = item
			end
		end,
		debug_clear = function()
			table.clear(result)
		end,
		debug_getRegisteredImpressionHandlerConfigs = function()
			return result
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
