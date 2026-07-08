local AvatarEditorService = game:GetService("AvatarEditorService")
local CorePackages = game:GetService("CorePackages")
local ParentParent = script.Parent.Parent
local CloseOpenPrompt = require(ParentParent.Actions.CloseOpenPrompt)
local PromptType = require(ParentParent.PromptType)
local FFlagAXAvatarTimeoutFlowIE = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXAvatarTimeoutFlowIE

return function(p1) -- line: 10
	-- upvalues: PromptType (copy), AvatarEditorService (copy), FFlagAXAvatarTimeoutFlowIE (copy), CloseOpenPrompt (copy)
	local promptType = p1:getState().promptInfo.promptType

	if promptType == PromptType.AllowInventoryReadAccess then
		AvatarEditorService:SetAllowInventoryReadAccess(false)
	elseif promptType == PromptType.SaveAvatar then
		AvatarEditorService:SignalSaveAvatarPermissionDenied()
	elseif promptType == PromptType.CreateOutfit then
		AvatarEditorService:SignalCreateOutfitPermissionDenied()
	elseif promptType == PromptType.EnterOutfitName then
		AvatarEditorService:SignalCreateOutfitPermissionDenied()
	elseif promptType == PromptType.SetFavorite then
		AvatarEditorService:SignalSetFavoritePermissionDenied()
	elseif promptType == PromptType.DeleteOutfit then
		AvatarEditorService:SignalDeleteOutfitPermissionDenied()
	elseif promptType == PromptType.RenameOutfit then
		AvatarEditorService:SignalRenameOutfitPermissionDenied()
	elseif promptType == PromptType.UpdateOutfit then
		AvatarEditorService:SignalUpdateOutfitPermissionDenied()
	elseif FFlagAXAvatarTimeoutFlowIE and promptType == PromptType.SaveAvatarTimeout then
		AvatarEditorService:SignalSaveAvatarPermissionDenied()
	elseif promptType ~= nil then
		error("CloseOpenPrompt for unhandled prompt type " .. tostring(promptType))
	end

	p1:dispatch(CloseOpenPrompt())
end
