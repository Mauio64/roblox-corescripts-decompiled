local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local Packages = script:FindFirstAncestor("Packages")
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)
require(AppChatNetworking.responses.SharedTypes)
local Loggers = require(Packages.Loggers)
local v = Loggers.Logger:new(script.Name)

local RoduxNetworking = require(script.Parent.RoduxNetworking)

return RoduxNetworking.POST(
	script.Name,
	function(callback, action_type, modal_sequence: string, modal_id: string, modal_variant: string, conversation_id, friend_id)
		if conversation_id and friend_id then
			v:warn("Both conversation ID and friend ID provided to RecordModalSequenceResponse.")
		end

		return callback(CHAT_PLATFORM_BASE_URL):path("v1"):path("record-modal-sequence-response"):body({
			action_type = action_type,
			modal_sequence = modal_sequence,
			modal_id = modal_id,
			modal_variant = modal_variant,
			conversation_id = conversation_id,
			friend_id = friend_id
		})
	end
)
