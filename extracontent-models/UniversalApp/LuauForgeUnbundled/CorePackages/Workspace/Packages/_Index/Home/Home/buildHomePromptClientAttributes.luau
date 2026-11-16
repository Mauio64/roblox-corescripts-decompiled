local function buildHomePromptClientAttributes(p2)
	local v5 = p2 or game:GetService("AppStorageService")
	local homePromptClientAttributes = {}

	local success, item = pcall(v5.GetItem, v5, "KidsAccountHasResetToDefaultTheme")

	if success and typeof(item) == "string" and item ~= "" then
		homePromptClientAttributes.KidsAccountHasResetToDefaultTheme = item
	end

	return homePromptClientAttributes
end

return buildHomePromptClientAttributes
