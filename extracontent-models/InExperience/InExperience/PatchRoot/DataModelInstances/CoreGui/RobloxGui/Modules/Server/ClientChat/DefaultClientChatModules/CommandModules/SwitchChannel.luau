local Util = require(script.Parent:WaitForChild("Util"))
local ChatLocalization = nil

pcall(function() -- line: 10
	-- upvalues: ChatLocalization (ref)
	ChatLocalization = require(game:GetService("Chat").ClientChatModules.ChatLocalization)
end)

if ChatLocalization == nil then
	ChatLocalization = {
		Get = function(_, _, p3) -- line: 11
			return p3
		end
	}
end

function ProcessMessage(p4, p5, p6) -- line: 13
	-- upvalues: Util (copy), ChatLocalization (ref)
	if string.sub(p4, 1, 3):lower() ~= "/c " then
		return false
	end

	local v9 = string.sub(p4, 4)
	local Channel = p5:GetChannel(v9)

	if Channel then
		p5:SwitchCurrentChannel(v9)

		if not p6.ShowChannelsBar and p5:GetCurrentChannel() then
			Util:SendSystemMessageToSelf(string.gsub(ChatLocalization:Get("GameChat_SwitchChannel_NowInChannel", string.format("You are now chatting in channel: '%s'", v9), {
				RBX_NAME = v9
			}), "{RBX_NAME}", v9), Channel, {})
		end
	else
		local CurrentChannel = p5:GetCurrentChannel()

		if CurrentChannel then
			Util:SendSystemMessageToSelf(string.gsub(ChatLocalization:Get("GameChat_SwitchChannel_NotInChannel", string.format("You are not in channel: '%s'", v9), {
				RBX_NAME = v9
			}), "{RBX_NAME}", v9), CurrentChannel, {
				ChatColor = Color3.fromRGB(245, 50, 50)
			})
		end
	end

	return true
end

return {
	[Util.KEY_COMMAND_PROCESSOR_TYPE] = Util.COMPLETED_MESSAGE_PROCESSOR,
	[Util.KEY_PROCESSOR_FUNCTION] = ProcessMessage
}
