local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)

local usePreferredTransparencyBinding = require(parent.Hooks.usePreferredTransparencyBinding)

local function usePreferredBackgroundStyle(p)
	local v = usePreferredTransparencyBinding()
	local color3 = p.Color3
	local transparency = p.Transparency

	return React.useMemo(function()
		return v:map(function(p2: number)
			return {
				Color3 = color3,
				Transparency = transparency * p2
			}
		end)
	end, { v, color3, transparency })
end

return usePreferredBackgroundStyle
