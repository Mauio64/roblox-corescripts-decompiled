local parent = script:FindFirstAncestor("TextChannelWindow").Parent

local ChatMute = require(parent.ChatMute)

return {
	aliases = { "/unmute", "/um" },
	run = function(value: string, p: string)
		local v = string.split(value, " ")[2]
		local unmuteTarget = ChatMute.resolveUnmuteTarget(v, p)

		if unmuteTarget.playerInfo then
			ChatMute.unmutePlayer(unmuteTarget.playerInfo)
		end

		return { key = unmuteTarget.key, args = unmuteTarget.args }
	end
}
