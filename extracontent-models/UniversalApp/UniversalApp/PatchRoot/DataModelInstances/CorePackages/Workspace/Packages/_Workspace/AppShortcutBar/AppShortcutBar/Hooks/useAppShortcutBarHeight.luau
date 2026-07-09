local Parent = script:FindFirstAncestor("AppShortcutBar").Parent
local useTokens = require(Parent.Foundation).Hooks.useTokens

local function useAppShortcutBarHeight() -- line: 5
	-- upvalues: useTokens (copy)
	return useTokens().Size.Size_1200
end

return useAppShortcutBarHeight
