local Players = game:GetService("Players")
local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local Signal = require(MomentsCommon.Utils.Signal)
local LocalPlayer = Players.LocalPlayer
local u5 = false
local v6 = Signal.new()
local ScreenGui = nil
local ScreenGui2 = nil
local t1 = {
	left = 0,
	top = 0,
	right = 0,
	bottom = 0
}

function diffInsets(p1, p2) -- line: 27
	return p1.top ~= p2.top or (p1.bottom ~= p2.bottom or (p1.left ~= p2.left or p1.right ~= p2.right))
end
function getHardwareSafeAreaInsets() -- line: 31
	-- upvalues: ScreenGui (ref), ScreenGui2 (ref)
	local AbsolutePosition = ScreenGui.AbsolutePosition
	local AbsolutePosition2 = ScreenGui2.AbsolutePosition
	local v15 = AbsolutePosition2 - AbsolutePosition
	local v16 = AbsolutePosition + ScreenGui.AbsoluteSize - (AbsolutePosition2 + ScreenGui2.AbsoluteSize)

	return {
		left = math.round(v15.X),
		top = math.round(v15.Y),
		right = math.round(v16.X),
		bottom = math.round(v16.Y)
	}
end

local u10 = nil

function handleSizeChange() -- line: 48
	-- upvalues: t1 (ref), u10 (ref), v6 (copy)
	local v17 = getHardwareSafeAreaInsets()

	if diffInsets(v17, t1) then
		t1 = v17

		if u10 then
			task.cancel(u10)
		end

		u10 = task.defer(function() -- line: 55
			-- upvalues: u10 (ref), v6 (copy), v17 (copy)
			u10 = nil
			v6:fire(v17)
		end)
	end
end
function init() -- line: 62
	-- upvalues: u5 (ref), ScreenGui (ref), LocalPlayer (copy), ScreenGui2 (ref)
	if u5 then
		return
	end

	if not ScreenGui then
		ScreenGui = Instance.new("ScreenGui")
		ScreenGui.Name = "_FullscreenTestGui"
		ScreenGui.Parent = LocalPlayer.PlayerGui
		ScreenGui.ScreenInsets = Enum.ScreenInsets.None
		ScreenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(handleSizeChange)
		ScreenGui:GetPropertyChangedSignal("AbsolutePosition"):Connect(handleSizeChange)
	end

	if not ScreenGui2 then
		ScreenGui2 = Instance.new("ScreenGui")
		ScreenGui2.Name = "_DeviceTestGui"
		ScreenGui2.Parent = LocalPlayer.PlayerGui
		ScreenGui2.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
		ScreenGui2:GetPropertyChangedSignal("AbsoluteSize"):Connect(handleSizeChange)
		ScreenGui2:GetPropertyChangedSignal("AbsolutePosition"):Connect(handleSizeChange)
	end

	handleSizeChange()
	u5 = true
end

return {
	connect = function(_, p4) -- line: 90
		-- upvalues: v6 (copy)
		init()

		return v6:connect(p4)
	end,
	deviceInsets = function() -- line: 94
		-- upvalues: t1 (ref)
		init()

		return t1
	end,
	diffInsets = diffInsets,
	fullscreenGui = function() -- line: 99
		-- upvalues: ScreenGui (ref)
		init()

		return ScreenGui
	end
}
