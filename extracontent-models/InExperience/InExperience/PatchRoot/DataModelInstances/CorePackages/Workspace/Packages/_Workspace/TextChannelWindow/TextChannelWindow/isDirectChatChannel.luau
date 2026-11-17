local SharedFlags = require(script:FindFirstAncestor("TextChannelWindow").Parent.SharedFlags)
local FFlagExpChatWhisperSetDirectChatRequester = SharedFlags.FFlagExpChatWhisperSetDirectChatRequester
local FFlagExpChatIgnoreWhisperNameForDirectChat = SharedFlags.FFlagExpChatIgnoreWhisperNameForDirectChat

local function isDirectChatChannel(p): boolean
	if
		FFlagExpChatWhisperSetDirectChatRequester and FFlagExpChatIgnoreWhisperNameForDirectChat
		or string.sub(p.Name, 1, 10) ~= "RBXWhisper"
	then
		return p.DirectChatRequester ~= nil
	end

	return true
end

return isDirectChatChannel
