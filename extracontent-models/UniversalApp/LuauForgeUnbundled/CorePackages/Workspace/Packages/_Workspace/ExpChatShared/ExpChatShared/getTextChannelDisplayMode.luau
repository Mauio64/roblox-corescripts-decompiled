local GetFFlagExpChatUseIsDefaultTextChannel = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Flags/GetFFlagExpChatUseIsDefaultTextChannel")

local TextChatService = game:GetService("TextChatService")

local function getTextChannelDisplayMode()
	if not GetFFlagExpChatUseIsDefaultTextChannel() then
		return nil
	end

	local chatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")

	if chatWindowConfiguration == nil then
		return nil
	end

	return chatWindowConfiguration.TextChannelDisplayMode
end

return getTextChannelDisplayMode
