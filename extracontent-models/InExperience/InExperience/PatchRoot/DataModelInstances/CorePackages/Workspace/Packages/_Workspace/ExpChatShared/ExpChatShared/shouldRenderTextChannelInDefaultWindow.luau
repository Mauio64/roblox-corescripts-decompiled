local parent = script.Parent
local GetFFlagExpChatUseIsDefaultTextChannel = require(parent.Flags.GetFFlagExpChatUseIsDefaultTextChannel)

local function shouldRenderTextChannelInDefaultWindow(p, p2): boolean
	if not GetFFlagExpChatUseIsDefaultTextChannel() then
		return true
	end

	return p2 == nil or p2.Value ~= 1 or p == nil or p.IsDefaultTextChannel == true
end

return shouldRenderTextChannelInDefaultWindow
