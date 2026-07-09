local AppShortcutBar = script:FindFirstAncestor("AppShortcutBar")
local AppShortcutBarParent = AppShortcutBar.Parent
local React = require(AppShortcutBarParent.React)
local Hooks = require(AppShortcutBar.Hooks)
local useAppPolicy = require(AppShortcutBarParent.UniversalAppPolicy).useAppPolicy
local FFlagGuacStickyShortcutBarEnabled = require(AppShortcutBarParent.SharedFlags).FFlagGuacStickyShortcutBarEnabled

local function AppShortcutBarStatusListener(t1: {[any]: any}) -- line: 14
	-- upvalues: Hooks (copy), FFlagGuacStickyShortcutBarEnabled (copy), useAppPolicy (copy), React (copy)
	local v9 = Hooks.useAppShortcutBarHeight()
	local v10 = if not FFlagGuacStickyShortcutBarEnabled then Hooks.useIsStickyShortcutBarEnabled() else useAppPolicy(function(p1) -- line: 19
		return p1.getStickyShortcutBarEnabled()
	end)
	local v11 = Hooks.useShortcutBarVisible()
	local v12 = v10 and v11

	React.useEffect(function() -- line: 29
		-- upvalues: t1 (copy), v12 (copy), v9 (copy)
		if t1.onHeightChanged then
			local v14 = not v12 and 0 or v9

			t1.onHeightChanged(v14)
		end
	end, {
		v12,
		v9,
		t1.onHeightChanged
	})

	return nil
end

return AppShortcutBarStatusListener
