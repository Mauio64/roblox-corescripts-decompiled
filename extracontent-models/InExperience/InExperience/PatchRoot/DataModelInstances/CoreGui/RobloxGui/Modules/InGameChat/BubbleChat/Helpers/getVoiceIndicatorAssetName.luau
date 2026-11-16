local CoreGui = game:GetService("CoreGui")
local Modules = CoreGui.RobloxGui.Modules
local getFFlagEnableShimmeringIconLegacyChatService = require(Modules.Flags.getFFlagEnableShimmeringIconLegacyChatService)

return function(p, p2: number, p3: string)
	if getFFlagEnableShimmeringIconLegacyChatService() and p == "Connecting" then
		return "icons/controls/voice/" .. p3 .. "_0_dark"
	end

	if p == "Muted" or p == "LOCAL_MUTED" then
		return "icons/controls/voice/" .. p3 .. "_off_light"
	end

	if p == "Inactive" or p == "Connecting" then
		return "icons/controls/voice/" .. p3 .. "_0_light"
	end

	if p == "Talking" then
		return "icons/controls/voice/" .. p3 .. "_" .. tostring(math.floor(p2 * 5 + 0.5) * 20) .. "_light"
	end

	return "icons/controls/voice/" .. p3 .. "_error_light"
end
