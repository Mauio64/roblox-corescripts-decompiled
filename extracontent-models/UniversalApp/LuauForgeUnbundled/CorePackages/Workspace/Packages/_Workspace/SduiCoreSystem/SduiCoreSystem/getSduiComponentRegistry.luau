require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiComponentType")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")

local function createSduiComponentRegistry()
	local v5 = {}

	return {
		getComponent = function(p2)
			local v6 = v5[p2]

			if v6 then
				if not v6.component and v6.getLazyComponent then
					v6.component = v6.getLazyComponent()
				end
			else
				v6 = nil
			end

			if v6 then
				return v6.component
			end

			return nil
		end,
		getComponentDefinition = function(p2)
			local v6 = v5[p2]

			if not v6 then
				return nil
			end

			if not v6.component and v6.getLazyComponent then
				v6.component = v6.getLazyComponent()
			end

			return v6
		end,
		registerComponentDefinition = function(p2, p3)
			v5[p2] = p3
		end,
		registerComponentDefinitions = function(items)
			for k, item in items do
				v5[k] = item
			end
		end,
		getRegisteredComponentTypes = function()
			local registeredComponentTypes = {}

			for k in v5 do
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
