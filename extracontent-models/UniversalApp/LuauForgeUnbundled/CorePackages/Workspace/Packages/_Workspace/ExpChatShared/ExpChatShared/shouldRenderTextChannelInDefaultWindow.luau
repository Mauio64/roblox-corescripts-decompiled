local GetFFlagExpChatUseIsDefaultTextChannel = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Flags/GetFFlagExpChatUseIsDefaultTextChannel")

local function shouldRenderTextChannelInDefaultWindow(p2, p3): boolean
	if not GetFFlagExpChatUseIsDefaultTextChannel() or (p3 == nil or p3.Value ~= 1) or p2 == nil then
		return true
	end

	return p2.IsDefaultTextChannel == true
end

return shouldRenderTextChannelInDefaultWindow
