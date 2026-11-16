local parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(parent.React)

local Drawer = require(parent.Drawer)
local useDrawerVisible = Drawer.Hooks.useDrawerVisible

local function FlyoutStatusListener(p): nil
	local v = useDrawerVisible()
	React.useEffect(function()
		if p.onVisibleChanged then
			p.onVisibleChanged(v)
		end
	end, { v, p.onVisibleChanged })

	return nil
end

return FlyoutStatusListener
