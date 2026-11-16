local v = nil
local VoiceDebugConsoleV2TestOverride = {}

function VoiceDebugConsoleV2TestOverride.get()
	return v
end

function VoiceDebugConsoleV2TestOverride.setForTesting(flag: boolean?)
	local v2 = v
	v = flag
	return v2
end

return VoiceDebugConsoleV2TestOverride
