local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(Parent.React)
local useMakeupFtux = require(script.Parent.useMakeupFtux)
local v4 = game:DefineFastInt("AXMakeupLayeringTooltipShowDelayMS", 500)
local v5 = game:DefineFastInt("AXMakeupLayeringTooltipDismissTimeoutSeconds", 5)

local function useMakeupLayeringTooltip(b1: boolean) -- line: 11
	-- upvalues: useMakeupFtux (copy), React (copy), v4 (copy), v5 (copy)
	local v8 = useMakeupFtux()
	local v9, v10 = React.useState(false)

	React.useEffect(function() -- line: 15
		-- upvalues: b1 (copy), v8 (copy), v10 (copy), v4 (copy)
		if not b1 or not v8.shouldShowMakeupLayeringTooltip() then
			v10(false)

			return
		end

		local thread = task.delay(v4 / 1000, function() -- line: 21
			-- upvalues: v10 (copy), v8 (copy)
			v10(true)
			v8.markMakeupLayeringTooltipSeen()
		end)

		return function() -- line: 26
			-- upvalues: thread (copy)
			if thread then
				task.cancel(thread)
			end
		end
	end, { b1 })
	React.useEffect(function() -- line: 33
		-- upvalues: v9 (copy), v5 (copy), v10 (copy)
		if not v9 then
			return
		end

		local thread = task.delay(v5, function() -- line: 38
			-- upvalues: v10 (copy)
			v10(false)
		end)

		return function() -- line: 42
			-- upvalues: thread (copy)
			if thread then
				task.cancel(thread)
			end
		end
	end, { v9 })

	local v11 = React.useCallback(function() -- line: 49
		-- upvalues: v10 (copy)
		v10(false)
	end, {})

	return {
		showTooltip = v9,
		dismissTooltip = v11
	}
end

return useMakeupLayeringTooltip
