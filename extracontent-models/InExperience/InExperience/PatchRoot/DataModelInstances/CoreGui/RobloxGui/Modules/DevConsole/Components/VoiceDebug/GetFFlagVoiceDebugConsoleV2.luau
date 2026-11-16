game:DefineFastFlag("VoiceDebugConsoleV2", false)

local VoiceDebugConsoleV2TestOverride = require(script.Parent.VoiceDebugConsoleV2TestOverride)

return function()
	local v = VoiceDebugConsoleV2TestOverride.get()

	if v == nil then
		return game:GetFastFlag("VoiceDebugConsoleV2")
	end

	return v
end
