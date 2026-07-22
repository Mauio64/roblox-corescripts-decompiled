local function getReplyLabelDescriptor(t1: {[any]: any}) -- line: 35
	local senderIsLocalUser = t1.senderIsLocalUser
	local senderRepliedToSelf = t1.senderRepliedToSelf
	local senderRepliedToLocalUser = t1.senderRepliedToLocalUser

	if senderIsLocalUser and senderRepliedToSelf then
		return "Feature.Chat.Label.YouRepliedToYou"
	end

	if not t1.isGroup then
		if senderIsLocalUser and not senderRepliedToSelf then
			return "Feature.Chat.Label.OneToOne.YouRepliedToThem"
		end

		if not senderIsLocalUser and senderRepliedToLocalUser then
			return "Feature.Chat.Label.OneToOne.ThemRepliedToYou"
		end

		if not senderIsLocalUser and senderRepliedToSelf then
			return "Feature.Chat.Label.OneToOne.ThemRepliedToThem"
		end
	else
		if senderIsLocalUser and not senderRepliedToSelf then
			return {
				"Feature.Chat.Label.Group.YouRepliedToThem",
				DISPLAY_NAME = t1.repliedToName
			}
		end

		if not senderIsLocalUser and senderRepliedToLocalUser then
			return {
				"Feature.Chat.Label.Group.ThemRepliedToYou",
				DISPLAY_NAME = t1.senderName
			}
		end

		if not senderIsLocalUser and senderRepliedToSelf then
			return {
				"Feature.Chat.Label.Group.ThemRepliedToThem",
				DISPLAY_NAME = t1.senderName
			}
		end

		if not senderIsLocalUser and not senderRepliedToLocalUser then
			return {
				"Feature.Chat.Label.Group.ThemRepliedToOther",
				DISPLAY_NAME_1 = t1.senderName,
				DISPLAY_NAME_2 = t1.repliedToName
			}
		end
	end

	return "Feature.Chat.Label.UnknownUser"
end

return getReplyLabelDescriptor
