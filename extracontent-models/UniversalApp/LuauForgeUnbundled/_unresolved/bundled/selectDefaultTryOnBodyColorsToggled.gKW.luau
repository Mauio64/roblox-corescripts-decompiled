local function selectDefaultTryOnBodyColorsToggled(p2)
	local outfitTryOn = p2.AvatarExperience.AvatarScene.OutfitTryOn

	if outfitTryOn then
		return outfitTryOn.DefaultTryOnBodyColorsToggled
	end

	return false
end

return selectDefaultTryOnBodyColorsToggled
