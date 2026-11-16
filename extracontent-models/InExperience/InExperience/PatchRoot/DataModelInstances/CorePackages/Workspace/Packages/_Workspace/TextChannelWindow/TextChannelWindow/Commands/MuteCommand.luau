local parent = script:FindFirstAncestor("TextChannelWindow").Parent

local ChatMute = require(parent.ChatMute)

return {
	aliases = { "/mute", "/m" },
	run = function(value: string, p: string)
		local v = string.split(value, " ")[2]
		local muteTarget = ChatMute.resolveMuteTarget(v, p)

		if muteTarget.playerInfo then
			ChatMute.mutePlayer(muteTarget.playerInfo)
		end

		return { key = muteTarget.key, args = muteTarget.args }
	end
}
