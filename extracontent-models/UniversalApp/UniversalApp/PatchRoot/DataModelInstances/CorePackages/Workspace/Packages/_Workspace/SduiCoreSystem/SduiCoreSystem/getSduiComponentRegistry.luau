local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent

require(SduiCoreSystemParent.React)
require(SduiCoreSystem.SduiComponentType)
require(SduiCoreSystem.SduiBuilderTypes)

local function createSduiComponentRegistry() -- line: 27
	local t1 = {}

	return {
		getComponent = function(p1) -- line: 42
			-- upvalues: t1 (copy)
			local v10 = t1[p1]

			if not v10 then
				v10 = nil
			elseif not v10.component and v10.getLazyComponent then
				v10.component = v10.getLazyComponent()
			end

			if not v10 then
				return nil
			end

			return v10.component
		end,
		getComponentDefinition = function(p2) -- line: 30
			-- upvalues: t1 (copy)
			local v8 = t1[p2]

			if not v8 then
				return nil
			end

			if not v8.component and v8.getLazyComponent then
				v8.component = v8.getLazyComponent()
			end

			return v8
		end,
		registerComponentDefinition = function(p3, p4) -- line: 52
			-- upvalues: t1 (copy)
			t1[p3] = p4
		end,
		registerComponentDefinitions = function(t2: {[any]: any}) -- line: 59
			-- upvalues: t1 (copy)
			for v14, v15 in t2 do
				t1[v14] = v15
			end
		end
	}
end

local u4 = nil

local function getSduiComponentRegistry() -- line: 76
	-- upvalues: u4 (ref), createSduiComponentRegistry (copy)
	if u4 == nil then
		u4 = createSduiComponentRegistry()
	end

	return u4
end

return getSduiComponentRegistry
