local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Signals")

local InspectAvatarTooltipImpressionCache = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Stores/GetInspectAvatarTooltipStore/InspectAvatarTooltipImpressionCache")

local defineFastInt = game:DefineFastInt("ProfilePlatformInspectAvatarTooltipMaxImpressions", 3)

local function createInspectAvatarTooltipStore()
	local signal, v5 = Signals.createSignal(false)

	return {
		getIsOpen = signal,
		tryShow = function()
			local value = InspectAvatarTooltipImpressionCache.getValue()

			if value < 0 or defineFastInt <= value then
				v5(false)
				return
			end

			InspectAvatarTooltipImpressionCache.incrementValue()
			v5(true)
		end,
		hide = function()
			v5(false)
		end,
		permanentlyDismiss = function()
			InspectAvatarTooltipImpressionCache.dismissValue()
			v5(false)
		end
	}
end

return createInspectAvatarTooltipStore
