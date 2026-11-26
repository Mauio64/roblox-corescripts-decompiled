local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ThemeBackground/SignalsReact")

local GetThemeBackgroundStore = require("@game/CorePackages/Workspace/Packages/_Index/ThemeBackground/ThemeBackground/Stores/GetThemeBackgroundStore")
require("@game/CorePackages/Workspace/Packages/_Index/ThemeBackground/ThemeBackground/ThemeBackgroundTypes")

local function useThemeBackground()
	return SignalsReact.useSignalState(GetThemeBackgroundStore(false).getThemeBackground)
end

return useThemeBackground
