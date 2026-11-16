return function()
	local v = game:GetEngineFeature("EnableChatInputBarConfigurationAutocompleteEnabled")

	if v then
		local UserInputService = game:GetService("UserInputService")
		return not UserInputService.TouchEnabled
	end

	return v
end
