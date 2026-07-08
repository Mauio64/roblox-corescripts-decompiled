local CorePackages = game:GetService("CorePackages")
local StarterGui = game:GetService("StarterGui")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal

require(CorePackages.Workspace.Packages.Chrome)

local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local t1 = {
	Unavailable = 0,
	Loading = 1,
	Available = 2,
	Pinned = 3
}
local t2 = {}

t2.__index = t2

function t2.new(n1: number) -- line: 28
	-- upvalues: t1 (copy), FFlagEnableConsoleExpControls (copy), Signal (copy), t2 (copy)
	return (setmetatable({
		_state = n1 or t1.Unavailable,
		_forceUnavailable = not FFlagEnableConsoleExpControls and nil,
		_changeSignal = Signal.new()
	}, t2))
end
function t2.connect(p1, p2) -- line: 37
	return p1._changeSignal:connect(p2)
end
function t2.set(t3: {[any]: any}, n2: number) -- line: 41
	-- upvalues: FFlagEnableConsoleExpControls (copy)
	if n2 ~= t3._state then
		t3._state = n2

		if not FFlagEnableConsoleExpControls or not t3._forceUnavailable then
			t3._changeSignal:fire(n2)
		end
	end
end
function t2.get(p3) -- line: 50
	-- upvalues: FFlagEnableConsoleExpControls (copy), t1 (copy)
	if FFlagEnableConsoleExpControls and p3._forceUnavailable then
		return t1.Unavailable
	end

	return p3._state
end
function t2.available(p4) -- line: 58
	-- upvalues: t1 (copy)
	p4:set(t1.Available)
end
function t2.loading(p5) -- line: 62
	-- upvalues: t1 (copy)
	p5:set(t1.Loading)
end
function t2.unavailable(p6) -- line: 66
	-- upvalues: t1 (copy)
	p6:set(t1.Unavailable)
end
function t2.pinned(p7) -- line: 70
	-- upvalues: t1 (copy)
	p7:set(t1.Pinned)
end
function t2.forceUnavailable(p8) -- line: 74
	-- upvalues: FFlagEnableConsoleExpControls (copy), t1 (copy)
	if FFlagEnableConsoleExpControls and not p8._forceUnavailable then
		p8._forceUnavailable = true

		if p8._state ~= t1.Unavailable then
			p8._changeSignal:fire(t1.Unavailable)
		end
	end
end
function t2.unforceUnavailable(p9) -- line: 84
	-- upvalues: FFlagEnableConsoleExpControls (copy), t1 (copy)
	if FFlagEnableConsoleExpControls and p9._forceUnavailable then
		p9._forceUnavailable = false

		if p9._state ~= t1.Unavailable then
			p9._changeSignal:fire(p9._state)
		end
	end
end

local t4 = {}

t4.__index = t4

function t4.new(b1: boolean?) -- line: 97
	-- upvalues: Signal (copy), t4 (copy)
	return (setmetatable({
		_value = {
			type = "empty",
			value = nil
		},
		_changeSignal = Signal.new(),
		_excludeFromTotalCounts = b1 or false
	}, t4))
end
function t4.setExcludeFromTotalCounts(t5: {[any]: any}, b2: boolean) -- line: 106
	t5._excludeFromTotalCounts = b2
end
function t4.excludeFromTotalCounts(p10) -- line: 110
	return p10._excludeFromTotalCounts
end
function t4.connect(t6: {[any]: any}, p11: ((...any) -> ...any)) -- line: 114
	return t6._changeSignal:connect(p11)
end
function t4.get(p12) -- line: 118
	return p12._value
end
function t4.clear(p13) -- line: 122
	if p13._value and p13._value.type ~= "empty" then
		p13._value = {
			type = "empty",
			value = nil
		}
		p13._changeSignal:fire(p13._value)
	end
end
function t4.fireCount(t7: {[any]: any}, n3: number) -- line: 129
	local t8 = {
		type = "count",
		value = n3
	}

	if t8 ~= t7._value then
		t7._value = t8
		t7._changeSignal:fire(t7._value)
	end
end
function t4.isEmpty(p14) -- line: 137
	return p14._value and p14._value.type == "empty"
end

local t9 = {}

t9.__index = t9

function t9.new(p15) -- line: 146
	-- upvalues: Signal (copy), t9 (copy)
	return (setmetatable({
		_value = p15,
		_changeSignal = Signal.new()
	}, t9))
end
function t9.get(p16) -- line: 153
	return p16._value
end
function t9.setMomentary(p17, p18, n4: number, p19) -- line: 157
	if p18 ~= p17._value then
		p17._value = p18
		p17._changeSignal:fire(p18)
	end

	local _momentaryClearThread = p17._momentaryClearThread

	if _momentaryClearThread then
		task.cancel(_momentaryClearThread)
	end

	p17._momentaryClearThread = task.delay(n4, function() -- line: 169
		-- upvalues: p17 (copy), p19 (copy)
		p17._momentaryClearThread = nil
		p17.set(p17, p19)
	end)
end
function t9.set(p20, p21) -- line: 176
	local _momentaryClearThread = p20._momentaryClearThread

	if _momentaryClearThread then
		task.cancel(_momentaryClearThread)
		p20._momentaryClearThread = nil
	end

	if p21 ~= p20._value then
		p20._value = p21
		p20._changeSignal:fire(p21)
	end
end
function t9.signal(p22) -- line: 189
	return p22._changeSignal
end
function t9.connect(p23, p24, p25) -- line: 193
	local v49 = p23._changeSignal:connect(p24)

	if p25 == true then
		p24(p23._value)
	end

	return v49
end

local t10 = {}

t10.__index = t10

function t10.new(p26, p27, p28: ((...any) -> ...any)?) -- line: 219
	-- upvalues: t10 (copy)
	if not p26 then
		error("No signal provided to MappedSignal")
	end

	if not p27 then
		error("No fetchMapFunction provided to MappedSignal")
	end

	return (setmetatable({
		_signal = p26,
		_fetchMapFunction = p27,
		_eventReceiver = p28
	}, t10))
end
function t10.connect(p29, p30) -- line: 233
	if not p29._signal then
		warn("MappedSignal: Missing signal")

		return function() -- line: 236
		end
	end

	local v55 = p29._signal:connect(function() -- line: 239
		-- upvalues: p29 (copy), p30 (copy)
		if p29._eventReceiver then
			p29._eventReceiver()
		end

		p30(p29._fetchMapFunction())
	end)

	if p29._eventReceiver then
		p29._eventReceiver()
	end

	p30(p29._fetchMapFunction())

	return v55
end
function t10.get(p31) -- line: 253
	return p31._fetchMapFunction()
end
function setCoreGuiAvailability(t11: {[any]: any}, p32, p33: ((...any) -> ...any)?) -- line: 257
	-- upvalues: StarterGui (copy)
	local function updateAvailable() -- line: 262
		-- upvalues: StarterGui (copy), p32 (copy), p33 (copy), t11 (copy)
		local CoreGuiEnabled = StarterGui:GetCoreGuiEnabled(p32)

		if p33 then
			p33(CoreGuiEnabled)

			return
		end

		if CoreGuiEnabled then
			t11.availability:available()

			return
		end

		t11.availability:unavailable()
	end

	local connection = StarterGui.CoreGuiChangedSignal:Connect(updateAvailable)
	local CoreGuiEnabled = StarterGui:GetCoreGuiEnabled(p32)

	if p33 then
		p33(CoreGuiEnabled)

		return connection
	end

	if CoreGuiEnabled then
		t11.availability:available()

		return connection
	end

	t11.availability:unavailable()

	return connection
end

return {
	MappedSignal = t10,
	AvailabilitySignal = t2,
	AvailabilitySignalState = t1,
	NotifySignal = t4,
	ObservableValue = t9,
	setCoreGuiAvailability = setCoreGuiAvailability
}
