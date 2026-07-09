local function selectDefaultTryOnBodyColorsToggled(p1) -- line: 1
	local OutfitTryOn = p1.AvatarExperience.AvatarScene.OutfitTryOn

	if OutfitTryOn then
		return OutfitTryOn.DefaultTryOnBodyColorsToggled
	end

	return false
end

return selectDefaultTryOnBodyColorsToggled
