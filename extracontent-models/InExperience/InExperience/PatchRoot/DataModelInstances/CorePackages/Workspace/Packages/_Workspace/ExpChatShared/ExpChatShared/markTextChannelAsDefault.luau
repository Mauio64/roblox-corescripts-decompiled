local parent = script.Parent
local GetFFlagExpChatUseIsDefaultTextChannel = require(parent.Flags.GetFFlagExpChatUseIsDefaultTextChannel)

local function markTextChannelAsDefault(p)
	if not GetFFlagExpChatUseIsDefaultTextChannel() then
		return
	end

	p.IsDefaultTextChannel = true
end

return markTextChannelAsDefault
