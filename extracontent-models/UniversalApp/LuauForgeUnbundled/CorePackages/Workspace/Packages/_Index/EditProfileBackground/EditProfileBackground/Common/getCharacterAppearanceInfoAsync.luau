local Players = game:GetService("Players")

return function(p2)
	return Players:GetCharacterAppearanceInfoAsync(p2)
end
