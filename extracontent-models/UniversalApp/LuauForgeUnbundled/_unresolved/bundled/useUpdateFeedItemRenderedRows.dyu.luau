local module = require("@luauforge/bundled/dva")
local useSelector = require("@luauforge/bundled/dvx").Hooks.RoactRodux.useSelector
local useDispatch = require("@luauforge/bundled/dvx").Hooks.RoactRodux.useDispatch
local module2 = require("@luauforge/bundled/dtG")
require("@luauforge/bundled/dtp")

local module3 = require("@luauforge/bundled/dyt")
local module4 = require("@luauforge/bundled/dyn")

local function useUpdateFeedItemRenderedRows(p2, p3, p4, p5)
	local v5 = useDispatch()
	local v6 = useSelector(function(p6)
		local v7 = p6.Personalization.OrderedOmniItems[p2] or {}

		local v8 = p3 and (v7[p3] or {}) or v7

		return v8.allItems and v8.allItems[p4] or nil
	end)

	module.useEffect(function()
		module2.assert(
			v6,
			`Trying to update the number of rows for a feed item but could not find it.  At position: {p4}, Page: {p2} (optional key: {p3})`
		)

		if not v6 then
			return function() end
		end

		v5(module3(p2, p3, p4, v6, p5))

		return function()
			v5(module4(p2, p3, p4, v6))
		end
	end, { p2, p3, p4, v6, p5 })
end

return useUpdateFeedItemRenderedRows
