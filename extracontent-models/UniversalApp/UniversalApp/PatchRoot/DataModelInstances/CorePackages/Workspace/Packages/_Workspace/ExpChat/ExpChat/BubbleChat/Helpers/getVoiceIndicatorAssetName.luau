local ExpChat = script:FindFirstAncestor("ExpChat")
local GetFFlagExpChatEnableVoiceReverseNudge = require(ExpChat.Flags.GetFFlagExpChatEnableVoiceReverseNudge)

return function(p1, n1: number, s1: string, b1: boolean) -- line: 4
	-- upvalues: GetFFlagExpChatEnableVoiceReverseNudge (copy)
	if p1 == "Connecting" then
		return "icons/controls/voice/" .. s1 .. "_0_dark"
	end

	if p1 == "Muted" or p1 == "LOCAL_MUTED" then
		return "icons/controls/voice/" .. s1 .. "_off_light"
	end

	if p1 == "Inactive" or p1 == "Connecting" then
		return "icons/controls/voice/" .. s1 .. "_0_light"
	end

	local v8

	if p1 == "Talking" then
		local v7 = math.floor(n1 * 5 + 0.5) * 20

		v8 = "icons/controls/voice/" .. s1 .. "_" .. tostring(v7) .. "_light"

		if GetFFlagExpChatEnableVoiceReverseNudge() then
			return "icons/controls/voice/" .. (not b1 and "" or "red_") .. s1 .. "_" .. tostring(v7) .. "_light"
		end
	else
		v8 = "icons/controls/voice/" .. s1 .. "_error_light"
	end

	return v8
end
