local TextChatService = game:GetService("TextChatService")

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Logger"):new("ExpChat/GlobalCommand/Online")

require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/GlobalCommands/types")

local FFlagExpChatUseUpdatedUserCountStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Flags/FFlagExpChatUseUpdatedUserCountStrings")

return {
	name = "GlobalOnlineCommand",
	alias = { "/online" },
	clientRun = function(p2, p3, p4, p5)
		local success, result = pcall(function()
			return TextChatService:GetChatableUserCountAsync(p3, "global")
		end)

		if not success then
			v5:warning("GetChatableUserCountAsync ({}) failed: {}", "global", (tostring(result)))
			return nil
		end

		return {
			key = if FFlagExpChatUseUpdatedUserCountStrings then result == 1 and "CoreScripts.TextChat.Online.Success.Singular3" or "CoreScripts.TextChat.Online.Success.Plural2" else result == 1 and "CoreScripts.TextChat.Online.Success.Singular" or "CoreScripts.TextChat.Online.Success.Plural",
			metadata = "Roblox.GlobalOnline.Info",
			args = { RBX_COUNT = result }
		}
	end
}
