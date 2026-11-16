local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local llama = require(parent.llama)
local set = llama.Set

local getOtherDisplayNameInWhisperChannel = require(ExpChat.getOtherDisplayNameInWhisperChannel)

local v = {}

return function(p, p2)
	local v2 = p.TextChannel
		and string.find(p.TextChannel.Name, "^RBXWhisper")
		and not set.has(v, p.TextChannel)
		and getOtherDisplayNameInWhisperChannel(p.TextChannel, p2)

	if not v2 then
		return nil
	end

	v = set.add(v, p.TextChannel)
	return {
		key = "CoreScripts.TextChat.Notification.WhisperChat.Created",
		args = { RBX_NAME = v2 },
		metadata = "Roblox.Whisper.Welcome.Sent"
	}
end
