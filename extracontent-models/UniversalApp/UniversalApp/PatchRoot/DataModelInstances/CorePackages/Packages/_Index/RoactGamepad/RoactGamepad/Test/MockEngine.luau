local ParentParent = script.Parent.Parent.Parent
local Cryo = require(ParentParent.Cryo)
local createSignal = require(script.Parent.Parent.createSignal)
local t1 = {}

t1.__index = t1

local t2 = {
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
local t3 = {
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
local t4 = {
	[Enum.KeyCode.DPadUp] = "NextSelectionUp",
	[Enum.KeyCode.Up] = "NextSelectionUp",
	[Enum.KeyCode.DPadDown] = "NextSelectionDown",
	[Enum.KeyCode.Down] = "NextSelectionDown",
	[Enum.KeyCode.DPadLeft] = "NextSelectionLeft",
	[Enum.KeyCode.Left] = "NextSelectionLeft",
	[Enum.KeyCode.DPadRight] = "NextSelectionRight",
	[Enum.KeyCode.Right] = "NextSelectionRight"
}

local function defaultInputObject(p1) -- line: 53
	return {
		KeyCode = p1,
		Delta = Vector3.new(),
		Position = Vector3.new(),
		UserInputType = Enum.UserInputType.Gamepad1,
		UserInputState = Enum.UserInputState.End
	}
end
local function wrapDisconnector(p2) -- line: 64
	return {
		Disconnect = p2
	}
end

function t1.new() -- line: 70
	-- upvalues: createSignal (copy), t1 (copy), Cryo (copy)
	local v12 = setmetatable({
		__mockSelected = nil,
		__interface = nil,
		__connectedGamepads = {},
		__gamepadStates = {},
		__selectionChangedSignal = createSignal(),
		__inputSignal = createSignal(),
		__renderStepped = createSignal(),
		__gamepadConnected = createSignal(),
		__gamepadDisconnected = createSignal()
	}, t1)
	local t5 = {
		getSelection = function() -- line: 88
			-- upvalues: v12 (copy)
			return v12.__mockSelected
		end,
		setSelection = function(p3) -- line: 91
			-- upvalues: v12 (copy)
			v12.__mockSelected = p3
			v12.__selectionChangedSignal:fire()
		end,
		getGamepadConnected = function(p4) -- line: 97
			-- upvalues: v12 (copy)
			return v12.__connectedGamepads[p4] or false
		end,
		getGamepadState = function(p5) -- line: 100
			-- upvalues: v12 (copy)
			if v12.__gamepadStates[p5] == nil then
				v12:__initializeGamepadState(p5)
			end

			return v12.__gamepadStates[p5]
		end,
		getNavigationGamepads = function(_) -- line: 109
			-- upvalues: Cryo (copy), v12 (copy)
			return Cryo.Dictionary.keys(v12.__connectedGamepads)
		end,
		subscribeToSelectionChanged = function(p7) -- line: 112
			-- upvalues: v12 (copy)
			return {
				Disconnect = v12.__selectionChangedSignal:subscribe(p7)
			}
		end,
		subscribeToInputBegan = function(p8) -- line: 117
			-- upvalues: v12 (copy)
			return {
				Disconnect = v12.__inputSignal:subscribe(p8)
			}
		end,
		subscribeToInputChanged = function(p9) -- line: 122
			-- upvalues: v12 (copy)
			return {
				Disconnect = v12.__inputSignal:subscribe(p9)
			}
		end,
		subscribeToInputEnded = function(p10) -- line: 127
			-- upvalues: v12 (copy)
			return {
				Disconnect = v12.__inputSignal:subscribe(p10)
			}
		end,
		subscribeToRenderStepped = function(p11) -- line: 132
			-- upvalues: v12 (copy)
			return {
				Disconnect = v12.__renderStepped:subscribe(p11)
			}
		end,
		subscribeToGamepadConnected = function(p12) -- line: 137
			-- upvalues: v12 (copy)
			return {
				Disconnect = v12.__gamepadConnected:subscribe(p12)
			}
		end,
		subscribeToGamepadDisconnected = function(p13) -- line: 142
			-- upvalues: v12 (copy)
			return {
				Disconnect = v12.__gamepadDisconnected:subscribe(p13)
			}
		end
	}

	v12.__interface = t5

	return v12, t5
end
function t1.__initializeGamepadState(p14, p15) -- line: 154
	-- upvalues: Cryo (copy), t3 (copy)
	p14.__gamepadStates[p15] = Cryo.List.map(t3, function(p16) -- line: 155
		return {
			KeyCode = p16,
			Delta = Vector3.new(),
			Position = Vector3.new(),
			UserInputType = Enum.UserInputType.Gamepad1,
			UserInputState = Enum.UserInputState.End
		}
	end)
end
function t1.simulateSelectionChanged(p17, p18) -- line: 160
	p17.__mockSelected = p18
	p17.__selectionChangedSignal:fire()
end
function t1.simulateInput(p19, p20) -- line: 165
	-- upvalues: Cryo (copy), t2 (copy), t4 (copy)
	local v20 = Cryo.Dictionary.join({
		Delta = Vector3.new(),
		Position = Vector3.new(),
		UserInputType = Enum.UserInputType.Gamepad1
	}, p20)

	assert(typeof(v20.KeyCode) == "EnumItem" and v20.KeyCode.EnumType == Enum.KeyCode, "Invalid inputObject.KeyCode: expected a member of Enum.KeyCode")
	assert(t2[v20.UserInputType], "Invalid inputObject.UserInputType")

	local KeyCode = v20.KeyCode
	local v22 = t4[KeyCode]

	if v22 ~= nil and p19.__interface.getSelection() ~= nil then
		p19.__interface.setSelection(p19.__interface.getSelection()[v22])
	end

	if v20.UserInputType ~= Enum.UserInputType.Keyboard then
		local UserInputType = v20.UserInputType

		if not p19.__connectedGamepads[UserInputType] then
			p19:connectGamepad(UserInputType)
		end

		local v24 = p19.__gamepadStates[UserInputType]
		local v25 = Cryo.List.findWhere(v24, function(p21) -- line: 201
			-- upvalues: KeyCode (copy)
			return p21.KeyCode == KeyCode
		end)

		if v25 == nil then
			error(("Invalid InputObject: KeyCode %s is not possible on %s"):format(tostring(KeyCode), (tostring(UserInputType))), 2)
		end

		for k, v in pairs(v20) do
			v24[v25][k] = v
		end
	end

	p19.__inputSignal:fire(v20)
end
function t1.renderStep(p22, p23) -- line: 222
	if p23 == nil then
		p23 = 0.03333333333333333
	end

	p22.__renderStepped:fire(p23)
end
function t1.connectGamepad(p24, p25) -- line: 230
	assert(typeof(p25) == "EnumItem" and p25.EnumType == Enum.UserInputType, "Invalid argument #1: expected a member of Enum.UserInputType")
	p24.__connectedGamepads[p25] = true
	p24:__initializeGamepadState(p25)
	p24.__gamepadConnected:fire(p25)
end
function t1.disconnectGamepad(p26, p27) -- line: 242
	assert(typeof(p27) == "EnumItem" and p27.EnumType == Enum.UserInputType, "Invalid argument #1: expected a member of Enum.UserInputType")
	p26.__connectedGamepads[p27] = nil
	p26.__gamepadDisconnected:fire(p27)
end

return t1
