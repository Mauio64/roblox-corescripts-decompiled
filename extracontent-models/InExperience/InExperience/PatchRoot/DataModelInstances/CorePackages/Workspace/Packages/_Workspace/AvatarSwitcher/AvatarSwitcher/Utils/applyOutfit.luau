local AvatarEditorService = game:GetService("AvatarEditorService")
local Players = game:GetService("Players")

local function applyOutfit(p: number, p2)
	AvatarEditorService:NoPromptSaveAvatar(Players:GetHumanoidDescriptionFromOutfitIdAsync(p), p2, {
		BodyColors = true,
		AvatarType = true,
		Scales = true,
		Assets = true
	})
	AvatarEditorService.PromptSaveAvatarCompleted:Wait()
end

return applyOutfit
