local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")

require(SduiCoreSystem.SduiBuilderTypes)

local function createSduiTelemetryHandlerNameRegistry() -- line: 23
	local t1 = {}

	return {
		getTelemetryHandler = function(s1: string) -- line: 26
			-- upvalues: t1 (copy)
			local v7 = t1[s1]

			if v7 == nil then
				return nil
			end

			if not v7.handler and v7.lazyHandler then
				v7.handler = v7.lazyHandler()
			end

			return v7.handler
		end,
		registerTelemetryHandler = function(s2: string, t2: {[any]: any}) -- line: 38
			-- upvalues: t1 (copy)
			t1[s2] = t2
		end,
		registerTelemetryHandlers = function(t3: {[any]: any}) -- line: 42
			-- upvalues: t1 (copy)
			for v11, v12 in t3 do
				t1[v11] = v12
			end
		end,
		debug_clear = function() -- line: 48
			-- upvalues: t1 (copy)
			table.clear(t1)
		end,
		debug_getRegisteredConfigs = function() -- line: 52
			-- upvalues: t1 (copy)
			return t1
		end
	}
end

local u3 = nil

local function getSduiTelemetryHandlerNameRegistry() -- line: 67
	-- upvalues: u3 (ref), createSduiTelemetryHandlerNameRegistry (copy)
	if u3 == nil then
		u3 = createSduiTelemetryHandlerNameRegistry()
	end

	return u3
end

return getSduiTelemetryHandlerNameRegistry
