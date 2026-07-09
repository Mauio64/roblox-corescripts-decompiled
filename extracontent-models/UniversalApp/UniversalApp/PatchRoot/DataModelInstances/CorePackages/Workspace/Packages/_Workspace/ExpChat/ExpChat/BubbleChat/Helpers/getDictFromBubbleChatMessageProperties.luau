local ExpChat = script:FindFirstAncestor("ExpChat")
local Config = require(ExpChat.Config)

return function(p1) -- line: 4
	-- upvalues: Config (copy)
	local t1 = {}

	for k, _ in pairs(Config.DefaultBubbleChatMessagePropertiesInstanceSettings) do
		t1[k] = p1[k]
	end

	local ImageLabel = p1:FindFirstChildOfClass("ImageLabel")

	if ImageLabel then
		local t2 = {}

		for k, _ in pairs(Config.DefaultBubbleChatChildrenCustomizationProperties.ImageLabel) do
			t2[k] = ImageLabel[k]
		end

		t1.ImageLabel = t2
	end

	local UIGradient = p1:FindFirstChildOfClass("UIGradient")

	if UIGradient then
		local t3 = {}

		for k, _ in pairs(Config.DefaultBubbleChatChildrenCustomizationProperties.UIGradient) do
			t3[k] = UIGradient[k]
		end

		t1.UIGradient = t3
	end

	local UICorner = p1:FindFirstChildOfClass("UICorner")

	if UICorner then
		local t4 = {}

		for k, _ in pairs(Config.DefaultBubbleChatChildrenCustomizationProperties.UICorner) do
			t4[k] = UICorner[k]
		end

		t1.UICorner = t4
	end

	local UIPadding = p1:FindFirstChildOfClass("UIPadding")

	if UIPadding then
		local t5 = {}

		for k, _ in pairs(Config.DefaultBubbleChatChildrenCustomizationProperties.UIPadding) do
			t5[k] = UIPadding[k]
		end

		t1.UIPadding = t5
	end

	return t1
end
