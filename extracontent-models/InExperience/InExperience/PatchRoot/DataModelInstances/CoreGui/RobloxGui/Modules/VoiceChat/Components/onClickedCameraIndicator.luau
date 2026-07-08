local FaceAnimatorService = game:GetService("FaceAnimatorService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local v3 = require(Modules.SelfView.Analytics).new()
local publicApi = require(Modules.SelfView.publicApi)
local toggleSelfViewSignal = require(Modules.SelfView.toggleSelfViewSignal)

return function() -- line: 9
	-- upvalues: FaceAnimatorService (copy), v3 (copy), publicApi (copy), toggleSelfViewSignal (copy)
	if FaceAnimatorService and FaceAnimatorService:IsStarted() then
		FaceAnimatorService.VideoAnimationEnabled = not FaceAnimatorService.VideoAnimationEnabled
		v3:setLastCtx("bubbleChatToggle")

		local v6 = publicApi.getSelfViewIsOpenAndVisible()

		if FaceAnimatorService.VideoAnimationEnabled and not v6 then
			toggleSelfViewSignal:fire()
		end
	end
end
