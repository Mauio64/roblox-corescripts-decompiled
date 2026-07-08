require(script.Parent.VoiceChatServiceManager)

local t1 = {
	voice = "voice",
	text = "text",
	other = "other"
}

function GetDefaultMethodOfAbuse(t2: {[any]: any}?, p1) -- line: 14
	-- upvalues: t1 (copy)
	if t2 then
		if p1:getRecentUsersInteractionData()[tostring(t2.UserId)] then
			return t1.voice
		end

		return t1.text
	end

	if p1:GetMutedAnyone() then
		return t1.voice
	end

	return t1.text
end

return {
	MethodsOfAbuse = t1,
	GetDefaultMethodOfAbuse = GetDefaultMethodOfAbuse
}
