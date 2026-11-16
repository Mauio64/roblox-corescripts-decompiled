local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/AppCommonLib").Signal

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
local v5 = signal.new()
local fullscreenTestGui = nil
local deviceTestGui = nil
local v6 = { left = 0, top = 0, right = 0, bottom = 0 }

function LUAUFORGE_MODULE_GLOBALS_xS_diffInsets(data, data2): boolean
	return data.top ~= data2.top
		or data.bottom ~= data2.bottom
		or data.left ~= data2.left
		or data.right ~= data2.right
end

local thread = nil
function LUAUFORGE_MODULE_GLOBALS_xS_handleSizeChange()
	local v7 = LUAUFORGE_MODULE_GLOBALS_xS_getHardwareSafeAreaInsets()

	if LUAUFORGE_MODULE_GLOBALS_xS_diffInsets(v7, v6) then
		v6 = v7

		if thread then
			task.cancel(thread)
		end

		thread = task.defer(function()
			thread = nil
			v5:fire(v7)
		end)
	end
end

function LUAUFORGE_MODULE_GLOBALS_xS_init()
	if flag then
		return
	end

	if not fullscreenTestGui then
		fullscreenTestGui = Instance.new("ScreenGui")
		fullscreenTestGui.Name = "_FullscreenTestGui"
		fullscreenTestGui.Parent = CoreGui
		fullscreenTestGui.ScreenInsets = Enum.ScreenInsets.None
		fullscreenTestGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(LUAUFORGE_MODULE_GLOBALS_xS_handleSizeChange)
		fullscreenTestGui:GetPropertyChangedSignal("AbsolutePosition"):Connect(LUAUFORGE_MODULE_GLOBALS_xS_handleSizeChange)
	end

	if not deviceTestGui then
		deviceTestGui = Instance.new("ScreenGui")
		deviceTestGui.Name = "_DeviceTestGui"
		deviceTestGui.Parent = CoreGui
		deviceTestGui.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
		deviceTestGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(LUAUFORGE_MODULE_GLOBALS_xS_handleSizeChange)
		deviceTestGui:GetPropertyChangedSignal("AbsolutePosition"):Connect(LUAUFORGE_MODULE_GLOBALS_xS_handleSizeChange)
	end

	LUAUFORGE_MODULE_GLOBALS_xS_handleSizeChange()
	flag = true
end

function LUAUFORGE_MODULE_GLOBALS_xS_getHardwareSafeAreaInsets()
	local absolutePosition = fullscreenTestGui.AbsolutePosition
	local absoluteSize = fullscreenTestGui.AbsoluteSize
	local absolutePosition2 = deviceTestGui.AbsolutePosition

	local v7 = absolutePosition2 - absolutePosition
	local v8 = absolutePosition + fullscreenTestGui.AbsoluteSize - (absolutePosition2 + deviceTestGui.AbsoluteSize)

	if set[UserInputService:GetPlatform()] then
		local v9 = absoluteSize * 0.05
		v7 += v9
		v8 += v9
	end

	return {
		left = math.round(v7.X),
		top = math.round(v7.Y),
		right = math.round(v8.X),
		bottom = math.round(v8.Y)
	}
end

return {
	connect = function(p2, p3)
		LUAUFORGE_MODULE_GLOBALS_xS_init()
		return v5:connect(p3)
	end,
	deviceInsets = function()
		LUAUFORGE_MODULE_GLOBALS_xS_init()
		return v6
	end,
	diffInsets = LUAUFORGE_MODULE_GLOBALS_xS_diffInsets,
	hasExtraPlatformInset = function(): boolean
		return false
	end,
	fullscreenGui = function()
		LUAUFORGE_MODULE_GLOBALS_xS_init()
		return fullscreenTestGui
	end
}
