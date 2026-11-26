local engineFeature = game:GetEngineFeature("EnableAndroidPasswordSuggestion")

return function(p2)
	if p2 == Enum.TextInputType.Password or p2 == Enum.TextInputType.PasswordShown then
		return true
	end

	return engineFeature
		and (p2 == Enum.TextInputType.NewPassword or p2 == Enum.TextInputType.NewPasswordShown)
end
