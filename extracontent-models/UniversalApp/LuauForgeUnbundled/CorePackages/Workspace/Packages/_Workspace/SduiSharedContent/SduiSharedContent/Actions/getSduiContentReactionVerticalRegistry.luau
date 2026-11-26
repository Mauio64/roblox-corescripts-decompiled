local function createSduiContentReactionVerticalRegistry()
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

local sduiContentReactionVerticalRegistry = nil
local function getSduiContentReactionVerticalRegistry()
	if sduiContentReactionVerticalRegistry == nil then
		sduiContentReactionVerticalRegistry = createSduiContentReactionVerticalRegistry()
	end

	return sduiContentReactionVerticalRegistry
end

return getSduiContentReactionVerticalRegistry
