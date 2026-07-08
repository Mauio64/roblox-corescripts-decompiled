local Parent = script:FindFirstAncestor("AppChat").Parent

require(Parent.AppChatNetworking)

return {
	default = {
		modal_variant = "none",
		modal_layout = {
			id = "",
			seen_record_action = "none",
			dismissed_record_action = "none"
		}
	}
}
