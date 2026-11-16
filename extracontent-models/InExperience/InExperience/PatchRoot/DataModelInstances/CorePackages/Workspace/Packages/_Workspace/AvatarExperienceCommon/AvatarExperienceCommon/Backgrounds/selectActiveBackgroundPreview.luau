local function selectActiveBackgroundPreview(p)
	local avatarExperience = p and (p.AvatarExperience or p)
	local outfitTryOn = avatarExperience and avatarExperience.AvatarScene and avatarExperience.AvatarScene.OutfitTryOn

	return if outfitTryOn then outfitTryOn.BackgroundPreview else nil
end

return selectActiveBackgroundPreview
