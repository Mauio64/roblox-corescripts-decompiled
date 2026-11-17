local function checkApplyDefaultClothing(p)
	local AvatarEditorService = game:GetService("AvatarEditorService")
	return AvatarEditorService:CheckApplyDefaultClothingAsync(p)
end

return checkApplyDefaultClothing
