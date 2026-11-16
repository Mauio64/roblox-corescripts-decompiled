local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local React = require(parent.React)

local useMakeupFtux = require(script.Parent.useMakeupFtux)

local defineFastInt = game:DefineFastInt("AXMakeupLayeringTooltipShowDelayMS", 500)
local defineFastInt2 = game:DefineFastInt("AXMakeupLayeringTooltipDismissTimeoutSeconds", 5)

local function useMakeupLayeringTooltip(flag: boolean)
	local v = useMakeupFtux()
	local state, setState = React.useState(false)

	React.useEffect(function()
		if flag and v.shouldShowMakeupLayeringTooltip() then
			local thread = task.delay(defineFastInt / 1000, function()
				setState(true)
				v.markMakeupLayeringTooltipSeen()
			end)

			return function()
				if thread then
					task.cancel(thread)
				end
			end
		end

		setState(false)
	end, { flag })

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
