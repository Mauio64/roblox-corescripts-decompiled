local debugPrint = require(script.Parent.debugPrint)
local InputBindingKind = require(script.Parent.InputBindingKind)
local Config = require(script.Parent.Config)

local set = {
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

local v = {}

local function initializeEngineGamepadState() -- 1 equivalent call inferred from this helper
	return {
		gamepadConnectedConnection = nil,
		gamepadDisconnectedConnection = nil,
		onStepConnections = 0,
		primaryGamepadState = {}
	}
end

local function getEngineState(p) -- 4 equivalent calls inferred from this helper
	if v[p] == nil then
		v[p] = initializeEngineGamepadState() -- inferred equivalent call
	end

	return v[p]
end

local function updatePrimaryGamepad(data)
	local engineState = getEngineState(data) -- inferred equivalent call
	local v2 = Enum.UserInputType.Gamepad1

	for _, v3 in ipairs(data.getNavigationGamepads()) do
		if data.getGamepadConnected(v3) then
			v2 = v3
			break
		end
	end

	local gamepadState = data.getGamepadState(v2)

	engineState.primaryGamepadState = {}

	for _, v3 in ipairs(gamepadState) do
		engineState.primaryGamepadState[v3.KeyCode] = v3
	end
end

local function getInputEvent(action, matchInput) -- 2 equivalent calls inferred from this helper
	return function(p)
		if matchInput(p) then
			debugPrint("[EVENT] Process input: ", p.KeyCode, "-", p.UserInputState)
			action(p)
		end
	end
end

local function wrapWithGamepadStateListener(data, connection)
	local engineState = getEngineState(data) -- inferred equivalent call

	if engineState.onStepConnections == 0 then
		updatePrimaryGamepad(data)
		engineState.gamepadConnectedConnection = data.subscribeToGamepadConnected(function()
			updatePrimaryGamepad(data)
		end)
		engineState.gamepadDisconnectedConnection = data.subscribeToGamepadDisconnected(function()
			updatePrimaryGamepad(data)
		end)
	end

	engineState.onStepConnections += 1

	return function()
		connection:Disconnect()

		engineState.onStepConnections -= 1

		if engineState.onStepConnections == 0 then
			engineState.gamepadConnectedConnection:Disconnect()
			engineState.gamepadConnectedConnection = nil
			engineState.gamepadDisconnectedConnection:Disconnect()
			engineState.gamepadDisconnectedConnection = nil
		end
	end
end

local function makeInputBinding(kind) -- 3 equivalent calls inferred from this helper
	return function(keyCode, action, meta)
		local v2 = typeof(keyCode) == "EnumItem" and keyCode.EnumType == Enum.KeyCode
		assert(v2, "Invalid argument #1: expected a member of Enum.KeyCode")

		assert(typeof(action) == "function", "Invalid argument #2: expected a function")

		return { kind = kind, keyCode = keyCode, action = action, meta = meta }
	end
end

local function onMoveStepInputBinding(action)
	return { kind = InputBindingKind.MoveStep, action = action }
end

local Input = {}

function Input.getUniqueKey(p)
	if p.keyCode then
		return tostring(p.kind) .. "-" .. tostring(p.keyCode)
	end

	return (tostring(p.kind))
end

function Input.connectToEvent(data, data2)
	local function matchesBindingKeyCode(p): boolean
		if Config.DebugKeyboardBindings then
			local v2 = Config.DebugKeyboardBindings[data.keyCode] or {}

			if table.find(v2, p.KeyCode) then
				return true
			end
		end

		return p.KeyCode == data.keyCode
	end

	if data.kind == InputBindingKind.Begin then
		local function matchInput(data3)
			local v2 = set[data3.UserInputType]

			if not v2 then
				return v2
			end

			if data3.UserInputState == Enum.UserInputState.Begin then
				if Config.DebugKeyboardBindings then
					local v3 = Config.DebugKeyboardBindings[data.keyCode] or {}

					if table.find(v3, data3.KeyCode) then
						return true
					end
				end

				return data3.KeyCode == data.keyCode
			end

			return false
		end

		local connection = data2.subscribeToInputBegan(getInputEvent(data.action, matchInput)) -- inferred equivalent call

		return function()
			connection:Disconnect()
		end
	elseif data.kind == InputBindingKind.End then
		local function matchInput(data3)
			local v2 = set[data3.UserInputType]

			if not v2 then
				return v2
			end

			if data3.UserInputState == Enum.UserInputState.End then
				if Config.DebugKeyboardBindings then
					local v3 = Config.DebugKeyboardBindings[data.keyCode] or {}

					if table.find(v3, data3.KeyCode) then
						return true
					end
				end

				return data3.KeyCode == data.keyCode
			end

			return false
		end

		local connection = data2.subscribeToInputEnded(getInputEvent(data.action, matchInput)) -- inferred equivalent call

		return function()
			connection:Disconnect()
		end
	elseif data.kind == InputBindingKind.Step then
		local engineState = getEngineState(data2) -- inferred equivalent call
		return wrapWithGamepadStateListener(data2, data2.subscribeToRenderStepped(function(p)
			data.action(engineState.primaryGamepadState[data.keyCode], p)
		end))
	else
		if data.kind ~= InputBindingKind.MoveStep then
			return nil
		end

		local engineState = getEngineState(data2) -- inferred equivalent call
		return wrapWithGamepadStateListener(data2, data2.subscribeToRenderStepped(function(p)
			local v2 = {
				[Enum.KeyCode.Thumbstick1] = engineState.primaryGamepadState[Enum.KeyCode.Thumbstick1],
				[Enum.KeyCode.DPadUp] = engineState.primaryGamepadState[Enum.KeyCode.DPadUp],
				[Enum.KeyCode.DPadDown] = engineState.primaryGamepadState[Enum.KeyCode.DPadDown],
				[Enum.KeyCode.DPadLeft] = engineState.primaryGamepadState[Enum.KeyCode.DPadLeft],
				[Enum.KeyCode.DPadRight] = engineState.primaryGamepadState[Enum.KeyCode.DPadRight]
			}

			data.action(v2, p)
		end))
	end
end

Input.PublicInterface = {
	onBegin = makeInputBinding(InputBindingKind.Begin), -- inferred equivalent call
	onEnd = makeInputBinding(InputBindingKind.End), -- inferred equivalent call
	onStep = makeInputBinding(InputBindingKind.Step), -- inferred equivalent call
	onMoveStep = onMoveStepInputBinding
}
return Input
