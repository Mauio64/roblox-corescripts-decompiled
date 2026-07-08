local ParentParent = script.Parent.Parent
local Cryo = require(ParentParent.Cryo)
local Input = require(script.Parent.Input)
local createSignal = require(script.Parent.createSignal)
local debugPrint = require(script.Parent.debugPrint)
local FocusControllerInternalApi = require(script.Parent.FocusControllerInternalApi)
local t1 = {}

t1.__index = t1

function t1.new() -- line: 16
	-- upvalues: createSignal (copy), t1 (copy)
	return (setmetatable({
		rootRef = nil,
		engineInterface = nil,
		captureFocusOnInitialize = false,
		moveFocusToOnInitialize = nil,
		focusedLeaf = nil,
		inProgressFocus = nil,
		selectionChangedSignal = createSignal(),
		boundInputsChangedSignal = createSignal(),
		focusNodeTree = {},
		allNodes = {},
		inputDisconnectors = {},
		boundInputs = {}
	}, t1))
end
function t1.isInitialized(p1) -- line: 37
	return p1.engineInterface ~= nil
end
function t1.moveFocusTo(p2, p3) -- line: 41
	-- upvalues: debugPrint (copy)
	if p2.engineInterface == nil then
		p2.moveFocusToOnInitialize = p3

		return
	end

	debugPrint("[FOCUS] Move focus to", p3)

	local v11 = p2.allNodes[p3]

	if v11 ~= nil and not p2:isNodeFocused(v11) then
		v11:focus()
	end

	p2:debugPrintTree()
end
function t1.moveFocusToNeighbor(p4, p5) -- line: 56
	-- upvalues: debugPrint (copy)
	if p4.engineInterface == nil then
		error("FocusController is not connected to a component hierarchy!", 2)
	end

	if p4.focusedLeaf ~= nil then
		debugPrint("[FOCUS] Move focus to", p5, "from", p4.focusedLeaf.ref)

		local v14 = p4.focusedLeaf.ref:getValue()

		if v14 ~= nil and v14[p5] ~= nil then
			p4:setSelection(v14[p5])
		end
	end
end
function t1.getSelection(p6) -- line: 70
	return p6.engineInterface.getSelection()
end
function t1.setSelection(p7, p8) -- line: 74
	p7.engineInterface.setSelection(p8)
end
function t1.registerNode(p9, p10, p11, p12) -- line: 78
	-- upvalues: debugPrint (copy)
	if p10 ~= nil then
		debugPrint("[TREE ] Registering child node", p11)

		local v22 = p9.focusNodeTree[p10] or {}

		v22[p11] = p12
		p9.focusNodeTree[p10] = v22
		p9.allNodes[p11] = p12
		p9:descendantAddedRefocus()

		return
	end

	debugPrint("[TREE ] Registering root node", p11)
	p9.rootRef = p11
	p9.allNodes[p11] = p12

	if p9.captureFocusOnRootRegistered then
		p9.captureFocusOnRootRegistered = false
		p9:captureFocus()
	end
end
function t1.deregisterNode(p13, p14, p15) -- line: 103
	-- upvalues: debugPrint (copy)
	if p14 ~= nil then
		debugPrint("[TREE ] Deregistering child node", p15)
		p13.focusNodeTree[p14][p15] = nil
		p13.allNodes[p15] = nil
		p13:descendantRemovedRefocus()

		return
	end

	debugPrint("[TREE ] Deregistering root node", p15)
	p13.allNodes[p15] = nil
end
function t1.needsDescendantRemovedRefocus(p16) -- line: 119
	if p16.focusedLeaf == nil then
		return
	end

	return p16.focusedLeaf.ref:getValue() == nil
end
function t1.descendantRemovedRefocus(p17) -- line: 132
	-- upvalues: debugPrint (copy)
	if p17:needsDescendantRemovedRefocus() then
		debugPrint("[FOCUS] Focused node was removed; refocusing from nearest existing ancestor")

		local parent = p17.focusedLeaf.parent

		while parent ~= nil and p17.allNodes[parent.ref] == nil do
			parent = parent.parent
		end

		if parent ~= nil then
			parent:focus()
		end
	end
end
function t1.needsDescendantAddedRefocus(p18) -- line: 149
	-- upvalues: Cryo (copy)
	if p18.focusedLeaf == nil then
		return nil
	end

	return not Cryo.isEmpty(p18:getChildren(p18.focusedLeaf))
end
function t1.descendantAddedRefocus(p19) -- line: 162
	-- upvalues: debugPrint (copy)
	if p19:needsDescendantAddedRefocus() then
		debugPrint("[FOCUS] Currently-focused node is no longer a leaf; refocusing", p19.focusedLeaf.ref)
		p19.focusedLeaf:focus()
	end
end
function t1.getChildren(p20, p21) -- line: 171
	return p20.focusNodeTree[p21] or {}
end
function t1.isNodeFocused(p22, p23) -- line: 175
	if p22.focusedLeaf == nil then
		return false
	end

	if p23 == p22.focusedLeaf then
		return true
	end

	local parent = p22.focusedLeaf.parent

	while parent ~= nil do
		if parent == p23 then
			return true
		end

		parent = parent.parent
	end

	return false
end
function t1.setFocusedLeaf(p24, p25) -- line: 198
	p24.focusedLeaf = p25
end
function t1.setInProgressFocus(p26, p27) -- line: 202
	p26.inProgressFocus = p27
end
function t1.isInProgressFocus(p28, p29) -- line: 206
	return p29 == p28.inProgressFocus
end
function t1.debugPrintTree(p30) -- line: 211
	-- upvalues: debugPrint (copy)
	if not debugPrint.isEnabled then
		return
	end

	local function recursePrintTree(p31, p32) -- line: 216
		-- upvalues: p30 (copy), debugPrint (copy), recursePrintTree (copy)
		local str = tostring(p31.ref)

		if p30:isNodeFocused(p31) then
			str ..= "*"
		end

		debugPrint(p32, str)

		local v67 = p30:getChildren(p31)

		for _, v in pairs(v67) do
			recursePrintTree(v, p32 .. "  ")
		end
	end

	debugPrint("Focus Node Tree:")
	recursePrintTree(p30.allNodes[p30.rootRef], "  ")
end
function t1.updateInputBindings(p33) -- line: 236
	-- upvalues: Input (copy), debugPrint (copy)
	local t2 = {}
	local focusedLeaf = p33.focusedLeaf

	while focusedLeaf ~= nil do
		for _, v in pairs(focusedLeaf.inputBindings) do
			local v49 = Input.getUniqueKey(v)

			if t2[v49] == nil then
				debugPrint("[INPUT] Bind input", v49)
				t2[v49] = v
			end
		end

		focusedLeaf = focusedLeaf.parent
	end

	for _, v in pairs(p33.inputDisconnectors) do
		v()
	end

	p33.inputDisconnectors = {}
	p33.boundInputs = {}

	for k, v in pairs(t2) do
		p33.inputDisconnectors[k] = Input.connectToEvent(v, p33.engineInterface)

		if v.keyCode then
			p33.boundInputs[v.keyCode] = v.meta or {}
		end
	end

	p33.boundInputsChangedSignal:fire(p33.boundInputs)
end
function t1.initialize(p34, p35) -- line: 271
	-- upvalues: debugPrint (copy)
	if p34.engineInterface ~= nil then
		error("FocusController cannot be initialized more than once; make sure you are not passing it to multiple components")
	end

	p34.engineInterface = p35
	p34.guiServiceConnection = p35.subscribeToSelectionChanged(function() -- line: 284
		-- upvalues: p34 (copy), p35 (copy), debugPrint (copy)
		if p34.rootRef == nil then
			return
		end

		local v70 = p34.focusedLeaf ~= nil

		p34.focusedLeaf = nil

		local v71 = p35.getSelection()
		local v72 = p34.rootRef:getValue()

		if v71 ~= nil and (v72 == v71 or v71:IsDescendantOf(v72)) then
			debugPrint("[EVENT] Selection changed to", v71, "in focus hierarchy beginning at", v72)

			for k, v in pairs(p34.allNodes) do
				if v71 == k:getValue() then
					p34.focusedLeaf = v

					break
				end
			end
		end

		if p34.focusedLeaf ~= nil or v70 then
			p34.selectionChangedSignal:fire()
			p34:updateInputBindings()
		end
	end)

	if p34.captureFocusOnInitialize then
		p34:captureFocus()
	end

	if p34.moveFocusToOnInitialize then
		p34:moveFocusTo(p34.moveFocusToOnInitialize)
	end
end
function t1.captureFocus(p36) -- line: 344
	if p36.engineInterface == nil then
		p36.captureFocusOnInitialize = true

		return
	end

	if p36.rootRef == nil then
		p36.captureFocusOnRootRegistered = true

		return
	end

	p36.allNodes[p36.rootRef]:focus()
	p36:debugPrintTree()
end
function t1.releaseFocus(p37) -- line: 355
	if p37.engineInterface ~= nil then
		p37.engineInterface.setSelection(nil)
	end

	p37.captureFocusOnInitialize = false
	p37.captureFocusOnRootRegistered = false
end
function t1.teardown(p38) -- line: 363
	if p38.guiServiceConnection ~= nil then
		p38.guiServiceConnection:Disconnect()
	end

	for _, v in pairs(p38.inputDisconnectors) do
		v()
	end

	p38.rootRef = nil
	p38.engineInterface = nil
	p38.captureFocusOnInitialize = false
	p38.captureFocusOnRootRegistered = false
	p38.focusedLeaf = nil
end
function t1.subscribeToSelectionChange(p39, p40) -- line: 382
	-- upvalues: debugPrint (copy)
	debugPrint("[TREE ] New subscription to selection change event")

	return p39.selectionChangedSignal:subscribe(p40)
end
function t1.createPublicApiWrapper() -- line: 389
	-- upvalues: t1 (copy), FocusControllerInternalApi (copy)
	local v63 = t1.new()

	return {
		[FocusControllerInternalApi] = v63,
		moveFocusTo = function(...) -- line: 394
			-- upvalues: v63 (copy)
			v63:moveFocusTo(...)
		end,
		moveFocusLeft = function() -- line: 397
			-- upvalues: v63 (copy)
			v63:moveFocusToNeighbor("NextSelectionLeft")
		end,
		moveFocusRight = function() -- line: 400
			-- upvalues: v63 (copy)
			v63:moveFocusToNeighbor("NextSelectionRight")
		end,
		moveFocusUp = function() -- line: 403
			-- upvalues: v63 (copy)
			v63:moveFocusToNeighbor("NextSelectionUp")
		end,
		moveFocusDown = function() -- line: 406
			-- upvalues: v63 (copy)
			v63:moveFocusToNeighbor("NextSelectionDown")
		end,
		captureFocus = function() -- line: 409
			-- upvalues: v63 (copy)
			v63:captureFocus()
		end,
		releaseFocus = function() -- line: 412
			-- upvalues: v63 (copy)
			v63:releaseFocus()
		end,
		getCurrentFocus = function() -- line: 415
			-- upvalues: v63 (copy)
			local focusedLeaf = v63.focusedLeaf

			return focusedLeaf and focusedLeaf.ref or nil
		end,
		getBoundInputs = function() -- line: 419
			-- upvalues: v63 (copy)
			return v63.boundInputs
		end,
		subscribeToBoundInputsChanged = function(p41) -- line: 422
			-- upvalues: v63 (copy)
			return v63.boundInputsChangedSignal:subscribe(p41)
		end
	}
end

return t1
