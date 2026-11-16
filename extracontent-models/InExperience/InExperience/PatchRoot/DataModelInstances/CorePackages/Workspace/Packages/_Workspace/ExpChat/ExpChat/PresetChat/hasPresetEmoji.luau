local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local SharedFlags = require(parent.SharedFlags)
local EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint = SharedFlags.EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint

require(ExpChat.Stores.GetPresetChatStore.createPresetChatStore)

local function hasPresetEmoji(items): boolean
	if not EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint then
		return false
	end

	for _, item in items do
		for _, category in item.categories do
			for _, v in category.contents or {} do
				if v.kind == "Emoji" then
					return true
				end
			end
		end
	end

	return false
end

return hasPresetEmoji
