local debugPrint = require(script.Parent.debugPrint)
local InputBindingKind = require(script.Parent.InputBindingKind)
local Config = require(script.Parent.Config)
local t1 = {
	[Enum.UserInputType.Keyboard] = true,
	[Enum.UserInputType.Gamepad1] = true,
	[Enum.UserInputType.Gamepad2] = true,
	[Enum.UserInputType.Gamepad3] = true,
	[Enum.UserInputType.Gamepad4] = true,
	[Enum.UserInputType.Gamepad5] = true,
	[Enum.UserInputType.Gamepad6] = true,
	[Enum.UserInputType.Gamepad7] = true,
	[Enum.UserInputType.Gamepad8] = true
}
local t2 = {}

local function initializeEngineGamepadState() -- line: 26
	return {
		gamepadConnectedConnection = nil,
		gamepadDisconnectedConnection = nil,
		onStepConnections = 0,
		primaryGamepadState = {}
	}
end
local function getEngineState(p1) -- line: 35
	-- upvalues: t2 (copy)
	if t2[p1] == nil then
		t2[p1] = {
			gamepadConnectedConnection = nil,
			gamepadDisconnectedConnection = nil,
			onStepConnections = 0,
			primaryGamepadState = {}
		}
	end

	return t2[p1]
end
local function updatePrimaryGamepad(p2) -- line: 43
	-- upvalues: t2 (copy)
	if t2[p2] == nil then
		t2[p2] = {
			gamepadConnectedConnection = nil,
			gamepadDisconnectedConnection = nil,
			onStepConnections = 0,
			primaryGamepadState = {}
		}
	end

	local v20 = t2[p2]
	local Gamepad1 = Enum.UserInputType.Gamepad1

	for _, v in ipairs(p2.getNavigationGamepads()) do
		if p2.getGamepadConnected(v) then
			Gamepad1 = v

			break
		end
	end

	local v24 = p2.getGamepadState(Gamepad1)

	v20.primaryGamepadState = {}

	for _, v in ipairs(v24) do
		v20.primaryGamepadState[v.KeyCode] = v
	end
end
local function getInputEvent(p3, p4) -- line: 64
	-- upvalues: debugPrint (copy)
	return function(p5) -- line: 65
		-- upvalues: p4 (copy), debugPrint (copy), p3 (copy)
		if p4(p5) then
			debugPrint("[EVENT] Process input: ", p5.KeyCode, "-", p5.UserInputState)
			p3(p5)
		end
	end
end
local function wrapWithGamepadStateListener(p6, p7) -- line: 73
	-- upvalues: t2 (copy), updatePrimaryGamepad (copy)
	if t2[p6] == nil then
		t2[p6] = {
			gamepadConnectedConnection = nil,
			gamepadDisconnectedConnection = nil,
			onStepConnections = 0,
			primaryGamepadState = {}
		}
	end

	local v31 = t2[p6]

	if v31.onStepConnections == 0 then
		updatePrimaryGamepad(p6)
		v31.gamepadConnectedConnection = p6.subscribeToGamepadConnected(function() -- line: 78
			-- upvalues: updatePrimaryGamepad (copy), p6 (copy)
			updatePrimaryGamepad(p6)
		end)
		v31.gamepadDisconnectedConnection = p6.subscribeToGamepadDisconnected(function() -- line: 81
			-- upvalues: updatePrimaryGamepad (copy), p6 (copy)
			updatePrimaryGamepad(p6)
		end)
	end

	v31.onStepConnections = v31.onStepConnections + 1

	return function() -- line: 87
		-- upvalues: p7 (copy), v31 (copy)
		p7:Disconnect()
		v31.onStepConnections = v31.onStepConnections - 1

		if v31.onStepConnections == 0 then
			v31.gamepadConnectedConnection:Disconnect()
			v31.gamepadConnectedConnection = nil
			v31.gamepadDisconnectedConnection:Disconnect()
			v31.gamepadDisconnectedConnection = nil
		end
	end
end
local function makeInputBinding(p8) -- line: 167
	return function(p9, p10, p11) -- line: 168
		-- upvalues: p8 (copy)
		assert(typeof(p9) == "EnumItem" and p9.EnumType == Enum.KeyCode, "Invalid argument #1: expected a member of Enum.KeyCode")
		assert(typeof(p10) == "function", "Invalid argument #2: expected a function")

		return {
			kind = p8,
			keyCode = p9,
			action = p10,
			meta = p11
		}
	end
end
local function onMoveStepInputBinding(p12) -- line: 184
	-- upvalues: InputBindingKind (copy)
	return {
		kind = InputBindingKind.MoveStep,
		action = p12
	}
end

local t4 = {
	getUniqueKey = function(p13) -- line: 191
		if p13.keyCode then
			return tostring(p13.kind) .. "-" .. tostring(p13.keyCode)
		end

		return (tostring(p13.kind))
	end,
	connectToEvent = function(p14, p15) -- line: 101
		-- upvalues: Config (copy), InputBindingKind (copy), t1 (copy), debugPrint (copy), t2 (copy), wrapWithGamepadStateListener (copy)
		local function matchesBindingKeyCode(p16) -- line: 102
			-- upvalues: Config (copy), p14 (copy)
			if Config.DebugKeyboardBindings then
				local v61 = Config.DebugKeyboardBindings[p14.keyCode] or {}

				if table.find(v61, p16.KeyCode) then
					return true
				end
			end

			return p16.KeyCode == p14.keyCode
		end

		if p14.kind == InputBindingKind.Begin then
			local function matchInput(p17) -- line: 114
				-- upvalues: t1 (copy), Config (copy), p14 (copy)
				local v63 = t1[p17.UserInputType]

				if v63 then
					v63 = false

					if p17.UserInputState == Enum.UserInputState.Begin then
						if Config.DebugKeyboardBindings then
							local v64 = Config.DebugKeyboardBindings[p14.keyCode] or {}

							if table.find(v64, p17.KeyCode) then
								return true
							end
						end

						v63 = p17.KeyCode == p14.keyCode
					end
				end

				return v63
			end

			local subscribeToInputBegan = p15.subscribeToInputBegan
			local action = p14.action
			local v38 = subscribeToInputBegan(function(p18) -- line: 65
				-- upvalues: matchInput (copy), debugPrint (copy), action (copy)
				if matchInput(p18) then
					debugPrint("[EVENT] Process input: ", p18.KeyCode, "-", p18.UserInputState)
					action(p18)
				end
			end)

			return function() -- line: 122
				-- upvalues: v38 (copy)
				v38:Disconnect()
			end
		end

		if p14.kind == InputBindingKind.End then
			local function matchInput(p19) -- line: 126
				-- upvalues: t1 (copy), Config (copy), p14 (copy)
				local v67 = t1[p19.UserInputType]

				if v67 then
					v67 = false

					if p19.UserInputState == Enum.UserInputState.End then
						if Config.DebugKeyboardBindings then
							local v68 = Config.DebugKeyboardBindings[p14.keyCode] or {}

							if table.find(v68, p19.KeyCode) then
								return true
							end
						end

						v67 = p19.KeyCode == p14.keyCode
					end
				end

				return v67
			end

			local subscribeToInputEnded = p15.subscribeToInputEnded
			local action = p14.action
			local v42 = subscribeToInputEnded(function(p20) -- line: 65
				-- upvalues: matchInput (copy), debugPrint (copy), action (copy)
				if matchInput(p20) then
					debugPrint("[EVENT] Process input: ", p20.KeyCode, "-", p20.UserInputState)
					action(p20)
				end
			end)

			return function() -- line: 134
				-- upvalues: v42 (copy)
				v42:Disconnect()
			end
		end

		if p14.kind == InputBindingKind.Step then
			if t2[p15] == nil then
				t2[p15] = {
					gamepadConnectedConnection = nil,
					gamepadDisconnectedConnection = nil,
					onStepConnections = 0,
					primaryGamepadState = {}
				}
			end

			local v43 = t2[p15]
			local v44 = p15.subscribeToRenderStepped(function(p21) -- line: 140
				-- upvalues: p14 (copy), v43 (copy)
				p14.action(v43.primaryGamepadState[p14.keyCode], p21)
			end)

			return (wrapWithGamepadStateListener(p15, v44))
		end

		if p14.kind == InputBindingKind.MoveStep then
			if t2[p15] == nil then
				t2[p15] = {
					gamepadConnectedConnection = nil,
					gamepadDisconnectedConnection = nil,
					onStepConnections = 0,
					primaryGamepadState = {}
				}
			end

			local v45 = t2[p15]
			local v46 = p15.subscribeToRenderStepped(function(p22) -- line: 149
				-- upvalues: v45 (copy), p14 (copy)
				local t3 = {
					[Enum.KeyCode.Thumbstick1] = v45.primaryGamepadState[Enum.KeyCode.Thumbstick1],
					[Enum.KeyCode.DPadUp] = v45.primaryGamepadState[Enum.KeyCode.DPadUp],
					[Enum.KeyCode.DPadDown] = v45.primaryGamepadState[Enum.KeyCode.DPadDown],
					[Enum.KeyCode.DPadLeft] = v45.primaryGamepadState[Enum.KeyCode.DPadLeft],
					[Enum.KeyCode.DPadRight] = v45.primaryGamepadState[Enum.KeyCode.DPadRight]
				}

				p14.action(t3, p22)
			end)

			return (wrapWithGamepadStateListener(p15, v46))
		end

		return nil
	end
}
local t5 = {}
local Begin = InputBindingKind.Begin

function t5.onBegin(p23, p24, p25) -- line: 168
	-- upvalues: Begin (copy)
	assert(typeof(p23) == "EnumItem" and p23.EnumType == Enum.KeyCode, "Invalid argument #1: expected a member of Enum.KeyCode")
	assert(typeof(p24) == "function", "Invalid argument #2: expected a function")

	return {
		kind = Begin,
		keyCode = p23,
		action = p24,
		meta = p25
	}
end

local End = InputBindingKind.End

function t5.onEnd(p26, p27, p28) -- line: 168
	-- upvalues: End (copy)
	assert(typeof(p26) == "EnumItem" and p26.EnumType == Enum.KeyCode, "Invalid argument #1: expected a member of Enum.KeyCode")
	assert(typeof(p27) == "function", "Invalid argument #2: expected a function")

	return {
		kind = End,
		keyCode = p26,
		action = p27,
		meta = p28
	}
end

local Step = InputBindingKind.Step

function t5.onStep(p29, p30, p31) -- line: 168
	-- upvalues: Step (copy)
	assert(typeof(p29) == "EnumItem" and p29.EnumType == Enum.KeyCode, "Invalid argument #1: expected a member of Enum.KeyCode")
	assert(typeof(p30) == "function", "Invalid argument #2: expected a function")

	return {
		kind = Step,
		keyCode = p29,
		action = p30,
		meta = p31
	}
end

t5.onMoveStep = onMoveStepInputBinding
t4.PublicInterface = t5

return t4
