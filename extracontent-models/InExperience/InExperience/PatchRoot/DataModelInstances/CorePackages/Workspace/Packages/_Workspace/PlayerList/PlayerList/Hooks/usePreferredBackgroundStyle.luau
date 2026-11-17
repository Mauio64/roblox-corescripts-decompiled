local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Foundation = require(parent2.Foundation)

local usePreferences = Foundation.Hooks.usePreferences
local usePreferredTransparencyBinding = require(parent.Hooks.usePreferredTransparencyBinding)
local FFlagPlayerListContrastingTeamText = require(parent.Flags.FFlagPlayerListContrastingTeamText)

local function usePreferredBackgroundStyle(p)
	local color3 = p.Color3
	local transparency = p.Transparency

	if not FFlagPlayerListContrastingTeamText then
		local v = usePreferredTransparencyBinding()

		return React.useMemo(function()
			return v:map(function(p2: number)
				return {
					Color3 = color3,
					Transparency = transparency * p2
				}
			end)
		end, { v, color3, transparency })
	end

	local v = usePreferences()
	local v2 = v.preferredTransparency == nil and 1 or v.preferredTransparency

	return React.useMemo(function()
		return React.createBinding({
			Color3 = color3,
			Transparency = transparency * v2
		})
	end, { color3, transparency, v2 })
end

return usePreferredBackgroundStyle
