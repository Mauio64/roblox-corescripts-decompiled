local Parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local Signals = require(Parent.Signals)
local VisibilityControl = require(Parent.AppNavBar).VisibilityControl
local GetDrawerVisibleStore = require(Parent.Drawer).Stores.GetDrawerVisibleStore
local t1 = {
	scrollAwayEnabled = false,
	flyoutVisible = false,
	contextualMenuVisible = false,
	flyoutVisibleStore = nil,
	disposeFlyoutVisibleEffect = nil
}

t1.__index = t1

local t2 = nil

function t1.getInstance() -- line: 40
	-- upvalues: t2 (ref), t1 (copy)
	if not t2 then
		t2 = {}
		setmetatable(t2, t1)
		t2:initialize()
	end

	return t2
end
function t1.initialize(p1) -- line: 49
	-- upvalues: GetDrawerVisibleStore (copy), Signals (copy)
	p1.flyoutVisibleStore = GetDrawerVisibleStore(false)
	p1.disposeFlyoutVisibleEffect = Signals.createEffect(function(p2) -- line: 51
		-- upvalues: p1 (copy)
		p1.flyoutVisible = p1.flyoutVisibleStore.getDrawerVisible(p2)
		p1:updateScrollAwayState()
	end)
end
function t1.updateScrollAwayState(p3) -- line: 58
	-- upvalues: VisibilityControl (copy)
	local v9 = p3.scrollAwayEnabled and (not p3.flyoutVisible and not p3.contextualMenuVisible)

	VisibilityControl.setEnabled(v9)
end
function t1.setScrollAwayEnabled(t3: {[any]: any}, b1: boolean) -- line: 63
	t3.scrollAwayEnabled = b1
	t3:updateScrollAwayState()
end
function t1.setContextualMenuVisible(t4: {[any]: any}, b2: boolean) -- line: 68
	t4.contextualMenuVisible = b2
	t4:updateScrollAwayState()
end

return {
	setScrollAwayEnabled = function(b3: boolean) -- line: 74
		-- upvalues: t1 (copy)
		return t1.getInstance():setScrollAwayEnabled(b3)
	end,
	setContextualMenuVisible = function(b4: boolean) -- line: 77
		-- upvalues: t1 (copy)
		return t1.getInstance():setContextualMenuVisible(b4)
	end
}
