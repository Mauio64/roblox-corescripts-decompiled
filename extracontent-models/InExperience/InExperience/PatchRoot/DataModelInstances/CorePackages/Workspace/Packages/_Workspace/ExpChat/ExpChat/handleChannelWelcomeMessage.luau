local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Set = require(ExpChatParent.llama).Set
local getOtherDisplayNameInWhisperChannel = require(ExpChat.getOtherDisplayNameInWhisperChannel)
local t1 = {}

return function(p1, p2) -- line: 14
	-- upvalues: Set (copy), t1 (ref), getOtherDisplayNameInWhisperChannel (copy)
	if p1.TextChannel and (string.find(p1.TextChannel.Name, "^RBXWhisper") and not Set.has(t1, p1.TextChannel)) then
		local v8 = getOtherDisplayNameInWhisperChannel(p1.TextChannel, p2)

		if v8 then
			t1 = Set.add(t1, p1.TextChannel)

			return {
				key = "CoreScripts.TextChat.Notification.WhisperChat.Created",
				metadata = "Roblox.Whisper.Welcome.Sent",
				args = {
					RBX_NAME = v8
				}
			}
		end
	end

	return nil
end
