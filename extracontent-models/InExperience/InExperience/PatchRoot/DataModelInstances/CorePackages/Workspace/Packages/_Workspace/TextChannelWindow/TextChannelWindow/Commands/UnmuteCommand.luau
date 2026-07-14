local Parent = script:FindFirstAncestor("TextChannelWindow").Parent
local ChatMute = require(Parent.ChatMute)

return {
	aliases = {
		"/unmute",
		"/um"
	},
	run = function(s1: string, s2: string) -- line: 8
		-- upvalues: ChatMute (copy)
		local v5 = string.split(s1, " ")[2]
		local v6 = ChatMute.resolveUnmuteTarget(v5, s2)

		if v6.playerInfo then
			ChatMute.unmutePlayer(v6.playerInfo)
		end

		return {
			key = v6.key,
			args = v6.args
		}
	end
}
