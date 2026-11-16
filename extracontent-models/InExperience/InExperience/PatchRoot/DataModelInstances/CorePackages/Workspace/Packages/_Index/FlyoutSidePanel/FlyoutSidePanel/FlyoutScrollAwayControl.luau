local parent = script:FindFirstAncestor("FlyoutSidePanel").Parent

local Signals = require(parent.Signals)
local AppNavBar = require(parent.AppNavBar)
local VisibilityControl = AppNavBar.VisibilityControl
local Drawer = require(parent.Drawer)
local GetDrawerVisibleStore = Drawer.Stores.GetDrawerVisibleStore

local v = {
	scrollAwayEnabled = false,
	flyoutVisible = false,
	contextualMenuVisible = false,
	flyoutVisibleStore = nil,
	disposeFlyoutVisibleEffect = nil
}

v.__index = v

local instance = nil

function v.getInstance()
	if not instance then
		instance = {}
		setmetatable(instance, v)
		instance:initialize()
	end

	return instance
end

function v:initialize()
	self.flyoutVisibleStore = GetDrawerVisibleStore(false)
	self.disposeFlyoutVisibleEffect = Signals.createEffect(function(p)
		self.flyoutVisible = self.flyoutVisibleStore.getDrawerVisible(p)
		self:updateScrollAwayState()
	end)
end

function v:updateScrollAwayState()
	local v2 = self.scrollAwayEnabled and not (self.flyoutVisible or self.contextualMenuVisible)
	VisibilityControl.setEnabled(v2)
end

function v:setScrollAwayEnabled(scrollAwayEnabled: boolean)
	self.scrollAwayEnabled = scrollAwayEnabled
	self:updateScrollAwayState()
end

function v:setContextualMenuVisible(contextualMenuVisible: boolean)
	self.contextualMenuVisible = contextualMenuVisible
	self:updateScrollAwayState()
end

local FlyoutScrollAwayControl = {}

function FlyoutScrollAwayControl:setScrollAwayEnabled()
	return v.getInstance():setScrollAwayEnabled(self)
end

function FlyoutScrollAwayControl:setContextualMenuVisible()
	return v.getInstance():setContextualMenuVisible(self)
end

return FlyoutScrollAwayControl
