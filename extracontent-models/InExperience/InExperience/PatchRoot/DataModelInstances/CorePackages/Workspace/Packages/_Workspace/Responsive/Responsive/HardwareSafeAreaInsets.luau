local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local parent = script.Parent.Parent

local AppCommonLib = require(parent.AppCommonLib)

local Signal = AppCommonLib.Signal

local set = {
	[Enum.Platform.XBoxOne] = true,
	[Enum.Platform.XBox360] = true,
	[Enum.Platform.WiiU] = true,
	[Enum.Platform.PS3] = true,
	[Enum.Platform.PS4] = true,
	[Enum.Platform.PS5] = true,
	[Enum.Platform.Ouya] = true,
	[Enum.Platform.AndroidTV] = true
}

local flag = false
local v = Signal.new()
local fullscreenTestGui = nil
local deviceTestGui = nil
local v2 = { left = 0, top = 0, right = 0, bottom = 0 }

function diffInsets(data, data2): boolean
	return data.top ~= data2.top or data.bottom ~= data2.bottom or data.left ~= data2.left or data.right ~= data2.right
end

local thread = nil
function handleSizeChange()
	local hardwareSafeAreaInsets = getHardwareSafeAreaInsets()

	if diffInsets(hardwareSafeAreaInsets, v2) then
		v2 = hardwareSafeAreaInsets

		if thread then
			task.cancel(thread)
		end

		thread = task.defer(function()
			thread = nil
			v:fire(hardwareSafeAreaInsets)
		end)
	end
end

function init()
	if flag then
		return
	end

	if not fullscreenTestGui then
		fullscreenTestGui = Instance.new("ScreenGui")
		fullscreenTestGui.Name = "_FullscreenTestGui"
		fullscreenTestGui.Parent = CoreGui
		fullscreenTestGui.ScreenInsets = Enum.ScreenInsets.None
		fullscreenTestGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(handleSizeChange)
		fullscreenTestGui:GetPropertyChangedSignal("AbsolutePosition"):Connect(handleSizeChange)
	end

	if not deviceTestGui then
		deviceTestGui = Instance.new("ScreenGui")
		deviceTestGui.Name = "_DeviceTestGui"
		deviceTestGui.Parent = CoreGui
		deviceTestGui.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
		deviceTestGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(handleSizeChange)
		deviceTestGui:GetPropertyChangedSignal("AbsolutePosition"):Connect(handleSizeChange)
	end

	handleSizeChange()
	flag = true
end

function getHardwareSafeAreaInsets()
	local absolutePosition = fullscreenTestGui.AbsolutePosition
	local absoluteSize = fullscreenTestGui.AbsoluteSize
	local absolutePosition2 = deviceTestGui.AbsolutePosition

	local v3 = absolutePosition2 - absolutePosition
	local v4 = absolutePosition + fullscreenTestGui.AbsoluteSize - (absolutePosition2 + deviceTestGui.AbsoluteSize)

	if set[UserInputService:GetPlatform()] then
		local v5 = absoluteSize * 0.05
		v3 += v5
		v4 += v5
	end

	return {
		left = math.round(v3.X),
		top = math.round(v3.Y),
		right = math.round(v4.X),
		bottom = math.round(v4.Y)
	}
end

local HardwareSafeAreaInsets = {}

function HardwareSafeAreaInsets:connect(p)
	init()
	return v:connect(p)
end

function HardwareSafeAreaInsets.deviceInsets()
	init()
	return v2
end

HardwareSafeAreaInsets.diffInsets = diffInsets

function HardwareSafeAreaInsets.hasExtraPlatformInset(): boolean
	return false
end

function HardwareSafeAreaInsets.fullscreenGui()
	init()
	return fullscreenTestGui
end

return HardwareSafeAreaInsets
