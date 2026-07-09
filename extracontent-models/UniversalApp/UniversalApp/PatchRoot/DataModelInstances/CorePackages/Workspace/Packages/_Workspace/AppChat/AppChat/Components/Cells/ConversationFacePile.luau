local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Logger = require(AppChatParent.Loggers).Logger
local React = require(AppChatParent.React)
local useLocalUserId = require(AppChatParent.RobloxAppHooks).useLocalUserId
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local Foundation = require(AppChatParent.Foundation)
local FFlagEnableBlackbirdCheck = require(AppChatParent.SharedFlags).FFlagEnableBlackbirdCheck
local useIsRobloxSubscriber = require(AppChatParent.UserProfiles).Hooks.useIsRobloxSubscriber
local UserTile = require(AppChatParent.UserTile).UserTile
local LayoutMode = require(AppChatParent.UserTile).LayoutMode
local RoduxPresence = require(AppChat.Http.RoduxPresence)
local v13 = Logger:new(script.Name)
local useFoundationPresence = require(AppChat.Hooks.useFoundationPresence)
local PresenceType = RoduxPresence.Enums.PresenceType
local UserPresence = Foundation.Enums.UserPresence

local function getParticipantId(p1) -- line: 51
	if type(p1) == "table" then
		local v22 = p1.id or p1.userId

		if v22 ~= nil then
			return (tostring(v22))
		end

		return nil
	end

	if p1 ~= nil then
		return (tostring(p1))
	end

	return nil
end
local function getNonEmptyLocalUserId(p2) -- line: 60
	if p2 == nil or p2 == "" then
		return nil
	end

	return (tostring(p2))
end
local function ConversationFacePileInner(t1: {[any]: any}) -- line: 68
	-- upvalues: useLocalUserId (copy), React (copy), useSelector (copy), useFoundationPresence (copy), UserPresence (copy), PresenceType (copy), FFlagEnableBlackbirdCheck (copy), useIsRobloxSubscriber (copy), UserTile (copy), LayoutMode (copy)
	local conversationId = t1.conversationId
	local v26 = useLocalUserId()
	local localUserId = t1.localUserId
	local v28 = ((if localUserId ~= nil and localUserId ~= "" then tostring(localUserId) else nil)) or (((if v26 ~= nil and v26 ~= "" then tostring(v26) else nil)) or "")
	local v29 = React.useCallback(function(p3) -- line: 73
		-- upvalues: conversationId (copy)
		if p3 and (p3.ChatAppReducer and p3.ChatAppReducer.Conversations) then
			return p3.ChatAppReducer.Conversations[conversationId]
		end

		return nil
	end, { conversationId })
	local v30 = useSelector(v29)
	local v31 = useSelector(function(p4) -- line: 81
		if p4 and (p4.ChatAppReducer and p4.ChatAppReducer.Presence) then
			return p4.ChatAppReducer.Presence.byUserId
		end

		return nil
	end)
	local v32 = t1.participants or if not v30 or not v30.participants then {} else v30.participants
	local t2 = {}

	if #v32 == 1 then
		table.insert(t2, v28)
	else
		for _, v35 in v32 do
			local v37

			if type(v35) == "table" then
				local v36 = v35.id or v35.userId

				v37 = if v36 == nil then nil else tostring(v36)
			else
				v37 = if v35 == nil then nil else tostring(v35)
			end

			if v37 and tostring(v37) ~= tostring(v28) then
				table.insert(t2, v37)
			end
		end
	end

	local v38 = t2[1] or v28
	local v39 = useFoundationPresence(v38)
	local None = UserPresence.None

	if #t2 >= 2 then
		local v41 = false
		local v42 = false

		for _, v44 in t2 do
			if v31 and v31[v44] then
				local userPresenceType = v31[v44].userPresenceType

				if userPresenceType == PresenceType.InGame or userPresenceType == PresenceType.InStudio then
					v41 = true
				elseif userPresenceType == PresenceType.Online then
					v42 = true
				end
			end
		end

		if v41 then
			None = UserPresence.InExperience
		elseif v42 then
			None = UserPresence.Active
		end
	else
		None = v39.presence
	end

	local str = nil

	if FFlagEnableBlackbirdCheck and #v32 == 2 then
		for _, v48 in v32 do
			local v50

			if type(v48) == "table" then
				local v49 = v48.id or v48.userId

				v50 = if v49 == nil then nil else tostring(v49)
			else
				v50 = if v48 == nil then nil else tostring(v48)
			end

			if v50 and tostring(v50) ~= tostring(v28) then
				str = tostring(v50)

				break
			end
		end
	end

	local v51 = useIsRobloxSubscriber(str)

	return React.createElement(UserTile, {
		userId = v38,
		facePileSecondUserId = t2[2] or nil,
		layoutMode = LayoutMode.wide,
		title = t1.titleText,
		subtitle = t1.subtitleText,
		titleStyle = t1.titleStyle,
		subtitleStyle = t1.subtitleStyle,
		userPresenceType = None,
		onActivated = t1.onActivated,
		selectable = t1.selectable,
		customTextTruncation = Enum.TextTruncate.SplitWord,
		trustedConnectionIndicatorEnabled = t1.trustedConnectionIndicatorEnabled,
		isRobloxSubscriber = if not FFlagEnableBlackbirdCheck then nil else v51
	})
end
local function ConversationFacePile(t3: {[any]: any}) -- line: 162
	-- upvalues: v13 (copy), React (copy), ConversationFacePileInner (copy)
	local conversationId = t3.conversationId

	if not conversationId or conversationId == "" then
		v13:warning("conversationId cannot be nil nor an empty string")

		return nil
	end

	local v54 = table.clone(t3)

	v54.conversationId = conversationId

	return React.createElement(ConversationFacePileInner, v54)
end

return ConversationFacePile
