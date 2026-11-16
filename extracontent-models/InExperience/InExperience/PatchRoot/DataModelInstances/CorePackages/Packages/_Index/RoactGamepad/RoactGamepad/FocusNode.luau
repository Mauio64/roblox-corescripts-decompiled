local parent = script.Parent.Parent
local Cryo = require(parent.Cryo)

local FocusControllerInternalApi = require(script.Parent.FocusControllerInternalApi)
local inputBindingsEqual = require(script.Parent.inputBindingsEqual)
local debugPrint = require(script.Parent.debugPrint)
local Config = require(script.Parent.Config)

local FocusNode = {}
FocusNode.__index = FocusNode

function FocusNode.new(p, ref)
	local focusController = nil

	if p.parentFocusNode == nil then
		if p.focusController == nil then
			error("Cannot create node without focus manager")
		else
			focusController = p.focusController
		end
	else
		focusController = p.parentFocusNode.focusController
	end

	local object = setmetatable({ focusController = focusController, ref = ref, lastFocused = nil }, FocusNode)

	object:updateNavProps(p)

	return object
end

function FocusNode:__getFocusControllerInternal()
	return self.focusController[FocusControllerInternalApi]
end

function FocusNode:__findDefaultChildNode()
	local children = self:__getFocusControllerInternal():getChildren(self)
	local value = self.ref:getValue()
	local v = 1e999
	local v2 = nil

	for k, child in pairs(children) do
		local v3 = k:getValue()

		while v3 ~= value and v3 ~= nil do
			if v3:isA("GuiObject") then
				local layoutOrder = v3.LayoutOrder

				if layoutOrder ~= 0 then
					if layoutOrder < v then
						v2 = child
						v = layoutOrder
					end

					break
				end
			end

			v3 = v3.Parent
		end
	end

	if v2 ~= nil then
		return v2
	end

	for k, child in pairs(children) do
		if k:getValue() ~= nil then
			return child
		end
	end

	return nil
end

function FocusNode:updateNavProps(data)
	local restorePreviousChildFocus

	if data.restorePreviousChildFocus == nil then
		restorePreviousChildFocus = false
	else
		restorePreviousChildFocus = data.restorePreviousChildFocus
	end

	local inputBindings = self.inputBindings

	self.defaultChildRef = data.defaultChild
	self.restorePreviousChildFocus = restorePreviousChildFocus
	self.inputBindings = data.inputBindings or {}

	local __getFocusControllerInternal = self:__getFocusControllerInternal()

	if
		__getFocusControllerInternal:isNodeFocused(self)
		and not inputBindingsEqual(inputBindings, self.inputBindings)
	then
		__getFocusControllerInternal:updateInputBindings()
	end
end

function FocusNode:focus()
	if not Config.Enabled then
		return
	end

	local __getFocusControllerInternal = self:__getFocusControllerInternal()

	if not __getFocusControllerInternal:isInitialized() then
		return
	end

	__getFocusControllerInternal:setInProgressFocus(self)
	local children = __getFocusControllerInternal:getChildren(self)

	if Cryo.isEmpty(children) then
		__getFocusControllerInternal:setSelection(self.ref:getValue())
		return
	end

	local now = os.clock()
	local v

	if self.defaultChildRef == nil or __getFocusControllerInternal.allNodes[self.defaultChildRef] == nil then
		v = false
	else
		v = self.defaultChildRef:getValue() ~= nil
	end

	local v2 = self.timeout == nil or now < self.timeout

	if self.restorePreviousChildFocus and self.lastFocused ~= nil and self.lastFocused:getValue() then
		debugPrint("[FOCUS] Restore previous focus:", self.lastFocused)
		__getFocusControllerInternal:moveFocusTo(self.lastFocused)
	elseif self.defaultChildRef and (v2 or v) then
		if v then
			debugPrint("[FOCUS] Found valid default child", self.defaultChildRef, "for", self.ref)
			self.timeout = nil
			__getFocusControllerInternal:moveFocusTo(self.defaultChildRef)
		else
			if self.timeout == nil then
				debugPrint("[FOCUS] Default child specified is not valid. Wait for it to be assigned...")
				self.timeout = now + 0.5
			end

			task.delay(0, function()
				if __getFocusControllerInternal:isInProgressFocus(self) then
					self:focus()
				end
			end)
		end
	else
		if self.timeout ~= nil then
			debugPrint("[FOCUS] Timeout for default child of", self.ref)
			self.timeout = nil
		end

		local __findDefaultChildNode = self:__findDefaultChildNode()

		if __findDefaultChildNode == nil then
			__getFocusControllerInternal:setFocusedLeaf(self)
			__getFocusControllerInternal:setInProgressFocus(nil)
		else
			debugPrint("[FOCUS] No default, use fallback logic to focus", __findDefaultChildNode.ref)
			__findDefaultChildNode:focus()
		end
	end
end

function FocusNode:attachToTree(parent2, callback)
	local __getFocusControllerInternal = self:__getFocusControllerInternal()
	__getFocusControllerInternal:registerNode(parent2, self.ref, self)

	self.parent = parent2
	self.disconnectSelectionListener = __getFocusControllerInternal:subscribeToSelectionChange(function()
		local nodeFocused = __getFocusControllerInternal:isNodeFocused(self)
		callback(nodeFocused)

		if self.parent ~= nil and nodeFocused then
			self.parent.lastFocused = self.ref
		end

		local children = __getFocusControllerInternal:getChildren(self)

		if
			not Cryo.isEmpty(children)
			and nodeFocused
			and __getFocusControllerInternal:getSelection() == self.ref:getValue()
		then
			self:focus()
		end
	end)
end

function FocusNode:detachFromTree()
	self:__getFocusControllerInternal():deregisterNode(self.parent, self.ref)

	if self.disconnectSelectionListener ~= nil then
		self.disconnectSelectionListener()
		self.disconnectSelectionListener = nil
	end
end

return FocusNode
