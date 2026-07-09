local CoreGui = game:GetService("CoreGui")
local t1 = {}
local u3 = nil

function t1.show() -- line: 9
	-- upvalues: u3 (ref), CoreGui (copy)
	if u3 and u3.Parent then
		return
	end

	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "PlayWithRewardBlackoutCurtain"
	ScreenGui.DisplayOrder = 99
	ScreenGui.IgnoreGuiInset = true

	local Frame = Instance.new("Frame")

	Frame.Name = "BlackoutCurtainFrame"
	Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Frame.BackgroundTransparency = 0
	Frame.Size = UDim2.fromScale(1, 1)
	Frame.Active = true
	Frame.Parent = ScreenGui
	ScreenGui.Parent = CoreGui
	u3 = ScreenGui
end
function t1.hide() -- line: 31
	-- upvalues: u3 (ref)
	if u3 then
		u3:Destroy()
		u3 = nil
	end
end

return t1
