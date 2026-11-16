local parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent

require(parent.AppChatNetworking)

local modalAction = { View = "RecordHasSeen", Close = "RecordDontShowAgain" }

local v = { [modalAction.View] = "record_has_seen", [modalAction.Close] = "record_dont_show_again" }

return {
	ModalAction = modalAction,
	toRecordedModalAction = function(value)
		if typeof(value) == "string" then
			return v[value]
		end

		return nil
	end
}
