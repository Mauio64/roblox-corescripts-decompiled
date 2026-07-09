local TextChatService = game:GetService("TextChatService")
local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local v3 = require(ExpChatShared.Logger):new("ExpChat/GlobalCommand/Online")

require(script.Parent.types)

return {
	name = script.Name,
	alias = { "/online" },
	clientRun = function(_, p2, _, _) -- line: 13
		-- upvalues: TextChatService (copy), v3 (copy)
		local ok, result = pcall(function() -- line: 14
			-- upvalues: TextChatService (copy), p2 (copy)
			return TextChatService:GetChatableUserCountAsync(p2, "global")
		end)

		if not ok then
			v3:warning("GetChatableUserCountAsync ({}) failed: {}", "global", (tostring(result)))

			return nil
		end

		local v10 = result ~= 1 and "CoreScripts.TextChat.Online.Success.Plural" or "CoreScripts.TextChat.Online.Success.Singular"

		return {
			metadata = "Roblox.GlobalOnline.Info",
			key = v10,
			args = {
				RBX_COUNT = result
			}
		}
	end
}
