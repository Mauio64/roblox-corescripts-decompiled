local Util = require(script.Parent:WaitForChild("Util"))
local RunService = game:GetService("RunService")
local ChatLocalization = nil

pcall(function() -- line: 12
	-- upvalues: ChatLocalization (ref)
	ChatLocalization = require(game:GetService("Chat").ClientChatModules.ChatLocalization)
end)

if ChatLocalization == nil then
	ChatLocalization = {
		Get = function(_, _, p3) -- line: 13
			return p3
		end
	}
end

function ProcessMessage(_, p5, _) -- line: 15
	-- upvalues: RunService (copy), Util (copy), ChatLocalization (ref)
	local LocalPlayer = game:GetService("Players").LocalPlayer

	if LocalPlayer and (LocalPlayer.UserId < 0 and not RunService:IsStudio()) then
		local CurrentChannel = p5:GetCurrentChannel()

		if CurrentChannel then
			Util:SendSystemMessageToSelf(ChatLocalization:Get("GameChat_SwallowGuestChat_Message", "Create a free account to get access to chat permissions!"), CurrentChannel, {})
		end

		return true
	end

	return false
end

return {
	[Util.KEY_COMMAND_PROCESSOR_TYPE] = Util.COMPLETED_MESSAGE_PROCESSOR,
	[Util.KEY_PROCESSOR_FUNCTION] = ProcessMessage
}
