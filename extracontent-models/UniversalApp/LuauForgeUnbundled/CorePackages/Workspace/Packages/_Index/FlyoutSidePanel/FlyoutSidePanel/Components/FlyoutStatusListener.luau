local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")

local useDrawerVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Drawer").Hooks.useDrawerVisible

local function FlyoutStatusListener(p2): nil
	local v5 = useDrawerVisible()
	React.useEffect(function()
		if p2.onVisibleChanged then
			p2.onVisibleChanged(v5)
		end
	end, { v5, p2.onVisibleChanged })

	return nil
end

return FlyoutStatusListener
