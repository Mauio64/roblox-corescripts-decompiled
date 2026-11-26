local CHAT_PLATFORM_BASE_URL = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/url/CHAT_PLATFORM_BASE_URL")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/responses/SharedTypes")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger:new("RecordModalSequenceResponse")

return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/rodux/RoduxNetworking").POST("RecordModalSequenceResponse", function(callback, p2, p3, p4, p5, p6, p7)
	if p6 and p7 then
		v5:warn("Both conversation ID and friend ID provided to RecordModalSequenceResponse.")
	end

	return callback(CHAT_PLATFORM_BASE_URL):path("v1"):path("record-modal-sequence-response"):body({
		action_type = p2,
		modal_sequence = p3,
		modal_id = p4,
		modal_variant = p5,
		conversation_id = p6,
		friend_id = p7
	})
end)
