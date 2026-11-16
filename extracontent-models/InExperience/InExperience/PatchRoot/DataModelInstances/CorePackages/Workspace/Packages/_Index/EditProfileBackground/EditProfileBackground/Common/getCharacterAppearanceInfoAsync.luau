local Players = game:GetService("Players")

return function(p: number)
	return Players:GetCharacterAppearanceInfoAsync(p)
end
