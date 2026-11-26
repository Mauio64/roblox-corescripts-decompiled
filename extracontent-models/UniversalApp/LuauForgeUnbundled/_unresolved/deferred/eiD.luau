local module = require("@luauforge/deferred/eil")
local module2 = require("@luauforge/deferred/eiE")
local shallowEqual = require("@luauforge/deferred/eim").shallowEqual

local module3 = require("@luauforge/deferred/eiv")
local module4 = require("@luauforge/deferred/eiF")

local module5 = require("@luauforge/deferred/eiH")

return function(current)
	local v5 = module.useMemo(function()
		return module3({ infoForAllEvents = {} }).fireAnalyticsEvent
	end, {})

	if module5 then
		local ref = module.useRef(current)

		if not shallowEqual(ref.current, current) then
			ref.current = current
		end

		current = ref.current
	end

	local function fn(p2, options)
		local v6 = { recommendationSessionId = module4.getPymkSessionId() }
		return v5(p2, module2.Dictionary.join(options or {}, current or {}, v6))
	end

	return module.useCallback(fn, { current, if module5 then v5 else nil })
end
