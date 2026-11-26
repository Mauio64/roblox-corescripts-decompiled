local GetFFlagExpChatUseIsDefaultTextChannel = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Flags/GetFFlagExpChatUseIsDefaultTextChannel")

local function markTextChannelAsDefault(p2)
	if not GetFFlagExpChatUseIsDefaultTextChannel() then
		return
	end

	p2.IsDefaultTextChannel = true
end

return markTextChannelAsDefault
