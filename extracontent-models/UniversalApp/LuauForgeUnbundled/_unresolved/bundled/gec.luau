local module = require("@luauforge/bundled/ged")
local module2 = require("@luauforge/bundled/gee")
local module3 = require("@luauforge/bundled/gef")

local function createDefaultDetails()
	return {}
end

return module.createComputed(function()
	local sessionScopedSignal, v5 = module2.createSessionScopedSignal(createDefaultDetails)

	return {
		getHasBlur = module.createComputed(function(p2): boolean
			return next(sessionScopedSignal(p2)) ~= nil
		end),
		getBlurDisplayOrder = module.createComputed(function(p2)
			local maxValue = 0

			for k, v6 in sessionScopedSignal(p2) do
				maxValue = math.max(maxValue, v6)
			end

			return maxValue
		end),
		setScreenGuiBlur = function(p2, p3, p4)
			v5(function(p5)
				local join = module3.Dictionary.join
				local v8 = if p3 == true then p4 else module3.None
				return join(p5, { [p2] = v8 })
			end)
		end,
		reset = function()
			v5({})
		end
	}
end)
