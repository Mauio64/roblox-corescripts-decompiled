local ParentParent = script.Parent.Parent
local EventPropagation = require(ParentParent.EventPropagation)
local FocusNavigationUtils = require(ParentParent.FocusNavigationUtils)
local createSignal = FocusNavigationUtils.createSignal
local shallowEqual = FocusNavigationUtils.shallowEqual
local getAncestors = FocusNavigationUtils.getAncestors
local mockableWarn = FocusNavigationUtils.mockableWarn
local isValidFocusTarget = require(script.Parent.isValidFocusTarget)

require(script.Parent.types)

local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 104
	-- upvalues: createSignal (copy), EventPropagation (copy), t1 (copy)
	local v11, v12 = createSignal({})
	local v13, v14 = createSignal(p1.getSelection())
	local v15 = setmetatable({
		_silentFocusTarget = nil,
		_silentBlurTarget = nil,
		_eventPropagationService = EventPropagation.new(),
		_engineInterface = p1,
		_eventMapByInstance = setmetatable({}, {
			__mode = "k"
		}),
		_focusBehaviorByInstance = setmetatable({}, {
			__mode = "k"
		}),
		_engineEventConnections = {},
		_fireActiveEventMapSignal = v12,
		_fireFocusedGuiObjectSignal = v14,
		activeEventMap = v11,
		focusedGuiObject = v13
	}, t1)

	v15:_connectToInputEvents()

	return v15
end
function t1._fireInputEvent(t2: {[any]: any}, p2, p3, b1: boolean?) -- line: 131
	local v20 = t2.activeEventMap:getValue()[p3.KeyCode]

	if v20 then
		t2._eventPropagationService:propagateEvent(p2, v20, {
			Delta = p3.Delta,
			KeyCode = p3.KeyCode,
			Position = p3.Position,
			UserInputState = p3.UserInputState,
			UserInputType = p3.UserInputType,
			wasProcessed = b1
		}, {
			synthetic = false,
			silent = false
		})
	end
end
function t1._connectToInputEvents(p4) -- line: 149
	local function forwardInputEvent(p5, p6) -- line: 151
		-- upvalues: p4 (copy)
		local v106 = p4._engineInterface.getSelection()

		if v106 then
			p4:_fireInputEvent(v106, p5, p6)
		end
	end

	table.insert(p4._engineEventConnections, p4._engineInterface.InputBegan:Connect(forwardInputEvent))
	table.insert(p4._engineEventConnections, p4._engineInterface.InputChanged:Connect(forwardInputEvent))
	table.insert(p4._engineEventConnections, p4._engineInterface.InputEnded:Connect(forwardInputEvent))

	local function onFocusChanged() -- line: 162
		-- upvalues: p4 (copy)
		local v107 = p4.focusedGuiObject:getValue()
		local v108 = p4._engineInterface.getSelection()

		if v107 then
			local v109 = v107 == p4._silentBlurTarget

			p4._eventPropagationService:propagateEvent(v107, "blur", nil, {
				synthetic = false,
				silent = v109
			})
			p4._silentBlurTarget = nil
		end

		p4._fireFocusedGuiObjectSignal(v108)

		if v108 then
			local v110 = v108 == p4._silentFocusTarget

			p4._eventPropagationService:propagateEvent(v108, "focus", nil, {
				synthetic = false,
				silent = v110
			})
			p4._silentFocusTarget = nil
		end

		p4:_updateActiveEventMap(v107)
	end

	table.insert(p4._engineEventConnections, p4._engineInterface.SelectionChanged:Connect(onFocusChanged))
end
function t1._cancelHandler(p7, p8, p9) -- line: 189
	if p9 ~= "blur" and p9 ~= "focus" then
		p7._eventPropagationService:propagateEvent(p8, p9, {
			KeyCode = Enum.KeyCode.Unknown,
			UserInputType = Enum.UserInputType.None,
			UserInputState = Enum.UserInputState.Cancel
		}, {
			synthetic = false,
			silent = false
		})
	end
end
function t1._updateActiveEventMap(t3: {[any]: any}, p10) -- line: 202
	-- upvalues: getAncestors (copy), shallowEqual (copy)
	local t4 = {}
	local v30 = t3._engineInterface.getSelection()

	if v30 then
		local v31 = getAncestors(v30)
		local t5 = {}

		for i = #v31, 1, -1 do
			local v34 = v31[i]
			local v35 = t3._eventMapByInstance[v34]

			if v35 then
				for v36, v37 in v35 do
					t5[v36] = v37
					t4[v36] = nil
				end
			end

			local v38 = t3._eventPropagationService:getRegisteredEventHandlers(v34)

			if v38 then
				for v39, v40 in t5 do
					if v38[v40] then
						t4[v39] = v40
					end
				end
			end
		end
	end

	local v41 = t3.activeEventMap:getValue()

	if not shallowEqual(v41, t4) then
		if p10 then
			for v42, v43 in v41 do
				if not t4[v42] then
					t3:_cancelHandler(p10, v43)
				end
			end
		end

		t3._fireActiveEventMapSignal(t4)
	end
end
function t1.registerEventMap(t6: {[any]: any}, p11, p12) -- line: 246
	-- upvalues: mockableWarn (copy)
	local v47 = t6._eventMapByInstance[p11] or {}

	for v48, v49 in p12 do
		if v47[v48] and v49 ~= v47[v48] and _G.__DEV__ then
			mockableWarn(string.format("New event will replace existing registered event mapped to %s:\n\t     new event: %s\n\texisting event: %s", tostring(v48), v49, v47[v48]))
		end

		v47[v48] = v49
	end

	t6._eventMapByInstance[p11] = v47
	t6:_updateActiveEventMap()
end
function t1.deregisterEventMap(t7: {[any]: any}, p13, p14) -- line: 268
	-- upvalues: mockableWarn (copy)
	local v53 = t7._eventMapByInstance[p13] or {}

	for v54, v55 in p14 do
		if v55 == v53[v54] then
			v53[v54] = nil
		elseif _G.__DEV__ then
			mockableWarn(string.format("Cannot deregister non-matching event input %s:\n\t  provided event: %s\n\tregistered event: %s", tostring(v54), v55, v53[v54]))
		end
	end

	t7._eventMapByInstance[p13] = v53
	t7:_updateActiveEventMap(t7.focusedGuiObject:getValue())
end
function t1.registerEventHandler(t8: {[any]: any}, p15, s1: string, p16: ((...any) -> ...any), p17) -- line: 291
	t8._eventPropagationService:registerEventHandler(p15, s1, p16, p17)
	t8:_updateActiveEventMap()
end
function t1.deregisterEventHandler(t9: {[any]: any}, p18, s2: string, p19: ((...any) -> ...any), p20) -- line: 301
	t9:_cancelHandler(p18, s2)
	t9._eventPropagationService:deregisterEventHandler(p18, s2, p19, p20)
	t9:_updateActiveEventMap(t9.focusedGuiObject:getValue())
end
function t1.registerEventHandlers(t10: {[any]: any}, p21, p22) -- line: 314
	t10._eventPropagationService:registerEventHandlers(p21, p22)
	t10:_updateActiveEventMap()
end
function t1.deregisterEventHandlers(t11: {[any]: any}, p23, p24) -- line: 319
	for v72, _ in p24 do
		t11:_cancelHandler(p23, v72)
	end

	t11._eventPropagationService:deregisterEventHandlers(p23, p24)
	t11:_updateActiveEventMap(t11.focusedGuiObject:getValue())
end
function t1.registerFocusBehavior(t12: {[any]: any}, p25, p26) -- line: 330
	-- upvalues: mockableWarn (copy), isValidFocusTarget (copy)
	if _G.__DEV__ then
		local v77 = t12._focusBehaviorByInstance[p25]

		if v77 ~= nil then
			mockableWarn(string.format("New focus behavior will replace existing registered focus behavior:\n\t     new behavior: %s\n\texisting behavior: %s", tostring(p26), (tostring(v77.behavior))))
		end
	end

	local t13 = {
		behavior = p26,
		connection = p25.SelectionChanged:Connect(function(p27, p28, p29) -- line: 346
			-- upvalues: p25 (copy), p26 (copy), isValidFocusTarget (copy), t12 (copy)
			if p29 and (p27 or p29:IsDescendantOf(p25)) then
				if not p28 or not p28:IsDescendantOf(p25) then
					local v114 = false

					for _, v116 in p26.getTargets() do
						if isValidFocusTarget(v116) then
							t12:focusGuiObject(v116, false)
							v114 = true

							break
						end
					end

					if not v114 and p26.onDescendantFocusChanged then
						p26.onDescendantFocusChanged(p29)

						return
					end
				elseif p26.onDescendantFocusChanged then
					p26.onDescendantFocusChanged(p29)
				end
			end
		end)
	}

	t12._focusBehaviorByInstance[p25] = t13
end
function t1.deregisterFocusBehavior(t14: {[any]: any}, p30, p31) -- line: 384
	-- upvalues: mockableWarn (copy)
	local v82 = t14._focusBehaviorByInstance[p30]

	if _G.__DEV__ then
		if not v82 then
			mockableWarn(string.format("Cannot deregister an unregistered focus behavior:\n\t  provided behavior: %s", (tostring(p31))))
		end

		if v82 and p31 ~= v82.behavior then
			mockableWarn(string.format("Cannot deregister non-matching focus behavior:\n\t  provided behavior: %s\n\tregistered behavior: %s", tostring(p31), (tostring(v82.behavior))))
		end
	end

	if v82 then
		v82.connection:Disconnect()
		t14._focusBehaviorByInstance[p30] = nil
	end
end
function t1.focusGuiObject(t15: {[any]: any}, p32, b2: boolean) -- line: 413
	if b2 then
		t15._silentBlurTarget = t15._engineInterface.getSelection()
		t15._silentFocusTarget = p32
	else
		t15._silentBlurTarget = nil
		t15._silentFocusTarget = nil
	end

	t15._engineInterface.setSelection(p32)
end
function t1.teardown(p33) -- line: 428
	for _, v88 in p33._engineEventConnections do
		v88:Disconnect()
	end

	for _, v90 in p33._focusBehaviorByInstance do
		v90.connection:Disconnect()
	end
end
function t1.canDispatchEvent(t16: {[any]: any}, s3: string, p34) -- line: 437
	-- upvalues: getAncestors (copy)
	if not p34 then
		return false
	end

	for _, v95 in (getAncestors(p34)) do
		local v96 = t16._eventMapByInstance[v95]

		if v96 then
			for _, v98 in v96 do
				if v98 ~= s3 then
					continue
				end

				local v99 = t16._eventPropagationService:getRegisteredEventHandlers(v95)

				if v99 and v99[s3] then
					return true
				end
			end
		end
	end

	return false
end
function t1.dispatchSyntheticEvent(t17: {[any]: any}, s4: string, p35, p36) -- line: 462
	-- upvalues: mockableWarn (copy)
	if not p35 then
		if _G.__DEV__ then
			mockableWarn("dispatchSyntheticEvent: No target object")
		end

		return false
	end

	if not t17:canDispatchEvent(s4, p35) then
		if _G.__DEV__ then
			mockableWarn("dispatchSyntheticEvent: Cannot dispatch event \"" .. s4 .. "\" on target")
		end

		return false
	end

	t17._eventPropagationService:propagateEvent(p35, s4, p36, {
		synthetic = true,
		silent = false
	})

	return true
end

return t1
