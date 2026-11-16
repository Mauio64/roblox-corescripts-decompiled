local CoreGui = game:GetService("CoreGui")

local v6 = nil
return {
	show = function()
		if v6 and v6.Parent then
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
		v6 = playWithRewardBlackoutCurtain
	end,
	hide = function()
		if v6 then
			v6:Destroy()
			v6 = nil
		end
	end
}
