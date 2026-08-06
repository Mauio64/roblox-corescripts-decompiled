local Parent = script:FindFirstAncestor("FriendsChat").Parent
local React = require(Parent.React)
local FFlagAppChatSanitizeConversationTitleRichText = require(Parent.SharedFlags).FFlagAppChatSanitizeConversationTitleRichText
local UserTile = require(Parent.UserTile).UserTile
local LayoutMode = require(Parent.UserTile).LayoutMode
local escapeRichText = require(Parent.ChatUIPrimitives).Utils.escapeRichText
local getFacePileParticipantIds = require(script.Parent.getFacePileParticipantIds)
local useFacePilePresence = require(script.Parent.useFacePilePresence)

local function FriendsChatFacePile(t1: {[any]: any}) -- line: 35
	-- upvalues: getFacePileParticipantIds (copy), useFacePilePresence (copy), React (copy), UserTile (copy), LayoutMode (copy), FFlagAppChatSanitizeConversationTitleRichText (copy), escapeRichText (copy)
	local v11 = t1.participantUserIds ~= nil and #t1.participantUserIds > 0
	local v12 = getFacePileParticipantIds(t1.participantUserIds or {}, t1.localUserId)
	local v13 = useFacePilePresence(v12)

	if not v11 then
		return nil
	end

	return React.createElement(UserTile, {
		userId = tostring(v12[1]),
		facePileSecondUserId = if not v12[2] then nil else tostring(v12[2]),
		layoutMode = LayoutMode.wide,
		title = if not FFlagAppChatSanitizeConversationTitleRichText or not t1.titleText then t1.titleText else escapeRichText(t1.titleText),
		titleStyle = t1.titleStyle,
		userPresenceType = v13,
		onActivated = t1.onActivated,
		selectable = t1.selectable,
		customTextTruncation = Enum.TextTruncate.SplitWord
	})
end

return FriendsChatFacePile
