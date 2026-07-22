local TextChatService = game:GetService("TextChatService")
local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local v3 = require(ExpChatShared.Logger):new("ExpChat/Command/Online")

require(script.Parent.types)

local FFlagExpChatUseUpdatedUserCountStrings = require(ExpChatShared.Flags.FFlagExpChatUseUpdatedUserCountStrings)

return {
	name = script.Name,
	alias = { "/online" },
	clientRun = function(_, p2, _, _) -- line: 15
		-- upvalues: TextChatService (copy), v3 (copy), FFlagExpChatUseUpdatedUserCountStrings (copy)
		local ok, result = pcall(function() -- line: 16
			-- upvalues: TextChatService (copy), p2 (copy)
			return TextChatService:GetChatableUserCountAsync(p2, "local")
		end)

		if not ok then
			v3:warning("GetChatableUserCountAsync ({}) failed: {}", "local", (tostring(result)))

			return nil
		end

		local v11 = if not FFlagExpChatUseUpdatedUserCountStrings then result ~= 1 and "CoreScripts.TextChat.Online.Success.Plural" or "CoreScripts.TextChat.Online.Success.Singular" else result ~= 1 and "CoreScripts.TextChat.Online.Success.Plural2" or "CoreScripts.TextChat.Online.Success.Singular3"

		return {
			metadata = "Roblox.Online.Info",
			key = v11,
			args = {
				RBX_COUNT = result
			}
		}
	end
}
