local parent = script.Parent.Parent.Parent
local Cryo = require(parent.Cryo)

local createSignal = require(script.Parent.Parent.createSignal)

local MockEngine = {}
MockEngine.__index = MockEngine

local set = {
	[Enum.UserInputType.Gamepad1] = true,
	[Enum.UserInputType.Gamepad2] = true,
	[Enum.UserInputType.Gamepad3] = true,
	[Enum.UserInputType.Gamepad4] = true,
	[Enum.UserInputType.Gamepad5] = true,
	[Enum.UserInputType.Gamepad6] = true,
	[Enum.UserInputType.Gamepad7] = true,
	[Enum.UserInputType.Gamepad8] = true,
	[Enum.UserInputType.Keyboard] = true
}

local v = {
	Enum.KeyCode.Thumbstick2,
	Enum.KeyCode.DPadDown,
	Enum.KeyCode.DPadUp,
	Enum.KeyCode.ButtonL3,
	Enum.KeyCode.ButtonL2,
	Enum.KeyCode.DPadRight,
	Enum.KeyCode.ButtonR1,
	Enum.KeyCode.ButtonSelect,
	Enum.KeyCode.ButtonStart,
	Enum.KeyCode.ButtonY,
	Enum.KeyCode.DPadLeft,
	Enum.KeyCode.ButtonR2,
	Enum.KeyCode.ButtonR3,
	Enum.KeyCode.ButtonX,
	Enum.KeyCode.Thumbstick1,
	Enum.KeyCode.ButtonB,
	Enum.KeyCode.ButtonA,
	Enum.KeyCode.ButtonL1
}

local v2 = {
	[Enum.KeyCode.DPadUp] = "NextSelectionUp",
	[Enum.KeyCode.Up] = "NextSelectionUp",
	[Enum.KeyCode.DPadDown] = "NextSelectionDown",
	[Enum.KeyCode.Down] = "NextSelectionDown",
	[Enum.KeyCode.DPadLeft] = "NextSelectionLeft",
	[Enum.KeyCode.Left] = "NextSelectionLeft",
	[Enum.KeyCode.DPadRight] = "NextSelectionRight",
	[Enum.KeyCode.Right] = "NextSelectionRight"
}

local function defaultInputObject(keyCode) -- 1 equivalent call inferred from this helper
	return {
		KeyCode = keyCode,
		Delta = Vector3.new(),
		Position = Vector3.new(),
		UserInputType = Enum.UserInputType.Gamepad1,
		UserInputState = Enum.UserInputState.End
	}
end

local function wrapDisconnector(disconnect) -- 7 equivalent calls inferred from this helper
	return { Disconnect = disconnect }
end

function MockEngine.new()
	local object = setmetatable({
		__mockSelected = nil,
		__connectedGamepads = {},
		__gamepadStates = {},
		__selectionChangedSignal = createSignal(),
		__inputSignal = createSignal(),
		__renderStepped = createSignal(),
		__gamepadConnected = createSignal(),
		__gamepadDisconnected = createSignal(),
		__interface = nil
	}, MockEngine)

	local interface = {
		getSelection = function()
			return object.__mockSelected
		end,
		setSelection = function(mockSelected)
			object.__mockSelected = mockSelected

			object.__selectionChangedSignal:fire()
		end,
		getGamepadConnected = function(p)
			return object.__connectedGamepads[p] or false
		end,
		getGamepadState = function(p)
			if object.__gamepadStates[p] == nil then
				object:__initializeGamepadState(p)
			end

			return object.__gamepadStates[p]
		end,
		getNavigationGamepads = function(_)
			return Cryo.Dictionary.keys(object.__connectedGamepads)
		end,
		subscribeToSelectionChanged = function(p)
			return wrapDisconnector(object.__selectionChangedSignal:subscribe(p)) -- inferred equivalent call
		end,
		subscribeToInputBegan = function(p)
			return wrapDisconnector(object.__inputSignal:subscribe(p)) -- inferred equivalent call
		end,
		subscribeToInputChanged = function(p)
			return wrapDisconnector(object.__inputSignal:subscribe(p)) -- inferred equivalent call
		end,
		subscribeToInputEnded = function(p)
			return wrapDisconnector(object.__inputSignal:subscribe(p)) -- inferred equivalent call
		end,
		subscribeToRenderStepped = function(p)
			return wrapDisconnector(object.__renderStepped:subscribe(p)) -- inferred equivalent call
		end,
		subscribeToGamepadConnected = function(p)
			return wrapDisconnector(object.__gamepadConnected:subscribe(p)) -- inferred equivalent call
		end,
		subscribeToGamepadDisconnected = function(p)
			return wrapDisconnector(object.__gamepadDisconnected:subscribe(p)) -- inferred equivalent call
		end
	}

	object.__interface = interface

	return object, interface
end

function MockEngine:__initializeGamepadState(p)
	self.__gamepadStates[p] = Cryo.List.map(v, function(keyCode)
		return defaultInputObject(keyCode) -- inferred equivalent call
	end)
end

function MockEngine:simulateSelectionChanged(mockSelected)
	self.__mockSelected = mockSelected
	self.__selectionChangedSignal:fire()
end

function MockEngine:simulateInput(p)
	local joined = Cryo.Dictionary.join(
		{
			Delta = Vector3.new(),
			Position = Vector3.new(),
			UserInputType = Enum.UserInputType.Gamepad1
		},
		p
	)

	local v3 = typeof(joined.KeyCode) == "EnumItem" and joined.KeyCode.EnumType == Enum.KeyCode
	assert(v3, "Invalid inputObject.KeyCode: expected a member of Enum.KeyCode")

	assert(set[joined.UserInputType], "Invalid inputObject.UserInputType")

	local keyCode = joined.KeyCode
	local v4 = v2[keyCode]

	if v4 ~= nil and self.__interface.getSelection() ~= nil then
		self.__interface.setSelection(self.__interface.getSelection()[v4])
	end

	if joined.UserInputType ~= Enum.UserInputType.Keyboard then
		local userInputType = joined.UserInputType

		if not self.__connectedGamepads[userInputType] then
			self:connectGamepad(userInputType)
		end

		local __gamepadState = self.__gamepadStates[userInputType]
		local where = Cryo.List.findWhere(__gamepadState, function(p2): boolean
			return p2.KeyCode == keyCode
		end)

		if where == nil then
			error(
				("Invalid InputObject: KeyCode %s is not possible on %s"):format(
					tostring(keyCode),
					(tostring(userInputType))
				),
				2
			)
		end

		for k, v5 in pairs(joined) do
			__gamepadState[where][k] = v5
		end
	end

	self.__inputSignal:fire(joined)
end

function MockEngine:renderStep(p)
	local v3 = p == nil and 1 / 30 or p

	self.__renderStepped:fire(v3)
end

function MockEngine:connectGamepad(p)
	local v3 = typeof(p) == "EnumItem" and p.EnumType == Enum.UserInputType
	assert(v3, "Invalid argument #1: expected a member of Enum.UserInputType")

	self.__connectedGamepads[p] = true
	self:__initializeGamepadState(p)

	self.__gamepadConnected:fire(p)
end

function MockEngine:disconnectGamepad(p)
	local v3 = typeof(p) == "EnumItem" and p.EnumType == Enum.UserInputType
	assert(v3, "Invalid argument #1: expected a member of Enum.UserInputType")

	self.__connectedGamepads[p] = nil
	self.__gamepadDisconnected:fire(p)
end

return MockEngine
