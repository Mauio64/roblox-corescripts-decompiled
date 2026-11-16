local function getReplyLabelDescriptor(data)
	local senderIsLocalUser = data.senderIsLocalUser
	local senderRepliedToSelf = data.senderRepliedToSelf
	local senderRepliedToLocalUser = data.senderRepliedToLocalUser

	if senderIsLocalUser and senderRepliedToSelf then
		return "Feature.Chat.Label.YouRepliedToYou"
	end

	if data.isGroup then
		if senderIsLocalUser and not senderRepliedToSelf then
			return {
				"Feature.Chat.Label.Group.YouRepliedToThem",
				DISPLAY_NAME = data.repliedToName
			}
		end

		if not senderIsLocalUser and senderRepliedToLocalUser then
			return {
				"Feature.Chat.Label.Group.ThemRepliedToYou",
				DISPLAY_NAME = data.senderName
			}
		end

		if senderIsLocalUser or not senderRepliedToSelf then
			if not (senderIsLocalUser or senderRepliedToLocalUser) then
				return {
					"Feature.Chat.Label.Group.ThemRepliedToOther",
					DISPLAY_NAME_1 = data.senderName,
					DISPLAY_NAME_2 = data.repliedToName
				}
			end
		else
			return {
				"Feature.Chat.Label.Group.ThemRepliedToThem",
				DISPLAY_NAME = data.senderName
			}
		end
	else
		if senderIsLocalUser and not senderRepliedToSelf then
			return "Feature.Chat.Label.OneToOne.YouRepliedToThem"
		end

		if senderIsLocalUser or not senderRepliedToLocalUser then
			if not senderIsLocalUser and senderRepliedToSelf then
				return "Feature.Chat.Label.OneToOne.ThemRepliedToThem"
			end
		else
			return "Feature.Chat.Label.OneToOne.ThemRepliedToYou"
		end
	end

	return "Feature.Chat.Label.UnknownUser"
end

return getReplyLabelDescriptor
