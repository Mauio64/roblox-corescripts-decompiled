local module = require("@luauforge/bundled/dva")
local module2 = require("@luauforge/bundled/dtq")
local safetyResourceBannerAction = module2.Constants.SafetyResourceBannerAction

local function useSafetyResourceBannerTelemetry(data, p2)
	local ref = module.useRef(false)

	local v5 = module.useCallback(function(p3)
		if data == nil or p2 == nil then
			return
		end

		module2.Events.sendSafetyResourceBannerEvent({
			action = p3,
			moderationCategory = data.moderationCategory,
			textFilterRequestId = data.textFilterRequestId,
			surface = data.surface,
			url = p2
		})
	end, { data, p2 })

	local v6 = module.useCallback(function(p3): boolean
		if ref.current then
			return false
		end

		ref.current = true
		return true
	end, {})

	return {
		sendEvent = v5,
		onImpressed = module.useCallback(function()
			v5(safetyResourceBannerAction.Impression)
		end, { v5 }),
		filterImpressionFunc = v6
	}
end

return useSafetyResourceBannerTelemetry
