local ParentParent = script.Parent.Parent
local Cryo = require(ParentParent.Cryo)
local FocusControllerInternalApi = require(script.Parent.FocusControllerInternalApi)
local inputBindingsEqual = require(script.Parent.inputBindingsEqual)
local debugPrint = require(script.Parent.debugPrint)
local Config = require(script.Parent.Config)
local t1 = {}

t1.__index = t1

function t1.new(p1, p2) -- line: 17
	-- upvalues: t1 (copy)
	local focusController = nil

	if p1.parentFocusNode ~= nil then
		focusController = p1.parentFocusNode.focusController
	elseif p1.focusController ~= nil then
		focusController = p1.focusController
	else
		error("Cannot create node without focus manager")
	end

	local v11 = setmetatable({
		lastFocused = nil,
		focusController = focusController,
		ref = p2
	}, t1)

	v11:updateNavProps(p1)

	return v11
end
function t1.__getFocusControllerInternal(p3) -- line: 40
	-- upvalues: FocusControllerInternalApi (copy)
	return p3.focusController[FocusControllerInternalApi]
end
function t1.__findDefaultChildNode(p4) -- line: 44
	local n1 = 1e999
	local v15 = nil
	local v16 = p4:__getFocusControllerInternal():getChildren(p4)
	local v17 = p4.ref:getValue()
	local g21 = nil
	local g22 = nil
	local LayoutOrder = nil

	for k, v in pairs(v16) do
		local v20 = k:getValue()

		repeat
			while g21 or true do
				if not g21 then
					if v20 == v17 or v20 == nil then
						g22 = true
					end

					if not g22 then
						if v20:isA("GuiObject") then
							break
						end
					end
				end

				if g22 then
					break
				end

				g21 = false
				v20 = v20.Parent
			end

			if g22 then
				break
			end

			LayoutOrder = v20.LayoutOrder

			if LayoutOrder == 0 then
				g21 = true
			end
		until not g21

		if not g22 then
			if LayoutOrder < n1 then
				n1 = LayoutOrder
				v15 = v
			end
		end

		g22 = false
	end

	if v15 ~= nil then
		return v15
	end

	for k, v in pairs(v16) do
		if k:getValue() ~= nil then
			return v
		end
	end

	return nil
end
function t1.updateNavProps(p5, p6) -- line: 98
	-- upvalues: inputBindingsEqual (copy)
	local v28 = p6.restorePreviousChildFocus ~= nil and p6.restorePreviousChildFocus
	local inputBindings = p5.inputBindings

	p5.defaultChildRef = p6.defaultChild
	p5.restorePreviousChildFocus = v28
	p5.inputBindings = p6.inputBindings or {}

	local v30 = p5:__getFocusControllerInternal()

	if v30:isNodeFocused(p5) and not inputBindingsEqual(inputBindings, p5.inputBindings) then
		v30:updateInputBindings()
	end
end
function t1.focus(p7) -- line: 116
	-- upvalues: Config (copy), Cryo (copy), debugPrint (copy)
	if not Config.Enabled then
		return
	end

	local v32 = p7:__getFocusControllerInternal()

	if not v32:isInitialized() then
		return
	end

	v32:setInProgressFocus(p7)

	local v33 = v32:getChildren(p7)

	if Cryo.isEmpty(v33) then
		v32:setSelection(p7.ref:getValue())

		return
	end

	local elapsed = os.clock()
	local v35 = p7.defaultChildRef ~= nil and (v32.allNodes[p7.defaultChildRef] ~= nil and p7.defaultChildRef:getValue() ~= nil)
	local v36 = p7.timeout == nil or elapsed < p7.timeout

	if p7.restorePreviousChildFocus and p7.lastFocused ~= nil and p7.lastFocused:getValue() then
		debugPrint("[FOCUS] Restore previous focus:", p7.lastFocused)
		v32:moveFocusTo(p7.lastFocused)

		return
	end

	if p7.defaultChildRef and (v36 or v35) then
		if v35 then
			debugPrint("[FOCUS] Found valid default child", p7.defaultChildRef, "for", p7.ref)
			p7.timeout = nil
			v32:moveFocusTo(p7.defaultChildRef)

			return
		end

		if p7.timeout == nil then
			debugPrint("[FOCUS] Default child specified is not valid. Wait for it to be assigned...")
			p7.timeout = elapsed + 0.5
		end

		task.delay(0, function() -- line: 155
			-- upvalues: v32 (copy), p7 (copy)
			if v32:isInProgressFocus(p7) then
				p7:focus()
			end
		end)

		return
	end

	if p7.timeout ~= nil then
		debugPrint("[FOCUS] Timeout for default child of", p7.ref)
		p7.timeout = nil
	end

	local v37 = p7:__findDefaultChildNode()

	if v37 ~= nil then
		debugPrint("[FOCUS] No default, use fallback logic to focus", v37.ref)
		v37:focus()

		return
	end

	v32:setFocusedLeaf(p7)
	v32:setInProgressFocus(nil)
end
function t1.attachToTree(p8, p9, p10) -- line: 180
	-- upvalues: Cryo (copy)
	local v41 = p8:__getFocusControllerInternal()

	v41:registerNode(p9, p8.ref, p8)
	p8.parent = p9
	p8.disconnectSelectionListener = v41:subscribeToSelectionChange(function() -- line: 185
		-- upvalues: v41 (copy), p8 (copy), p10 (copy), Cryo (copy)
		local v43 = v41:isNodeFocused(p8)

		p10(v43)

		if p8.parent ~= nil and v43 then
			p8.parent.lastFocused = p8.ref
		end

		local v44 = v41:getChildren(p8)

		if not Cryo.isEmpty(v44) and v43 and v41:getSelection() == p8.ref:getValue() then
			p8:focus()
		end
	end)
end
function t1.detachFromTree(p11) -- line: 209
	p11:__getFocusControllerInternal():deregisterNode(p11.parent, p11.ref)

	if p11.disconnectSelectionListener ~= nil then
		p11.disconnectSelectionListener()
		p11.disconnectSelectionListener = nil
	end
end

return t1
