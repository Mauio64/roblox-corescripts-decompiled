local FaceAnimatorService = game:GetService("FaceAnimatorService")
local CoreGui = game:GetService("CoreGui")
local Modules = CoreGui.RobloxGui.Modules

local Analytics = require(Modules.SelfView.Analytics)
local v = Analytics.new()
local publicApi = require(Modules.SelfView.publicApi)
local toggleSelfViewSignal = require(Modules.SelfView.toggleSelfViewSignal)

return function()
	if FaceAnimatorService and FaceAnimatorService:IsStarted() then
		FaceAnimatorService.VideoAnimationEnabled = not FaceAnimatorService.VideoAnimationEnabled
		v:setLastCtx("bubbleChatToggle")

		local selfViewIsOpenAndVisible = publicApi.getSelfViewIsOpenAndVisible()

		if FaceAnimatorService.VideoAnimationEnabled and not selfViewIsOpenAndVisible then
			toggleSelfViewSignal:fire()
		end
	end
end
