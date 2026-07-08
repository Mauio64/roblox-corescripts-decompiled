local Parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(Parent.React)
local useDrawerVisible = require(Parent.Drawer).Hooks.useDrawerVisible

local function FlyoutStatusListener(t1: {[any]: any}) -- line: 11
	-- upvalues: useDrawerVisible (copy), React (copy)
	local v6 = useDrawerVisible()

	React.useEffect(function() -- line: 13
		-- upvalues: t1 (copy), v6 (copy)
		if t1.onVisibleChanged then
			t1.onVisibleChanged(v6)
		end
	end, {
		v6,
		t1.onVisibleChanged
	})

	return nil
end

return FlyoutStatusListener
