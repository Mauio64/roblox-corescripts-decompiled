local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
local useTokens = Foundation.Hooks.useTokens

local usePreferredBackgroundStyle = require(parent.Hooks.usePreferredBackgroundStyle)

local function useLegacyAndTransparencyAwarePanelStyle(flag: boolean?)
	local backgroundStyle = usePreferredBackgroundStyle(useTokens().Color.OverMedia.OverMedia_0)
	local v = flag == true
	local v2 = {
		panelTag = React.useMemo(function()
			return {
				["col fill size-full-0 padding-large gap-medium align-x-center align-y-center"] = true
			}
		end, {}),
		backgroundStyle = 0
	}

	if v then
		backgroundStyle = nil
	end

	v2.backgroundStyle = backgroundStyle
	return v2
end

return useLegacyAndTransparencyAwarePanelStyle
