local Util = require(script.Parent:WaitForChild("Util"))

local v = nil

pcall(function()
	local Chat = game:GetService("Chat")
	v = require(Chat.ClientChatModules.ChatLocalization)
end)

if v == nil then
	v = {
		Get = function(self, _, p)
			return p
		end
	}
end

function ProcessMessage(value, object, p): boolean
	if string.sub(value, 1, 3):lower() ~= "/c " then
		return false
	end

	local v2 = string.sub(value, 4)

	local channel = object:GetChannel(v2)

	if channel then
		object:SwitchCurrentChannel(v2)

		if not p.ShowChannelsBar and object:GetCurrentChannel() then
			Util:SendSystemMessageToSelf(
				string.gsub(
					v:Get(
						"GameChat_SwitchChannel_NowInChannel",
						string.format("You are now chatting in channel: '%s'", v2),
						{ RBX_NAME = v2 }
					),
					"{RBX_NAME}",
					v2
				),
				channel,
				{}
			)
		end
	else
		local currentChannel = object:GetCurrentChannel()

		if currentChannel then
			Util:SendSystemMessageToSelf(
				string.gsub(
					v:Get("GameChat_SwitchChannel_NotInChannel", string.format("You are not in channel: '%s'", v2), {
						RBX_NAME = v2
					}),
					"{RBX_NAME}",
					v2
				),
				currentChannel,
				{ ChatColor = Color3.fromRGB(245, 50, 50) }
			)
		end
	end

	return true
end

return {
	[Util.KEY_COMMAND_PROCESSOR_TYPE] = Util.COMPLETED_MESSAGE_PROCESSOR,
	[Util.KEY_PROCESSOR_FUNCTION] = ProcessMessage
}
