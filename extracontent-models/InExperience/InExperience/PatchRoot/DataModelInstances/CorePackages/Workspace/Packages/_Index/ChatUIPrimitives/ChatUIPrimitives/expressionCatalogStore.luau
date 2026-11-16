local TextChatService = game:GetService("TextChatService")

local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local createExpressionCatalogStore = require(ChatUIPrimitives.createExpressionCatalogStore)

return createExpressionCatalogStore(function()
	local success, result = pcall(function()
		return TextChatService:GetPresetsAsync()
	end)
	return if success then result else nil
end)
