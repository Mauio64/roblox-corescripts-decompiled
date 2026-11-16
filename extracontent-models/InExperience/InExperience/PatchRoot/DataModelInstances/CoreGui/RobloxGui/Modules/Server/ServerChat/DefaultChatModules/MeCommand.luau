local Chat = game:GetService("Chat")
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local ChatConstants = require(ClientChatModules:WaitForChild("ChatConstants"))
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))

local function Run(object)
	if ChatSettings and ChatSettings.AllowMeCommand then
		local function MeCommandFilterFunction(_, p, _)
			local message = p.Message

			if message and string.sub(message, 1, 4):lower() == "/me " then
				p.MessageType = ChatConstants.MessageTypeMeCommand
			end
		end

		object:RegisterFilterMessageFunction("me_command", MeCommandFilterFunction)
	end
end

return Run
