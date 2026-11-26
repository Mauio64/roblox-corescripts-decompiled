local module = require("@luauforge/bundled/dva")
local module2 = require("@luauforge/bundled/dvx")
local useDispatch = module2.Hooks.RoactRodux.useDispatch
local useSelector = module2.Hooks.RoactRodux.useSelector

local fFlagLuaAppEnableOneByTwoTileFunnelTelemetry = require("@luauforge/bundled/dtD").FFlagLuaAppEnableOneByTwoTileFunnelTelemetry

local module3 = require("@luauforge/bundled/dyr")

local module4 = require("@luauforge/bundled/dyo")

local function useGridFlexFeedItemBounds(p2, p3, p4, p5, p6, p7)
	local v5 = useDispatch()

	local v6 = useSelector(function(p8)
		return ((p8.Personalization.GameGridFlexFeedItemBounds[p2] or {}).flexItemsBounds or {})[p3]
	end)

	local function fn()
		if p4 and p4 > 0 then
			v5(module3(p2, p3, p5, p4, p6, if fFlagLuaAppEnableOneByTwoTileFunnelTelemetry then p7 else nil))
		end

		return function()
			if p4 and p4 > 0 then
				v5(module4(p2, p3, p4, p6))
			end
		end
	end

	module.useEffect(fn, {
		p2,
		p3,
		p4,
		p5,
		p6,
		if fFlagLuaAppEnableOneByTwoTileFunnelTelemetry then p7 else nil
	})

	return v6
end

return useGridFlexFeedItemBounds
