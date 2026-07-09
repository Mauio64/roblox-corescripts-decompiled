local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")

require(SduiCoreSystem.SduiImpressionEventType)
require(SduiCoreSystem.SduiBuilderTypes)

local function createSduiImpressionHandlerRegistry() -- line: 32
	local t1 = {}

	return {
		getImpressionHandlerConfig = function(p1) -- line: 36
			-- upvalues: t1 (copy)
			local v7 = t1[p1]

			if v7 and (not v7.handler and v7.lazyHandler) then
				v7.handler = v7.lazyHandler()
			end

			return v7
		end,
		registerImpressionHandlerConfig = function(p2, p3) -- line: 48
			-- upvalues: t1 (copy)
			t1[p2] = p3
		end,
		registerImpressionHandlerConfigs = function(t2: {[any]: any}) -- line: 55
			-- upvalues: t1 (copy)
			for v11, v12 in t2 do
				t1[v11] = v12
			end
		end,
		debug_clear = function() -- line: 63
			-- upvalues: t1 (copy)
			table.clear(t1)
		end,
		debug_getRegisteredImpressionHandlerConfigs = function() -- line: 67
			-- upvalues: t1 (copy)
			return t1
		end
	}
end

local u3 = nil

local function getSduiImpressionHandlerRegistry() -- line: 85
	-- upvalues: u3 (ref), createSduiImpressionHandlerRegistry (copy)
	if u3 == nil then
		u3 = createSduiImpressionHandlerRegistry()
	end

	return u3
end

return getSduiImpressionHandlerRegistry
