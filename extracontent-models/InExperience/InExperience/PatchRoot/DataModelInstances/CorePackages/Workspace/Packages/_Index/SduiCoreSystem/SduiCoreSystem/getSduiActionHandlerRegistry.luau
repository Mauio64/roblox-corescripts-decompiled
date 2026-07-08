local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent

require(SduiCoreSystem.SduiActionType)
require(SduiCoreSystem.SduiBuilderTypes)

local FFlagSduiActionTelemetryHandler = require(SduiCoreSystemParent.SharedFlags).FFlagSduiActionTelemetryHandler

local function createSduiActionHandlerRegistry() -- line: 33
	-- upvalues: FFlagSduiActionTelemetryHandler (copy)
	local t1 = {}

	return {
		getActionHandlerConfig = function(p1) -- line: 36
			-- upvalues: t1 (copy), FFlagSduiActionTelemetryHandler (copy)
			local v9 = t1[p1]

			if v9 and (not v9.handler and v9.lazyHandler) then
				v9.handler = v9.lazyHandler()
			end

			if FFlagSduiActionTelemetryHandler and v9 and not v9.telemetryHandler then
				local lazyTelemetryHandler = v9.lazyTelemetryHandler

				if lazyTelemetryHandler then
					v9.telemetryHandler = lazyTelemetryHandler()
				end
			end

			return v9
		end,
		registerActionHandlerConfig = function(p2, p3) -- line: 54
			-- upvalues: t1 (copy)
			t1[p2] = p3
		end,
		registerActionHandlerConfigs = function(t2: {[any]: any}) -- line: 61
			-- upvalues: t1 (copy)
			for v14, v15 in t2 do
				t1[v14] = v15
			end
		end,
		debug_clear = function() -- line: 69
			-- upvalues: t1 (copy)
			table.clear(t1)
		end,
		debug_getRegisteredActionHandlerConfigs = function() -- line: 73
			-- upvalues: t1 (copy)
			return t1
		end
	}
end

local u5 = nil

local function getSduiActionHandlerRegistry() -- line: 91
	-- upvalues: u5 (ref), createSduiActionHandlerRegistry (copy)
	if u5 == nil then
		u5 = createSduiActionHandlerRegistry()
	end

	return u5
end

return getSduiActionHandlerRegistry
