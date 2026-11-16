require(script.Parent.VoiceChatServiceManager)

local methodsOfAbuse = { voice = "voice", text = "text", other = "other" }

function GetDefaultMethodOfAbuse(p, object)
	if p then
		if object:getRecentUsersInteractionData()[tostring(p.UserId)] then
			return methodsOfAbuse.voice
		end

		return methodsOfAbuse.text
	elseif object:GetMutedAnyone() then
		return methodsOfAbuse.voice
	else
		return methodsOfAbuse.text
	end
end

return { MethodsOfAbuse = methodsOfAbuse, GetDefaultMethodOfAbuse = GetDefaultMethodOfAbuse }
