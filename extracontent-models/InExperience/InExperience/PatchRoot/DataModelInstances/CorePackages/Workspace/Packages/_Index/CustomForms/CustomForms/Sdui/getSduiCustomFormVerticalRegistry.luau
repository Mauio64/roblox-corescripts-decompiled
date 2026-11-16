local function createSduiCustomFormVerticalRegistry()
	local v = {}

	return {
		getVertical = function(p: string)
			return v[p]
		end,
		registerVertical = function(p: string, p2)
			v[p] = p2
		end,
		debug_clear = function()
			table.clear(v)
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
