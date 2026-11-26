local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")

local useMakeupFtux = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Hooks/useMakeupFtux")

local defineFastInt = game:DefineFastInt("AXMakeupLayeringTooltipShowDelayMS", 500)
local defineFastInt2 = game:DefineFastInt("AXMakeupLayeringTooltipDismissTimeoutSeconds", 5)

local function useMakeupLayeringTooltip(p2)
	local v5 = useMakeupFtux()
	local state, setState = React.useState(false)

	React.useEffect(function()
		if p2 and v5.shouldShowMakeupLayeringTooltip() then
			local thread = task.delay(defineFastInt / 1000, function()
				setState(true)
				v5.markMakeupLayeringTooltipSeen()
			end)

			return function()
				if thread then
					task.cancel(thread)
				end
			end
		end

		setState(false)
	end, { p2 })

	React.useEffect(function()
		if not state then
			return
		end

		local thread = task.delay(defineFastInt2, function()
			setState(false)
		end)

		return function()
			if thread then
				task.cancel(thread)
			end
		end
	end, { state })

	return {
		showTooltip = state,
		dismissTooltip = React.useCallback(function()
			setState(false)
		end, {})
	}
end

return useMakeupLayeringTooltip
