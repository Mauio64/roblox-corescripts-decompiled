local module = require("@luauforge/deferred/eil")
local module2 = require("@luauforge/deferred/eiE")

local function useConnectionChannelsVisibility(p2)
	local state, setState = module.useState({})

	return module.useCallback(function(p3, p4)
		setState(function(p5)
			if p5[p3] == p4 then
				return p5
			end

			return module2.Dictionary.join(p5, { [p3] = p4 })
		end)
	end, {}), (module.useMemo(function(): boolean
		local count = 0
		local v5 = false

		for k, v6 in state do
			count += 1

			if v6 == true then
				v5 = true
			end
		end

		return p2 <= count and not v5
	end, { state, p2 }))
end

return useConnectionChannelsVisibility
