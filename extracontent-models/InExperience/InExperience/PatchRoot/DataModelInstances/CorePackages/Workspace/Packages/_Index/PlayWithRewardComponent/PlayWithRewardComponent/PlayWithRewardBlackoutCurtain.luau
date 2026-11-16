local CoreGui = game:GetService("CoreGui")

local v = nil
local PlayWithRewardBlackoutCurtain = {}

function PlayWithRewardBlackoutCurtain.show()
	if v and v.Parent then
		return
	end

	local playWithRewardBlackoutCurtain = Instance.new("ScreenGui")
	playWithRewardBlackoutCurtain.Name = "PlayWithRewardBlackoutCurtain"
	playWithRewardBlackoutCurtain.DisplayOrder = 99
	playWithRewardBlackoutCurtain.IgnoreGuiInset = true

	local blackoutCurtainFrame = Instance.new("Frame")
	blackoutCurtainFrame.Name = "BlackoutCurtainFrame"
	blackoutCurtainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	blackoutCurtainFrame.BackgroundTransparency = 0
	blackoutCurtainFrame.Size = UDim2.fromScale(1, 1)
	blackoutCurtainFrame.Active = true
	blackoutCurtainFrame.Parent = playWithRewardBlackoutCurtain

	playWithRewardBlackoutCurtain.Parent = CoreGui
	v = playWithRewardBlackoutCurtain
end

function PlayWithRewardBlackoutCurtain.hide()
	if v then
		v:Destroy()
		v = nil
	end
end

return PlayWithRewardBlackoutCurtain
