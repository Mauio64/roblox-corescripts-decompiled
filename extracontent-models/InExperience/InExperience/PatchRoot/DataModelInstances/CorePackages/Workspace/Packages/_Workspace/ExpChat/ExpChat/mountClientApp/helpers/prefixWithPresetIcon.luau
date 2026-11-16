local TextChatService = game:GetService("TextChatService")

local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local ExpChatShared = require(parent.ExpChatShared)
local Config = require(ExpChat.Config)

local getPresetIconRichText = ExpChatShared.getPresetIconRichText

local function getChatWindowTextSize() -- 1 equivalent call inferred from this helper
	local chatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")

	if chatWindowConfiguration then
		return chatWindowConfiguration.TextSize
	end

	return Config.ChatWindowTextSize
end

local function prefixWithPresetIcon(p: string, p2: number?)
	if not p2 then
		p2 = getChatWindowTextSize() -- inferred equivalent call
	end

	return `{getPresetIconRichText(p2)} {p}`
end

return prefixWithPresetIcon
