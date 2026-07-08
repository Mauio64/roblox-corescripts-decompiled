local Modules = game:GetService("CoreGui").RobloxGui.Modules
local getFFlagEnableShimmeringIconLegacyChatService = require(Modules.Flags.getFFlagEnableShimmeringIconLegacyChatService)

return function(p1, n1: number, s1: string) -- line: 5
	-- upvalues: getFFlagEnableShimmeringIconLegacyChatService (copy)
	if getFFlagEnableShimmeringIconLegacyChatService() and p1 == "Connecting" then
		return "icons/controls/voice/" .. s1 .. "_0_dark"
	end

	if p1 == "Muted" or p1 == "LOCAL_MUTED" then
		return "icons/controls/voice/" .. s1 .. "_off_light"
	end

	if p1 == "Inactive" or p1 == "Connecting" then
		return "icons/controls/voice/" .. s1 .. "_0_light"
	end

	if p1 == "Talking" then
		return "icons/controls/voice/" .. s1 .. "_" .. tostring(math.floor(n1 * 5 + 0.5) * 20) .. "_light"
	end

	return "icons/controls/voice/" .. s1 .. "_error_light"
end
