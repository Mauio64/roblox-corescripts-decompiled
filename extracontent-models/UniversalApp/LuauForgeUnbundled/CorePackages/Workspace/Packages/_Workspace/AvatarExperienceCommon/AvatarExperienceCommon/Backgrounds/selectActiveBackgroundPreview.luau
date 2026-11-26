local function selectActiveBackgroundPreview(p2)
	local avatarExperience = p2 and (p2.AvatarExperience or p2)
	local outfitTryOn = avatarExperience
		and avatarExperience.AvatarScene
		and avatarExperience.AvatarScene.OutfitTryOn

	if outfitTryOn then
		return outfitTryOn.BackgroundPreview
	end

	return nil
end

return selectActiveBackgroundPreview
