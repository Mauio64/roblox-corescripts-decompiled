local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/React")
local Hooks = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Hooks")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/UniversalAppPolicy").useAppPolicy

local function AppShortcutBarStatusListener(p2): nil
	local v5 = Hooks.useAppShortcutBarHeight()

	local v6 = useAppPolicy(function(p3)
		return p3.getStickyShortcutBarEnabled()
	end)

	local v7 = Hooks.useShortcutBarVisible()

	local v8 = v6 and v7
	React.useEffect(function()
		if p2.onHeightChanged then
			p2.onHeightChanged(not v8 and 0 or v5)
		end
	end, { v8, v5, p2.onHeightChanged })

	return nil
end

return AppShortcutBarStatusListener
