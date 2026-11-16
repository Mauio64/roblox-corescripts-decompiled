local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
require(parent.React)

require(SduiCoreSystem.SduiComponentType)
require(SduiCoreSystem.SduiBuilderTypes)

local function createSduiComponentRegistry()
	local v = {}

	local function getComponentDefinition(p) -- 1 equivalent call inferred from this helper
		local v2 = v[p]

		if not v2 then
			return nil
		end

		if not v2.component and v2.getLazyComponent then
			v2.component = v2.getLazyComponent()
		end

		return v2
	end

	local function registerComponentDefinition(k, item) -- 1 equivalent call inferred from this helper
		v[k] = item
	end

	return {
		getComponent = function(p)
			local componentDefinition = getComponentDefinition(p) -- inferred equivalent call

			if componentDefinition then
				return componentDefinition.component
			end

			return nil
		end,
		getComponentDefinition = getComponentDefinition,
		registerComponentDefinition = registerComponentDefinition,
		registerComponentDefinitions = function(items)
			for k, item in items do
				registerComponentDefinition(k, item) -- inferred equivalent call
			end
		end,
		getRegisteredComponentTypes = function()
			local registeredComponentTypes = {}

			for k in v do
				table.insert(registeredComponentTypes, k)
			end

			table.sort(registeredComponentTypes)
			return registeredComponentTypes
		end
	}
end

local sduiComponentRegistry = nil
local function getSduiComponentRegistry()
	if sduiComponentRegistry == nil then
		sduiComponentRegistry = createSduiComponentRegistry()
	end

	return sduiComponentRegistry
end

return getSduiComponentRegistry
