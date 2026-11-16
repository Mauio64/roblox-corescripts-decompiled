local ExpChat = script:FindFirstAncestor("ExpChat")
local GetFFlagExpChatEnableVoiceReverseNudge = require(ExpChat.Flags.GetFFlagExpChatEnableVoiceReverseNudge)

return function(p, p2: number, p3: string, flag: boolean)
	if p == "Connecting" then
		return "icons/controls/voice/" .. p3 .. "_0_dark"
	end

	if p == "Muted" or p == "LOCAL_MUTED" then
		return "icons/controls/voice/" .. p3 .. "_off_light"
	end

	if p == "Inactive" or p == "Connecting" then
		return "icons/controls/voice/" .. p3 .. "_0_light"
	end

	local v

	if p ~= "Talking" then
		return "icons/controls/voice/" .. p3 .. "_error_light"
	end

	local v2 = math.floor(p2 * 5 + 0.5) * 20
	v = "icons/controls/voice/" .. p3 .. "_" .. tostring(v2) .. "_light"

	if GetFFlagExpChatEnableVoiceReverseNudge() then
		return "icons/controls/voice/" .. (flag and "red_" or "") .. p3 .. "_" .. tostring(v2) .. "_light"
	end

	return v
end
