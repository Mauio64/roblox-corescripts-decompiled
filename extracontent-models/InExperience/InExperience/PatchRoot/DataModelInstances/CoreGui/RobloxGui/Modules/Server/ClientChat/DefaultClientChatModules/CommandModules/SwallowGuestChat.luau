local Util = require(script.Parent:WaitForChild("Util"))
local RunService = game:GetService("RunService")

local v = nil

pcall(function()
	local Chat = game:GetService("Chat")
	v = require(Chat.ClientChatModules.ChatLocalization)
end)

if v == nil then
	v = {}
	function v:Get(_, p)
		return p
	end
end

function ProcessMessage(_, object, _): boolean
	local Players = game:GetService("Players")
	local localPlayer = Players.LocalPlayer

	if not localPlayer or not (localPlayer.UserId < 0) or RunService:IsStudio() then
		return false
	end

	local currentChannel = object:GetCurrentChannel()

	if currentChannel then
		Util:SendSystemMessageToSelf(
			v:Get("GameChat_SwallowGuestChat_Message", "Create a free account to get access to chat permissions!"),
			currentChannel,
			{}
		)
	end

	return true
end

return {
	[Util.KEY_COMMAND_PROCESSOR_TYPE] = Util.COMPLETED_MESSAGE_PROCESSOR,
	[Util.KEY_PROCESSOR_FUNCTION] = ProcessMessage
}
