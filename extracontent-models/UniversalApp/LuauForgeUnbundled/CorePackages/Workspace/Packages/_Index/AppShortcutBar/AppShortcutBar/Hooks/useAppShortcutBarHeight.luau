local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/Foundation").Hooks.useTokens

local function useAppShortcutBarHeight()
	return useTokens().Size.Size_1200
end

return useAppShortcutBarHeight
