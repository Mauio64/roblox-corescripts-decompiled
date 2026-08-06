local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local Signals = require(Parent.Signals)
local InspectAvatarTooltipImpressionCache = require(script.Parent.InspectAvatarTooltipImpressionCache)
local v4 = game:DefineFastInt("ProfilePlatformInspectAvatarTooltipMaxImpressions", 3)

local function createInspectAvatarTooltipStore() -- line: 17
	-- upvalues: Signals (copy), InspectAvatarTooltipImpressionCache (copy), v4 (copy)
	local v6, v7 = Signals.createSignal(false)

	return {
		getIsOpen = v6,
		tryShow = function() -- line: 20
			-- upvalues: InspectAvatarTooltipImpressionCache (copy), v4 (copy), v7 (copy)
			local v8 = InspectAvatarTooltipImpressionCache.getValue()

			if v8 < 0 or v8 >= v4 then
				v7(false)

				return
			end

			InspectAvatarTooltipImpressionCache.incrementValue()
			v7(true)
		end,
		hide = function() -- line: 32
			-- upvalues: v7 (copy)
			v7(false)
		end,
		permanentlyDismiss = function() -- line: 36
			-- upvalues: InspectAvatarTooltipImpressionCache (copy), v7 (copy)
			InspectAvatarTooltipImpressionCache.dismissValue()
			v7(false)
		end
	}
end

return createInspectAvatarTooltipStore
