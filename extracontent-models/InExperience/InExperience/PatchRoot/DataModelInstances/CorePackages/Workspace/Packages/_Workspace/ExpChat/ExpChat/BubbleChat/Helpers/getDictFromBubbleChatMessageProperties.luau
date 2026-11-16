local ExpChat = script:FindFirstAncestor("ExpChat")
local Config = require(ExpChat.Config)

return function(instance)
	local result = {}

	for k, _ in pairs(Config.DefaultBubbleChatMessagePropertiesInstanceSettings) do
		result[k] = instance[k]
	end

	local imageLabel = instance:FindFirstChildOfClass("ImageLabel")

	if imageLabel then
		local imageLabel2 = {}

		for k, _ in pairs(Config.DefaultBubbleChatChildrenCustomizationProperties.ImageLabel) do
			imageLabel2[k] = imageLabel[k]
		end

		result.ImageLabel = imageLabel2
	end

	local uiGradient = instance:FindFirstChildOfClass("UIGradient")

	if uiGradient then
		local uiGradient2 = {}

		for k, _ in pairs(Config.DefaultBubbleChatChildrenCustomizationProperties.UIGradient) do
			uiGradient2[k] = uiGradient[k]
		end

		result.UIGradient = uiGradient2
	end

	local uiCorner = instance:FindFirstChildOfClass("UICorner")

	if uiCorner then
		local uiCorner2 = {}

		for k, _ in pairs(Config.DefaultBubbleChatChildrenCustomizationProperties.UICorner) do
			uiCorner2[k] = uiCorner[k]
		end

		result.UICorner = uiCorner2
	end

	local uiPadding = instance:FindFirstChildOfClass("UIPadding")

	if not uiPadding then
		return result
	end

	local uiPadding2 = {}

	for k, _ in pairs(Config.DefaultBubbleChatChildrenCustomizationProperties.UIPadding) do
		uiPadding2[k] = uiPadding[k]
	end

	result.UIPadding = uiPadding2

	return result
end
