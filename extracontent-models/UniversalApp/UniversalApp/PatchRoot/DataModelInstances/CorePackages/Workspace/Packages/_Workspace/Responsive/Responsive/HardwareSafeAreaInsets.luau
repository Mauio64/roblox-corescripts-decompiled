local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local ParentParent = script.Parent.Parent
local Signal = require(ParentParent.AppCommonLib).Signal
local FFlagEnableLeftNavOnConsole = require(ParentParent.SharedFlags).FFlagEnableLeftNavOnConsole
local t1 = {
	[Enum.Platform.XBoxOne] = true,
	[Enum.Platform.XBox360] = true,
	[Enum.Platform.WiiU] = true,
	[Enum.Platform.PS3] = true,
	[Enum.Platform.PS4] = true,
	[Enum.Platform.PS5] = true,
	[Enum.Platform.Ouya] = true,
	[Enum.Platform.AndroidTV] = true
}
local u7 = false
local v8 = Signal.new()
local ScreenGui = nil
local ScreenGui2 = nil
local t2 = {
	left = 0,
	top = 0,
	right = 0,
	bottom = 0
}

function diffInsets(p1, p2) -- line: 43
	return p1.top ~= p2.top or (p1.bottom ~= p2.bottom or (p1.left ~= p2.left or p1.right ~= p2.right))
end

local u12 = nil

function handleSizeChange() -- line: 48
	-- upvalues: t2 (ref), u12 (ref), v8 (copy)
	local v15 = getHardwareSafeAreaInsets()

	if diffInsets(v15, t2) then
		t2 = v15

		if u12 then
			task.cancel(u12)
		end

		u12 = task.defer(function() -- line: 55
			-- upvalues: u12 (ref), v8 (copy), v15 (copy)
			u12 = nil
			v8:fire(v15)
		end)
	end
end
function init() -- line: 62
	-- upvalues: u7 (ref), ScreenGui (ref), CoreGui (copy), ScreenGui2 (ref)
	if u7 then
		return
	end

	if not ScreenGui then
		ScreenGui = Instance.new("ScreenGui")
		ScreenGui.Name = "_FullscreenTestGui"
		ScreenGui.Parent = CoreGui
		ScreenGui.ScreenInsets = Enum.ScreenInsets.None
		ScreenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(handleSizeChange)
		ScreenGui:GetPropertyChangedSignal("AbsolutePosition"):Connect(handleSizeChange)
	end

	if not ScreenGui2 then
		ScreenGui2 = Instance.new("ScreenGui")
		ScreenGui2.Name = "_DeviceTestGui"
		ScreenGui2.Parent = CoreGui
		ScreenGui2.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
		ScreenGui2:GetPropertyChangedSignal("AbsoluteSize"):Connect(handleSizeChange)
		ScreenGui2:GetPropertyChangedSignal("AbsolutePosition"):Connect(handleSizeChange)
	end

	handleSizeChange()
	u7 = true
end
function getHardwareSafeAreaInsets() -- line: 89
	-- upvalues: ScreenGui (ref), ScreenGui2 (ref), t1 (copy), UserInputService (copy)
	local AbsolutePosition = ScreenGui.AbsolutePosition
	local AbsoluteSize = ScreenGui.AbsoluteSize
	local AbsolutePosition2 = ScreenGui2.AbsolutePosition
	local v19 = AbsolutePosition2 - AbsolutePosition
	local v20 = AbsolutePosition + ScreenGui.AbsoluteSize - (AbsolutePosition2 + ScreenGui2.AbsoluteSize)

	if t1[UserInputService:GetPlatform()] then
		local v21 = AbsoluteSize * 0.05

		v19 += v21
		v20 += v21
	end

	return {
		left = math.round(v19.X),
		top = math.round(v19.Y),
		right = math.round(v20.X),
		bottom = math.round(v20.Y)
	}
end

return {
	connect = function(_, p4) -- line: 113
		-- upvalues: v8 (copy)
		init()

		return v8:connect(p4)
	end,
	deviceInsets = function() -- line: 117
		-- upvalues: t2 (ref)
		init()

		return t2
	end,
	diffInsets = diffInsets,
	hasExtraPlatformInset = function() -- line: 122
		-- upvalues: FFlagEnableLeftNavOnConsole (copy), t1 (copy), UserInputService (copy)
		if FFlagEnableLeftNavOnConsole then
			return false
		end

		return t1[UserInputService:GetPlatform()]
	end,
	fullscreenGui = function() -- line: 128
		-- upvalues: ScreenGui (ref)
		init()

		return ScreenGui
	end
}
