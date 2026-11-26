require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/AppChatNetworking")

local v5 = { View = "RecordHasSeen", Close = "RecordDontShowAgain" }

local v6 = { [v5.View] = "record_has_seen", [v5.Close] = "record_dont_show_again" }

return {
	ModalAction = v5,
	toRecordedModalAction = function(value)
		if typeof(value) == "string" then
			return v6[value]
		end

		return nil
	end
}
