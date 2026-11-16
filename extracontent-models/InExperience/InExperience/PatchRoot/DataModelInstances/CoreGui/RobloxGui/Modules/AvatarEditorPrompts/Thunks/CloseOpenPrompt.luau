local AvatarEditorService = game:GetService("AvatarEditorService")

local parent = script.Parent.Parent
local CloseOpenPrompt = require(parent.Actions.CloseOpenPrompt)

local PromptType = require(parent.PromptType)

return function(object)
	local promptType = object:getState().promptInfo.promptType

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
	elseif promptType == PromptType.SaveAvatarTimeout then
		AvatarEditorService:SignalSaveAvatarPermissionDenied()
	elseif promptType ~= nil then
		error("CloseOpenPrompt for unhandled prompt type " .. tostring(promptType))
	end

	object:dispatch(CloseOpenPrompt())
end
