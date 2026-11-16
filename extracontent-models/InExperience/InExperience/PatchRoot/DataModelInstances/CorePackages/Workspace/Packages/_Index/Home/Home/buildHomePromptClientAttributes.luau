local function buildHomePromptClientAttributes(p)
	local v = p or game:GetService("AppStorageService")
	local homePromptClientAttributes = {}

	local success, item = pcall(v.GetItem, v, "KidsAccountHasResetToDefaultTheme")

	if success and typeof(item) == "string" and item ~= "" then
		homePromptClientAttributes.KidsAccountHasResetToDefaultTheme = item
	end

	return homePromptClientAttributes
end

return buildHomePromptClientAttributes
