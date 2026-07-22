local Parent = script:FindFirstAncestor("FriendsChat").Parent
local React = require(Parent.React)
local UserTile = require(Parent.UserTile).UserTile
local LayoutMode = require(Parent.UserTile).LayoutMode
local getFacePileParticipantIds = require(script.Parent.getFacePileParticipantIds)
local useFacePilePresence = require(script.Parent.useFacePilePresence)

local function FriendsChatFacePile(t1: {[any]: any}) -- line: 32
	-- upvalues: getFacePileParticipantIds (copy), useFacePilePresence (copy), React (copy), UserTile (copy), LayoutMode (copy)
	local v9 = t1.participantUserIds ~= nil and #t1.participantUserIds > 0
	local v10 = getFacePileParticipantIds(t1.participantUserIds or {}, t1.localUserId)
	local v11 = useFacePilePresence(v10)

	if not v9 then
		return nil
	end

	return React.createElement(UserTile, {
		userId = tostring(v10[1]),
		facePileSecondUserId = if not v10[2] then nil else tostring(v10[2]),
		layoutMode = LayoutMode.wide,
		title = t1.titleText,
		titleStyle = t1.titleStyle,
		userPresenceType = v11,
		onActivated = t1.onActivated,
		selectable = t1.selectable,
		customTextTruncation = Enum.TextTruncate.SplitWord
	})
end

return FriendsChatFacePile
