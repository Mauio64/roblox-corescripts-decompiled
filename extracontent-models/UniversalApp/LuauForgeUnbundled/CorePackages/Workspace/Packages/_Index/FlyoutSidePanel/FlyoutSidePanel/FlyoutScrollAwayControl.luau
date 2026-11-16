local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Signals")
local visibilityControl = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/AppNavBar").VisibilityControl
local getDrawerVisibleStore = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Drawer").Stores.GetDrawerVisibleStore

local v5 = {
	scrollAwayEnabled = false,
	flyoutVisible = false,
	contextualMenuVisible = false,
	flyoutVisibleStore = nil,
	disposeFlyoutVisibleEffect = nil
}

v5.__index = v5

local instance = nil

function v5.getInstance()
	if not instance then
		instance = {}
		setmetatable(instance, v5)
		instance:initialize()
	end

	return instance
end

function v5:initialize()
	self.flyoutVisibleStore = getDrawerVisibleStore(false)
	self.disposeFlyoutVisibleEffect = Signals.createEffect(function(p2)
		self.flyoutVisible = self.flyoutVisibleStore.getDrawerVisible(p2)
		self:updateScrollAwayState()
	end)
end

function v5:updateScrollAwayState()
	local v6 = self.scrollAwayEnabled and not (self.flyoutVisible or self.contextualMenuVisible)
	visibilityControl.setEnabled(v6)
end

function v5:setScrollAwayEnabled(scrollAwayEnabled)
	self.scrollAwayEnabled = scrollAwayEnabled
	self:updateScrollAwayState()
end

function v5:setContextualMenuVisible(contextualMenuVisible)
	self.contextualMenuVisible = contextualMenuVisible
	self:updateScrollAwayState()
end

return {
	setScrollAwayEnabled = function(p2)
		return v5.getInstance():setScrollAwayEnabled(p2)
	end,
	setContextualMenuVisible = function(p2)
		return v5.getInstance():setContextualMenuVisible(p2)
	end
}
