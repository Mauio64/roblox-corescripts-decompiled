local parent = script:FindFirstAncestor("FriendsChat").Parent

local React = require(parent.React)
local UserTile = require(parent.UserTile)
local userTile = UserTile.UserTile
local UserTile2 = require(parent.UserTile)
local LayoutMode = UserTile2.LayoutMode
local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local escapeRichText = ChatUIPrimitives.Utils.escapeRichText

local getFacePileParticipantIds = require(script.Parent.getFacePileParticipantIds)
local useFacePilePresence = require(script.Parent.useFacePilePresence)

local function FriendsChatFacePile(props)
	local v

	if props.participantUserIds == nil then
		v = false
	else
		v = #props.participantUserIds > 0
	end

	local facePileParticipantIds = getFacePileParticipantIds(props.participantUserIds or {}, props.localUserId)
	local userPresenceType = useFacePilePresence(facePileParticipantIds)

	if not v then
		return nil
	end

	local createElement = React.createElement
	local v2 = {
		userId = tostring(facePileParticipantIds[1]),
		facePileSecondUserId = 0,
		layoutMode = 0,
		title = 0,
		titleStyle = 0,
		userPresenceType = 0,
		onActivated = 0,
		selectable = 0,
		customTextTruncation = 0
	}
	local facePileSecondUserId

	if facePileParticipantIds[2] then
		facePileSecondUserId = tostring(facePileParticipantIds[2])
	end

	v2.facePileSecondUserId = facePileSecondUserId
	v2.layoutMode = LayoutMode.wide
	local title

	if props.titleText then
		title = escapeRichText(props.titleText)
	else
		title = props.titleText
	end

	v2.title = title
	v2.titleStyle = props.titleStyle
	v2.userPresenceType = userPresenceType
	v2.onActivated = props.onActivated
	v2.selectable = props.selectable
	v2.customTextTruncation = Enum.TextTruncate.SplitWord
	return createElement(userTile, v2)
end

return FriendsChatFacePile
