local AvatarEditorService = game:GetService("AvatarEditorService")
local Players = game:GetService("Players")

local function applyOutfit(n1: number, p1) -- line: 10
	-- upvalues: Players (copy), AvatarEditorService (copy)
	local v6 = if not game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then Players:GetHumanoidDescriptionFromOutfitId(n1) else Players:GetHumanoidDescriptionFromOutfitIdAsync(n1)
	local t1 = {
		BodyColors = true,
		AvatarType = true,
		Scales = true,
		Assets = true
	}

	AvatarEditorService:NoPromptSaveAvatar(v6, p1, t1)
	AvatarEditorService.PromptSaveAvatarCompleted:Wait()
end

return applyOutfit
