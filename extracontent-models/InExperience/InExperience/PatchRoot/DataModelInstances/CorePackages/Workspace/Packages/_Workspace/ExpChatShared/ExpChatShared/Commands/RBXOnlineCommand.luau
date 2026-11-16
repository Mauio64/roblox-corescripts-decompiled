local TextChatService = game:GetService("TextChatService")

local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local Logger = require(ExpChatShared.Logger)
local v = Logger:new("ExpChat/Command/Online")

require(script.Parent.types)

local FFlagExpChatUseUpdatedUserCountStrings = require(ExpChatShared.Flags.FFlagExpChatUseUpdatedUserCountStrings)

return {
	name = script.Name,
	alias = { "/online" },
	clientRun = function(_, p, _, _)
		local success, result = pcall(function()
			return TextChatService:GetChatableUserCountAsync(p, "local")
		end)

		if not success then
			v:warning("GetChatableUserCountAsync ({}) failed: {}", "local", (tostring(result)))
			return nil
		end

		local v2

		if FFlagExpChatUseUpdatedUserCountStrings then
			v2 = result == 1 and "CoreScripts.TextChat.Online.Success.Singular3"
				or "CoreScripts.TextChat.Online.Success.Plural2"
		else
			v2 = result == 1 and "CoreScripts.TextChat.Online.Success.Singular"
				or "CoreScripts.TextChat.Online.Success.Plural"
		end

		return {
			key = v2,
			metadata = "Roblox.Online.Info",
			args = { RBX_COUNT = result }
		}
	end
}
