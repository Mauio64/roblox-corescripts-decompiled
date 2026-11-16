local module = require("@luauforge/bundled/fux")

local createSignal = module.createSignal
local createComputed = module.createComputed

local signal, v6 = createSignal(0)
return {
	["getCount"] = signal,
	getIsDisabled = createComputed(function(p2): boolean
		return signal(p2) > 0
	end),
	setDisabled = function(p2)
		v6(function(p3)
			if p2 then
				return p3 + 1
			end

			return (math.max(p3 - 1, 0))
		end)
	end,
	_resetForTesting = function()
		v6(0)
	end
}
