local parent = script.Parent
local parent2 = parent.Parent

local SignalsReact = require(parent2.SignalsReact)

local GetThemeBackgroundStore = require(parent.Stores.GetThemeBackgroundStore)
require(parent.ThemeBackgroundTypes)

local function useThemeBackground()
	return SignalsReact.useSignalState(GetThemeBackgroundStore(false).getThemeBackground)
end

return useThemeBackground
