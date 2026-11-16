local parent = script:FindFirstAncestor("AppShortcutBar").Parent
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local function useAppShortcutBarHeight()
	return useTokens().Size.Size_1200
end

return useAppShortcutBarHeight
