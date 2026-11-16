local function createSduiContentReactionVerticalRegistry()
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

local sduiContentReactionVerticalRegistry = nil
local function getSduiContentReactionVerticalRegistry()
	if sduiContentReactionVerticalRegistry == nil then
		sduiContentReactionVerticalRegistry = createSduiContentReactionVerticalRegistry()
	end

	return sduiContentReactionVerticalRegistry
end

return getSduiContentReactionVerticalRegistry
