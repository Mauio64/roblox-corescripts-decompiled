local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local Packages = script:FindFirstAncestor("Packages")
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)

require(AppChatNetworking.responses.SharedTypes)

local v4 = require(Packages.Loggers).Logger:new(script.Name)

return require(script.Parent.RoduxNetworking).POST(script.Name, function(p1, p2, s1: string, s2: string, s3: string, p3, p4) -- line: 11
	-- upvalues: v4 (copy), CHAT_PLATFORM_BASE_URL (copy)
	if p3 and p4 then
		v4:warn("Both conversation ID and friend ID provided to RecordModalSequenceResponse.")
	end

	local t1 = {
		action_type = p2,
		modal_sequence = s1,
		modal_id = s2,
		modal_variant = s3,
		conversation_id = p3,
		friend_id = p4
	}

	return p1(CHAT_PLATFORM_BASE_URL):path("v1"):path("record-modal-sequence-response"):body(t1)
end)
