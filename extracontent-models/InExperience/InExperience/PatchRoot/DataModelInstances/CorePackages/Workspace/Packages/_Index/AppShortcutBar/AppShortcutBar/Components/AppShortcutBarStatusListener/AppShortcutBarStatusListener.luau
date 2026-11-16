local AppShortcutBar = script:FindFirstAncestor("AppShortcutBar")
local parent = AppShortcutBar.Parent

local React = require(parent.React)
local Hooks = require(AppShortcutBar.Hooks)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy

local function AppShortcutBarStatusListener(p): nil
	local v = Hooks.useAppShortcutBarHeight()

	local v2 = useAppPolicy(function(p2)
		return p2.getStickyShortcutBarEnabled()
	end)

	local v3 = Hooks.useShortcutBarVisible()

	local v4 = v2 and v3
	React.useEffect(function()
		if p.onHeightChanged then
			p.onHeightChanged(not v4 and 0 or v)
		end
	end, { v4, v, p.onHeightChanged })

	return nil
end

return AppShortcutBarStatusListener
