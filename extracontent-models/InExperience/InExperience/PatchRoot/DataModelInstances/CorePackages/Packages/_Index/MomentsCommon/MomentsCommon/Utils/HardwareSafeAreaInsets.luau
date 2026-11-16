local Players = game:GetService("Players")

local MomentsCommon = script:FindFirstAncestor("MomentsCommon")

local Signal = require(MomentsCommon.Utils.Signal)

local LocalPlayer = Players.LocalPlayer

local flag = false
local v = Signal.new()
local fullscreenTestGui = nil
local deviceTestGui = nil
local v2 = { left = 0, top = 0, right = 0, bottom = 0 }

function diffInsets(data, data2): boolean
	return data.top ~= data2.top or data.bottom ~= data2.bottom or data.left ~= data2.left or data.right ~= data2.right
end

function getHardwareSafeAreaInsets()
	local absolutePosition = fullscreenTestGui.AbsolutePosition
	local absolutePosition2 = deviceTestGui.AbsolutePosition

	local v3 = absolutePosition2 - absolutePosition
	local v4 = absolutePosition + fullscreenTestGui.AbsoluteSize - (absolutePosition2 + deviceTestGui.AbsoluteSize)

	return {
		left = math.round(v3.X),
		top = math.round(v3.Y),
		right = math.round(v4.X),
		bottom = math.round(v4.Y)
	}
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
		fullscreenTestGui.Parent = LocalPlayer.PlayerGui
		fullscreenTestGui.ScreenInsets = Enum.ScreenInsets.None
		fullscreenTestGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(handleSizeChange)
		fullscreenTestGui:GetPropertyChangedSignal("AbsolutePosition"):Connect(handleSizeChange)
	end

	if not deviceTestGui then
		deviceTestGui = Instance.new("ScreenGui")
		deviceTestGui.Name = "_DeviceTestGui"
		deviceTestGui.Parent = LocalPlayer.PlayerGui
		deviceTestGui.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
		deviceTestGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(handleSizeChange)
		deviceTestGui:GetPropertyChangedSignal("AbsolutePosition"):Connect(handleSizeChange)
	end

	handleSizeChange()
	flag = true
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

function HardwareSafeAreaInsets.fullscreenGui()
	init()
	return fullscreenTestGui
end

return HardwareSafeAreaInsets
