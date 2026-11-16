local function createSduiCustomFormVerticalRegistry()
	local v5 = {}

	return {
		getVertical = function(p2)
			return v5[p2]
		end,
		registerVertical = function(p2, p3)
			v5[p2] = p3
		end,
		debug_clear = function()
			table.clear(v5)
		end
	}
end

local sduiCustomFormVerticalRegistry = nil
local function getSduiCustomFormVerticalRegistry()
	if sduiCustomFormVerticalRegistry == nil then
		sduiCustomFormVerticalRegistry = createSduiCustomFormVerticalRegistry()
	end

	return sduiCustomFormVerticalRegistry
end

return getSduiCustomFormVerticalRegistry
