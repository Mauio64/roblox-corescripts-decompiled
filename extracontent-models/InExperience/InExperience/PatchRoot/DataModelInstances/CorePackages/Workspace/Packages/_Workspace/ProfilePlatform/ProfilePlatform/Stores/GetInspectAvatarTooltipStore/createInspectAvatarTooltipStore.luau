local parent = script:FindFirstAncestor("ProfilePlatform").Parent

local Signals = require(parent.Signals)

local InspectAvatarTooltipImpressionCache = require(script.Parent.InspectAvatarTooltipImpressionCache)

local defineFastInt = game:DefineFastInt("ProfilePlatformInspectAvatarTooltipMaxImpressions", 3)

local function createInspectAvatarTooltipStore()
	local signal, v = Signals.createSignal(false)

	return {
		getIsOpen = signal,
		tryShow = function()
			local value = InspectAvatarTooltipImpressionCache.getValue()

			if value < 0 or defineFastInt <= value then
				v(false)
				return
			end

			InspectAvatarTooltipImpressionCache.incrementValue()
			v(true)
		end,
		hide = function()
			v(false)
		end,
		permanentlyDismiss = function()
			InspectAvatarTooltipImpressionCache.dismissValue()
			v(false)
		end
	}
end

return createInspectAvatarTooltipStore
