local parent = script.Parent.Parent
local Cryo = require(parent.Cryo)

local Input = require(script.Parent.Input)
local createSignal = require(script.Parent.createSignal)
local debugPrint = require(script.Parent.debugPrint)

local FocusControllerInternalApi = require(script.Parent.FocusControllerInternalApi)

local FocusController = {}
FocusController.__index = FocusController

function FocusController.new()
	return (setmetatable({
		selectionChangedSignal = createSignal(),
		boundInputsChangedSignal = createSignal(),
		focusNodeTree = {},
		allNodes = {},
		rootRef = nil,
		engineInterface = nil,
		captureFocusOnInitialize = false,
		moveFocusToOnInitialize = nil,
		inputDisconnectors = {},
		boundInputs = {},
		focusedLeaf = nil,
		inProgressFocus = nil
	}, FocusController))
end

function FocusController.isInitialized(p): boolean
	return p.engineInterface ~= nil
end

function FocusController:moveFocusTo(moveFocusToOnInitialize)
	if self.engineInterface == nil then
		self.moveFocusToOnInitialize = moveFocusToOnInitialize
		return
	end

	debugPrint("[FOCUS] Move focus to", moveFocusToOnInitialize)
	local allNode = self.allNodes[moveFocusToOnInitialize]

	if allNode ~= nil and not self:isNodeFocused(allNode) then
		allNode:focus()
	end

	self:debugPrintTree()
end

function FocusController:moveFocusToNeighbor(p)
	if self.engineInterface == nil then
		error("FocusController is not connected to a component hierarchy!", 2)
	end

	if self.focusedLeaf ~= nil then
		debugPrint("[FOCUS] Move focus to", p, "from", self.focusedLeaf.ref)
		local value = self.focusedLeaf.ref:getValue()

		if value ~= nil and value[p] ~= nil then
			self:setSelection(value[p])
		end
	end
end

function FocusController.getSelection(p)
	return p.engineInterface.getSelection()
end

function FocusController.setSelection(p, p2)
	p.engineInterface.setSelection(p2)
end

function FocusController:registerNode(p, rootRef, p2)
	if p == nil then
		debugPrint("[TREE ] Registering root node", rootRef)
		self.rootRef = rootRef
		self.allNodes[rootRef] = p2

		if self.captureFocusOnRootRegistered then
			self.captureFocusOnRootRegistered = false
			self:captureFocus()
		end
	else
		debugPrint("[TREE ] Registering child node", rootRef)

		local v = self.focusNodeTree[p] or {}
		v[rootRef] = p2
		self.focusNodeTree[p] = v
		self.allNodes[rootRef] = p2

		self:descendantAddedRefocus()
	end
end

function FocusController:deregisterNode(p, p2)
	if p == nil then
		debugPrint("[TREE ] Deregistering root node", p2)
		self.allNodes[p2] = nil
	else
		debugPrint("[TREE ] Deregistering child node", p2)
		self.focusNodeTree[p][p2] = nil
		self.allNodes[p2] = nil

		self:descendantRemovedRefocus()
	end
end

function FocusController:needsDescendantRemovedRefocus()
	if self.focusedLeaf == nil then
		return
	end

	return self.focusedLeaf.ref:getValue() == nil
end

function FocusController:descendantRemovedRefocus()
	if self:needsDescendantRemovedRefocus() then
		debugPrint("[FOCUS] Focused node was removed; refocusing from nearest existing ancestor")

		local parent2 = self.focusedLeaf.parent

		while parent2 ~= nil and self.allNodes[parent2.ref] == nil do
			parent2 = parent2.parent
		end

		if parent2 ~= nil then
			parent2:focus()
		end
	end
end

function FocusController:needsDescendantAddedRefocus(): nil | boolean
	if self.focusedLeaf == nil then
		return nil
	end

	return not Cryo.isEmpty(self:getChildren(self.focusedLeaf))
end

function FocusController:descendantAddedRefocus()
	if self:needsDescendantAddedRefocus() then
		debugPrint("[FOCUS] Currently-focused node is no longer a leaf; refocusing", self.focusedLeaf.ref)
		self.focusedLeaf:focus()
	end
end

function FocusController:getChildren(p)
	return self.focusNodeTree[p] or {}
end

function FocusController:isNodeFocused(p): boolean
	if self.focusedLeaf == nil then
		return false
	end

	if self.focusedLeaf == p then
		return true
	end

	local parent2 = self.focusedLeaf.parent

	while parent2 ~= nil do
		if parent2 == p then
			return true
		end

		parent2 = parent2.parent
	end

	return false
end

function FocusController:setFocusedLeaf(focusedLeaf)
	self.focusedLeaf = focusedLeaf
end

function FocusController:setInProgressFocus(inProgressFocus)
	self.inProgressFocus = inProgressFocus
end

function FocusController.isInProgressFocus(p, p2): boolean
	return p.inProgressFocus == p2
end

function FocusController:debugPrintTree()
	if not debugPrint.isEnabled then
		return
	end

	local function recursePrintTree(p, p2)
		local v = tostring(p.ref)

		if self:isNodeFocused(p) then
			v ..= "*"
		end

		debugPrint(p2, v)

		local children = self:getChildren(p)

		for _, child in pairs(children) do
			recursePrintTree(child, p2 .. "  ")
		end
	end

	debugPrint("Focus Node Tree:")
	recursePrintTree(self.allNodes[self.rootRef], "  ")
end

function FocusController:updateInputBindings()
	local v = self.focusedLeaf
	local inputBindingsByUniqueKey = {}

	while v ~= nil do
		for _, inputBinding in pairs(v.inputBindings) do
			local uniqueKey = Input.getUniqueKey(inputBinding)

			if inputBindingsByUniqueKey[uniqueKey] ~= nil then
				continue
			end

			debugPrint("[INPUT] Bind input", uniqueKey)
			inputBindingsByUniqueKey[uniqueKey] = inputBinding
		end

		v = v.parent
	end

	for _, inputDisconnector in pairs(self.inputDisconnectors) do
		inputDisconnector()
	end

	self.inputDisconnectors = {}
	self.boundInputs = {}

	for k, v2 in pairs(inputBindingsByUniqueKey) do
		self.inputDisconnectors[k] = Input.connectToEvent(v2, self.engineInterface)

		if v2.keyCode then
			self.boundInputs[v2.keyCode] = v2.meta or {}
		end
	end

	self.boundInputsChangedSignal:fire(self.boundInputs)
end

function FocusController:initialize(engineInterface)
	if self.engineInterface ~= nil then
		error("FocusController cannot be initialized more than once; make sure you are not passing it to multiple components")
	end

	self.engineInterface = engineInterface

	self.guiServiceConnection = engineInterface.subscribeToSelectionChanged(function()
		if self.rootRef == nil then
			return
		end

		local v = self.focusedLeaf ~= nil

		self.focusedLeaf = nil
		local selection = engineInterface.getSelection()
		local value = self.rootRef:getValue()

		if selection ~= nil and (value == selection or selection:IsDescendantOf(value)) then
			debugPrint("[EVENT] Selection changed to", selection, "in focus hierarchy beginning at", value)

			for k, allNode in pairs(self.allNodes) do
				if selection == k:getValue() then
					self.focusedLeaf = allNode
					break
				end
			end
		end

		if self.focusedLeaf ~= nil or v then
			self.selectionChangedSignal:fire()

			self:updateInputBindings()
		end
	end)

	if self.captureFocusOnInitialize then
		self:captureFocus()
	end

	if self.moveFocusToOnInitialize then
		self:moveFocusTo(self.moveFocusToOnInitialize)
	end
end

function FocusController:captureFocus()
	if self.engineInterface == nil then
		self.captureFocusOnInitialize = true
		return
	end

	if self.rootRef == nil then
		self.captureFocusOnRootRegistered = true
		return
	end

	self.allNodes[self.rootRef]:focus()
	self:debugPrintTree()
end

function FocusController:releaseFocus()
	if self.engineInterface ~= nil then
		self.engineInterface.setSelection(nil)
	end

	self.captureFocusOnInitialize = false
	self.captureFocusOnRootRegistered = false
end

function FocusController:teardown()
	if self.guiServiceConnection ~= nil then
		self.guiServiceConnection:Disconnect()
	end

	for _, inputDisconnector in pairs(self.inputDisconnectors) do
		inputDisconnector()
	end

	self.rootRef = nil
	self.engineInterface = nil
	self.captureFocusOnInitialize = false
	self.captureFocusOnRootRegistered = false
	self.focusedLeaf = nil
end

function FocusController.subscribeToSelectionChange(p, p2)
	debugPrint("[TREE ] New subscription to selection change event")
	return p.selectionChangedSignal:subscribe(p2)
end

function FocusController.createPublicApiWrapper()
	local v = FocusController.new()

	return {
		[FocusControllerInternalApi] = v,
		moveFocusTo = function(...)
			v:moveFocusTo(...)
		end,
		moveFocusLeft = function()
			v:moveFocusToNeighbor("NextSelectionLeft")
		end,
		moveFocusRight = function()
			v:moveFocusToNeighbor("NextSelectionRight")
		end,
		moveFocusUp = function()
			v:moveFocusToNeighbor("NextSelectionUp")
		end,
		moveFocusDown = function()
			v:moveFocusToNeighbor("NextSelectionDown")
		end,
		captureFocus = function()
			v:captureFocus()
		end,
		releaseFocus = function()
			v:releaseFocus()
		end,
		getCurrentFocus = function()
			local focusedLeaf = v.focusedLeaf
			return focusedLeaf and focusedLeaf.ref or nil
		end,
		getBoundInputs = function()
			return v.boundInputs
		end,
		subscribeToBoundInputsChanged = function(p)
			return v.boundInputsChangedSignal:subscribe(p)
		end
	}
end

return FocusController
