local ClientChatModules = game:GetService("Chat"):WaitForChild("ClientChatModules")
local ChatConstants = require(ClientChatModules:WaitForChild("ChatConstants"))
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))

local function Run(p1) -- line: 10
	-- upvalues: ChatSettings (copy), ChatConstants (copy)
	if ChatSettings and ChatSettings.AllowMeCommand then
		local function MeCommandFilterFunction(_, p3, _) -- line: 13
			-- upvalues: ChatConstants (copy)
			local p3Message = p3.Message

			if p3Message and string.sub(p3Message, 1, 4):lower() == "/me " then
				p3.MessageType = ChatConstants.MessageTypeMeCommand
			end
		end

		p1:RegisterFilterMessageFunction("me_command", MeCommandFilterFunction)
	end
end

return Run
